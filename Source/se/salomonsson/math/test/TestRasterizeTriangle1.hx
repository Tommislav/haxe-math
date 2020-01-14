package se.salomonsson.math.test;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;


@:bitmap("assets/gfx/uv.png")
class Texture extends flash.display.BitmapData {}


class TestRasterizeTriangle1 extends Sprite {


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

	// TODO: Plug it into 3d model
	// TODO: z-buffer
	// TODO: Backface culling


	private var left_dCdY:Array<Float>; // step values for color each y along the left edge
	private var right_dCdY:Array<Float>; // step values for color each y along the right edge
	private var dCdX:Array<Float>; // upper segment


	public function new() {
		super();
		canvas = new BitmapData(W,H, false, 0xffeeee);
		var bitmap:Bitmap = new Bitmap(canvas);
		bitmap.x = 50;
		bitmap.y = 20;
		addChild(bitmap);

		TEXTURE = new Texture(0,0);
		var texBmp:Bitmap = new Bitmap(TEXTURE);
		texBmp.width = texBmp.height = 92;
		texBmp.x = 54;
		texBmp.y = 24;
		addChild(texBmp);

		
		drawTriangle([60,170,0,0],[90,100,1,0],[180,230,0,1]);
		
		drawTriangle([180,10,1,0], [180,110,0,0], [280,10,1,1]);
		drawTriangle([290,10,1,1], [190,110,0,0], [290,110,0,1]);
		drawTriangle([190,120,1,0], [190,220,0,0], [290,220,0,1]);
		drawTriangle([297,120,1,1], [197,120,1,0], [297,220,0,1]);
		
		drawTriangle([100,200,0.2,0], [10,240,0,0], [50,240,0,0.2]);
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
				vv0[0] + (vv2[0]-vv0[0]) * ((vv1[1]-vv0[1]) / (vv2[1] - vv0[1])),
				midYPoint[1] // same y
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
		var yBottom:Int = Std.int(v0[1]) + 1;

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
