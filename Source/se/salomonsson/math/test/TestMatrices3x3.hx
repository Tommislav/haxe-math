package se.salomonsson.math.test;
import flash.display.Sprite;
import flash.geom.Point;
import haxe.Timer;
class TestMatrices3x3 extends Sprite {

	private var t:Timer;


	private var lines:Array<Array<Float>>;
	private var rot:Float;


	// perspective
	// x' = x * FL / z

	private var FOCAL_LENGTH = 200.0;

	public function new() {

		//trace(new Matrix2x2(1,2,3,4).mulMat(new Matrix2x2(5,6,7,8)).toString());

		// test matrix inversion
//		var mat = new Matrix2x2(1, 2, 3, 4);
//		var inv = mat.getInverse();
//		trace(mat.mulMat(inv).toString());

		super();

		rot = 0;
		lines = [
			[10,-10,1],
			[10,10,1],
			[-10,10,1],
			[-10,-10,1]
		];

		t = new Timer(16);
		t.run = update;
	}

	private function update():Void {

		graphics.clear();
		drawLines(new Point(40,40), rot);
		rot += 0.06;

	}

	private function drawLines(origin:Point, rotation:Float) {

		// given two base vectors, up and right
		// if we rotate those base vectors and put
		// them into a matrix
		// --------------
		// up.x | right.x
		// up.y | right.y
		// --------------
		// then multiply our (local space) vectors with
		// this matrix we will get a vector transformed
		// along these base vectors!

		// FUR (forward, up, right)

		// ROTATION MATRIX (https://www.youtube.com/watch?v=6HaDoXWPICQ&list=PLW3Zl3wyJwWOpdhYedlD-yCB7WQoHf-My&index=21)
		// rotation matrix in 2d is
		// |cos(ang),	-sin(ang), 	0 |
		// |sin(ang),	cos(ang),	0 |
		// |0,			0,			1 |


		var cosAng = Math.cos(rotation);
		var sinAng = Math.sin(rotation);


		var s:Float = (sinAng + 1.2) * 4;
		var scaleMatrix = new Matrix3x3(
			s, 0, 0,
			0,	s, 0,
			0,	0, 1);

		var rotationMatrix = new Matrix3x3(
		cosAng, 	-sinAng, 0,
		sinAng, 	cosAng, 0,
		0,			0,		1
		);


		var translateMatrix = new Matrix3x3(
			1,0, 100 + sinAng * 100,
			0,1, 100,
			0,0, 1
		);

		// TRS matrix: multiply Translation, Rotation, Scale - in that order!
		var mat = translateMatrix.mulMat(rotationMatrix).mulMat(scaleMatrix);

		var first = mat.mulVec(lines[0]);
		var prev = first;
		var scale = 40;

		var sx = (prev[0]);
		var sy = (prev[1]);

		graphics.lineStyle(1, 0);
		graphics.moveTo(first[0], first[1]);

		for (i in 1...lines.length) {
			var curr = mat.mulVec(lines[i]);
			graphics.lineTo(curr[0], curr[1]);
			prev = curr;
		}

		graphics.lineTo(first[0], first[1]);
		graphics.endFill();

	}
}
