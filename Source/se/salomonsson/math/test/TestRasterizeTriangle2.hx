package se.salomonsson.math.test;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.Lib;
import haxe.Timer;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;


@:bitmap("assets/gfx/uv.png")
class UVTexture extends flash.display.BitmapData {}



// JUST A QUICK MIX OF TestRasterizeTriangle1 with TestFilledPolygon!

class TestRasterizeTriangle2 extends Sprite {


	// how to rasterize a triangle
	// http://www.sunshine2k.de/coding/java/TriangleRasterization/TriangleRasterization.html

	// calculate texture coordinates (uv:s)
	// http://www.hugi.scene.org/online/coding/hugi%2017%20-%20cotriang.htm

	private var canvas:BitmapData;
	private static inline var W:Int = 300;
	private static inline var H:Int = 250;

	private var TEXTURE:BitmapData;
	private var TEXTURE_W:Int = 256;
	private var TEXTURE_H:Int = 256;
	private var CLEAR_COL:UInt = 0xffeeee;

	// TODO: Plug it into 3d model
	// TODO: z-buffer
	// TODO: Backface culling


	private var left_dCdY:Array<Float>; // step values for color each y along the left edge
	private var right_dCdY:Array<Float>; // step values for color each y along the right edge
	private var dCdX:Array<Float>; // upper segment




	private var kb:KeyboardHelper;
	private var t:Timer;
	private var points:Array<Array<Float>>;
	private var tris:Array<Array<Int>>;
	private var uvs:Array<Array<Float>>;
	private var rotY:Float = -0.031415926535897934;
	private var rotX:Float = 0;
	private var STAGEW:Float;
	private var STAGEH:Float;


	public function new() {
		super();
		canvas = new BitmapData(W,H, false, CLEAR_COL);
		var bitmap:Bitmap = new Bitmap(canvas);
		bitmap.x = 50;
		bitmap.y = 20;
		addChild(bitmap);

		TEXTURE = new UVTexture(0,0);



		STAGEW = W / 2.0;
		STAGEH = H / 2.0;

		kb = new KeyboardHelper(Lib.current.stage);

		points = [
			[-1,1,1],
			[1,1,1],
			[-1,-1,1],
			[1,-1,1],

			[-1,1,-1],
			[1,1,-1],
			[-1,-1,-1],
			[1,-1,-1]
		];

		uvs = [
			[0,0,	0,1,	1,0],
			[1,1,	1,0,	0,1]
		];

		tris = [
			[0,1,2, 0], [3,2,1, 1], //front
			[4,6,5, 0], [7,5,6, 1], // back
			[4,0,6, 0], [2,6,0, 1], // left side
			[1,5,3, 0], [7,3,5, 1], // right side
			[2,3,6, 0], [7,6,3, 1], // top
			[0,4,1, 0], [5,1,4, 1] // bottom
		];




		t = new Timer(16);
		t.run = update;

	}

	public function update():Void {
//		rot += 0.01;
		var spd:Float = Math.PI / 100.0;
		if(kb.keyIsDown(Keyboard.LEFT)) {
			rotY += spd;
		} else if (kb.keyIsDown(Keyboard.RIGHT)) {
			rotY -= spd;
		}
		if (kb.keyIsDown(Keyboard.UP)) {
			rotX += spd;
		} else if (kb.keyIsDown(Keyboard.DOWN)) {
			rotX -= spd;
		}
		
		if (kb.keyIsDown(Keyboard.SPACE)) {
			var tommy = 1;
			tommy += 1; // for breakpoint purposes!
		}

		var perspective = new Matrix(4,4);
		perspective.set([
			1,0,0,0,
			0,1,0,0,
			0,0,1,0,
			0,0,-(1/200),0
		]);

		var t = M4Helper.getTranslateMatrix(0,0,-4);
		var ry = M4Helper.getYRotationMatrix(Math.cos(rotY), Math.sin(rotY));
		var rx = M4Helper.getXRotationMatrix(Math.cos(rotX), Math.sin(rotX));
		var r = rx.multiplyMatrix(ry);

//		var r = M4Helper.getYRotationMatrix(Math.cos(rotY), Math.sin(rotY));
		var m = perspective.multiplyMatrix(t).multiplyMatrix(r);


		canvas.fillRect(new Rectangle(0, 0, W, H), CLEAR_COL);

		for(i in 0...tris.length) {
			draw(m, i, 0xff0000);
		}

	}


