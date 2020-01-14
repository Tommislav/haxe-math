package se.salomonsson.math.test;
import flash.ui.Keyboard;
import se.salomonsson.math.M4Helper;

import flash.Lib;
import haxe.Timer;
import flash.display.Sprite;
class TestFilledPolygon extends Sprite {


	private var kb:KeyboardHelper;
	private var t:Timer;
	private var points:Array<Array<Float>>;
	private var tris:Array<Array<Int>>;
	private var rotY:Float = 0;
	private var rotX:Float = 0;

	private var STAGEW:Float;
	private var STAGEH:Float;



	public function new() {
		super();
		STAGEW = Lib.current.stage.stageWidth / 2.0;
		STAGEH = Lib.current.stage.stageHeight / 2.0;

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

		tris = [
			[0, 1, 2], [3,2,1], //front
			[4,6,5], [7,5,6], // back
			[4,0,6], [2,6,0], // left side
			[1,5,3], [7,3,5], // right side
			[2,3,6], [7,6,3], // top
			[0,4,1], [5,1,4] // bottom
		];

		trace(M4Helper.cross(
		[1,0,0], [0,1, 0])
		);
		
		
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

		var perspective = new Matrix(4,4);
		perspective.set([
			1,0,0,0,
			0,1,0,0,
			0,0,1,0,
			0,0,-(1/200),0
		]);

		var t = M4Helper.getTranslateMatrix(2,0,-8);
		var ry = M4Helper.getYRotationMatrix(Math.cos(rotY), Math.sin(rotY));
		var rx = M4Helper.getXRotationMatrix(Math.cos(rotX), Math.sin(rotX));
		var r = rx.multiplyMatrix(ry);

//		var r = M4Helper.getYRotationMatrix(Math.cos(rotY), Math.sin(rotY));
		var m = perspective.multiplyMatrix(t).multiplyMatrix(r);


		graphics.clear();
		graphics.lineStyle(0, 0);

		for(i in 0...tris.length) {
			draw(m, i, 0xff0000);
		}

	}


	private function draw(mat:Matrix, triangleIndex:Int, color:Int) {
		
		var triIndex = tris[triangleIndex];
		var a:Array<Float> = points[triIndex[0]].slice(0);
		var b:Array<Float> = points[triIndex[1]].slice(0);
		var c:Array<Float> = points[triIndex[2]].slice(0);

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


		var lightDir:Array<Float> = [0,0,-1];
		Vec.normalizeV3(axb);
		var lightDot:Float = -M4Helper.dot(axb, lightDir);
//		trace(lightDot);

		var brightness:Float = Math.max(lightDot, 0);
		var r:Int = (color & 0xff0000) >> 16;
		var g:Int = (color & 0x00ff00) >> 8;
		var b:Int = color & 0xff;
		var lightedCol = (Std.int(r * brightness) << 16) | (Std.int(g * brightness) << 8) | Std.int(b*brightness);


		graphics.beginFill(lightedCol, 1);
		graphics.moveTo(screen0[0], screen0[1]);
		graphics.lineTo(screen1[0], screen1[1]);
		graphics.lineTo(screen2[0], screen2[1]);
		graphics.lineTo(screen0[0], screen0[1]);
		graphics.endFill();
		


		// get triangle midpoint

		Vec.normalizeV3(axb);
		var normalEndPoint:Array<Float> = Vec.addVector(midPoint, axb);
		
		var norm0 = getXY(midPoint);
		var norm1 = getXY(normalEndPoint);

		graphics.moveTo(norm0[0], norm0[1]);
		graphics.lineTo(norm1[0], norm1[1]);
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
}