	private function draw(mat:Matrix, triangleIndex:Int, color:Int) {

		var triIndex = tris[triangleIndex];
		var a:Array<Float> = points[triIndex[0]].slice(0);
		var b:Array<Float> = points[triIndex[1]].slice(0);
		var c:Array<Float> = points[triIndex[2]].slice(0);

		var triUvs:Array<Float> = uvs[triIndex[3]].slice(0);

		a.push(1);
		b.push(1);
		c.push(1);

		a = mat.multiplyVector(a);
		b = mat.multiplyVector(b);
		c = mat.multiplyVector(c);

		var ab = Vec.subVector(b,a);
		var ac = Vec.subVector(c,a);



		var axb = M4Helper.cross(ac, ab);
		var midPoint:Array<Float> = Vec.multiplyScalar(Vec.addVector(c, Vec.addVector(a, b)), 0.333);
		var viewVector:Array<Float> = midPoint; // view vector is from camera to triangle centerpoint
		var d = M4Helper.dot(axb, viewVector);
		var ang = rotY * 180 / Math.PI;
		ang = Math.round(ang * 100.0) / 100.0;
//		trace(ang, Vec.toString(axb), Vec.toString(viewVector), Math.round(d * 100.0) / 100.0);


		if (d > 0) {
			return;
		}



		var screen0 = getXY(a);
		var screen1 = getXY(b);
		var screen2 = getXY(c);

		screen0.push(triUvs[0]);
		screen0.push(triUvs[1]);
		screen1.push(triUvs[2]);
		screen1.push(triUvs[3]);
		screen2.push(triUvs[4]);
		screen2.push(triUvs[5]);

		var lightDir:Array<Float> = [0,0,-1];
		Vec.normalizeV3(axb);
		var lightDot:Float = -M4Helper.dot(axb, lightDir);
//		trace(lightDot);

		var brightness:Float = Math.max(lightDot, 0);
		var r:Int = (color & 0xff0000) >> 16;
		var g:Int = (color & 0x00ff00) >> 8;
		var b:Int = color & 0xff;
		var lightedCol = (Std.int(r * brightness) << 16) | (Std.int(g * brightness) << 8) | Std.int(b*brightness);


		drawTriangle(screen0, screen1, screen2);
		
		//graphics.beginFill(lightedCol, 1);
		//graphics.moveTo(screen0[0], screen0[1]);
		//graphics.lineTo(screen1[0], screen1[1]);
		//graphics.lineTo(screen2[0], screen2[1]);
		//graphics.lineTo(screen0[0], screen0[1]);
		//graphics.endFill();



		// get triangle midpoint

		//Vec.normalizeV3(axb);
		//var normalEndPoint:Array<Float> = Vec.addVector(midPoint, axb);
//
		//var norm0 = getXY(midPoint);
		//var norm1 = getXY(normalEndPoint);

		//graphics.moveTo(norm0[0], norm0[1]);
		//graphics.lineTo(norm1[0], norm1[1]);
	}

	private function getXY(vec:Array<Float>):Array<Float> {
		var x = vec[0];
		var y = vec[1];
		var z = vec[2];
		var w = vec[3];

		if (w == 0.0) {
			w = 0.0000001;
		}

		return [(x/w) + STAGEW, (y/w) + STAGEH];
	}





	private function drawTriangle(v0:Array<Float>, v1:Array<Float>, v2:Array<Float>) {
		// TODO: Checks for special cases, division by zero and other stuff...

		// Sort vertices top-to-bottom
		var verts:Array<Array<Float>> = [v0, v1, v2];
		var index:Array<Int> = [0,0,0];

		var y0 = v0[1];
		var y1 = v1[1];
		var y2 = v2[1];

		// top
		if (y0 <= y1 && y0 <= y2) index[0] = 0;
		else if (y1 <= y0 && y1 <= y2) index[0] = 1;
		else index[0] = 2;

		// mid
		if (index[0] != 0 && (y0 <= y1 || y0 <= y2)) index[1] = 0;
		else if (index[0] != 1 && (y1 <= y0 || y1 <= y2)) index[1] = 1;
		else index[1] = 2;

		// bottom
		if (index[0] != 0 && index[1] != 0) index[2] = 0;
		else if (index[0] != 1 && index[1] != 1) index[2] = 1;
		else index[2] = 2;

		// End of sorting top-to-bottom



		var vv0 = verts[index[0]]; // topmost
		var vv1 = verts[index[1]]; // middle
		var vv2 = verts[index[2]]; // bottom


		var isFlatBottom:Bool = (vv1[1] == vv2[1]);
		var isFlatTop:Bool = (vv0[1] == vv1[1]);
		if (isFlatBottom || isFlatTop) { // Check for flatBottom triangle?

			var dX:Float = (isFlatBottom) ? vv2[0] - vv1[0] : vv1[0] - vv0[0];
			var dVal0:Float = (isFlatBottom) ? vv2[2] - vv1[2] : vv1[2] - vv0[2];
			var dVal1:Float = (isFlatBottom) ? vv2[3] - vv1[3] : vv1[3] - vv0[3];
			dCdX = [ dVal0 / dX, dVal1 / dX ];

			if (isFlatBottom) drawFlatBottomTriangle(vv1, vv0, vv2);
			else drawFlatTopTriangle(vv1, vv0, vv2);

		} else { // General case, split triangle into a top half and a bottom half

			if (vv2[1] - vv0[1] == 0) {
				trace("will result in division by 0");
				return; // will result in division by 0
			}

			var midYPoint = vv1;
			var split:Array<Float> = [
				vv0[0] + (vv2[0]-vv0[0]) * ((vv1[1]-vv0[1]) / (vv2[1] - vv0[1])), // x
				midYPoint[1], // same y
				vv0[2] + (vv2[2]-vv0[2]) * ((vv1[1]-vv0[1]) / (vv2[1] - vv0[1])), // u
				vv0[3] + (vv2[3]-vv0[3]) * ((vv1[1]-vv0[1]) / (vv2[1] - vv0[1])) // v
			];

			var deltaVal0_left = vv1[2];
			var deltaVal0_right = vv0[2] + (vv1[1]-vv0[1]) / (vv2[1]-vv0[1]) * (vv2[2]-vv0[2]);
			var deltaVal0 = deltaVal0_right - deltaVal0_left;

			var deltaVal1_left = vv1[3];
			var deltaVal1_right = vv0[3] + (vv1[1]-vv0[1]) / (vv2[1]-vv0[1]) * (vv2[3]-vv0[3]);
			var deltaVal1 = deltaVal1_right - deltaVal1_left;

			var dX:Float = split[0] - vv1[0];

			dCdX = [
				deltaVal0 / dX,
				deltaVal1 / dX
			];



			drawFlatBottomTriangle(vv1, vv0, split);
			drawFlatTopTriangle(vv1, split, vv2);

		}





	}

	private function drawFlatBottomTriangle(v0:Array<Float>, v1:Array<Float>, v2:Array<Float>) {

		/*
			v1
		   /  \
		 v0 -- v2

		 */

		if (v0[0] > v2[0]) { // swap
			var temp = v0;
			v0 = v2;
			v2 = temp;
		}


		var invSlope1:Float = (v0[0] - v1[0]) / (v0[1] - v1[1]);
		var invSlope2:Float = (v2[0] - v1[0]) / (v2[1] - v1[1]);

		var yTop:Int = Std.int(v1[1]);
		var yBottom:Int = Std.int(v0[1]) /* +1 */; // may glitch if adding +1

		var x0:Float = v1[0];
		var x1:Float = v1[0] + 1;

		var intX0:Int = Std.int(x0);
		var intX1:Int = Std.int(x1);



		var dCdY_left:Array<Float> = [
			(v0[2] - v1[2]) / (v0[1] - v1[1]), // deltaU divided by deltaY
			(v0[3] - v1[3]) / (v0[1] - v1[1])  // deltaV divided by deltaY
		];

		var UVLeft:Array<Float> = [v1[2], v1[3]]; // start values

		for (y in yTop...yBottom) {

			var U:Float = (UVLeft[0]);
			var V:Float = UVLeft[1];

			for(x in intX0...intX1){

//				var c:Int = 0xff0000 | (Std.int(U) << 8) | Std.int(V);
				var c:Int = TEXTURE.getPixel(Std.int(V * TEXTURE_W), Std.int((1.0-U) * TEXTURE_H));

				var col:Int = (x == intX0 || x == intX1-1) ? 0x000000 : c;
				canvas.setPixel(x,y,col);

				U = U + dCdX[0];
				V = V + dCdX[1];

				//trace(cG);
			}

			x0 += invSlope1;
			x1 += invSlope2;

			intX0 = Std.int(x0);
			intX1 = Std.int(x1);

			UVLeft[0] += dCdY_left[0];
			UVLeft[1] += dCdY_left[1];
		}



//		canvas.setPixel(Std.int(v0[0]), Std.int(v0[1]), 0x00ff00);
//		canvas.setPixel(Std.int(v1[0]), Std.int(v1[1]), 0x00ff00);
//		canvas.setPixel(Std.int(v2[0]), Std.int(v2[1]), 0x00ff00);
	}

	private function drawFlatTopTriangle(v0:Array<Float>, v1:Array<Float>, v2:Array<Float>) {
		/*
			v0 -- v1
			  \  /
			   v2
		 */

		if (v0[0] > v1[0]) { // swap
			var temp = v0;
			v0 = v1;
			v1 = temp;
		}


		var invSlope1:Float = (v2[0] - v0[0]) / (v2[1] - v0[1]);
		var invSlope2:Float = (v2[0] - v1[0]) / (v2[1] - v1[1]);
		var x0:Float = v0[0];
		var x1:Float = v1[0] + 1;

		var intX0:Int = Std.int(x0);
		var intX1:Int = Std.int(x1);

		var yTop:Int = Std.int(v0[1]);
		var yBottom:Int = Std.int(v2[1]);


		var dCdY_left:Array<Float> = [
			(v2[2] - v0[2]) / (v2[1] - v0[1]),
			(v2[3] - v0[3]) / (v2[1] - v0[1])
		];

		var UVLeft:Array<Float> = [v0[2], v0[3]];


		for (y in yTop...yBottom) {

			var U:Float = UVLeft[0];
			var V:Float = UVLeft[1];

			for (x in intX0...intX1) {

//				var c:Int = 0xff0000 | (Std.int(U * TEXTURE_H) << 8) | Std.int(V * TEXTURE_W);
				var c:Int = TEXTURE.getPixel(Std.int(V * TEXTURE_W), Std.int((1.0 - U) * TEXTURE_H));

				var col:Int = (x == intX0 || x == intX1-1) ? 0x000000 : c;
				canvas.setPixel(x,y,col);

				U = U + dCdX[0];
				V = V + dCdX[1];
			}
			x0 += invSlope1;
			x1 += invSlope2;
			intX0 = Std.int(x0);
			intX1 = Std.int(x1);

			UVLeft[0] += dCdY_left[0];
			UVLeft[1] += dCdY_left[1];
		}

//		canvas.setPixel(Std.int(v0[0]), Std.int(v0[1]), 0x00ff00);
//		canvas.setPixel(Std.int(v1[0]), Std.int(v1[1]), 0x00ff00);
//		canvas.setPixel(Std.int(v2[0]), Std.int(v2[1]), 0x00ff00);
	}



}
