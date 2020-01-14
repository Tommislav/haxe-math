package se.salomonsson.math.test;
import haxe.Timer;
import flash.geom.Point;
import se.salomonsson.math.debug.DebugVec2;
import flash.display.Sprite;

class TestMatrices2x2 extends Sprite {

	private var t:Timer;


	private var lines:Array<Vec2>;
	private var rot:Float;


	public function new() {

		//trace(new Matrix2x2(1,2,3,4).mulMat(new Matrix2x2(5,6,7,8)).toString());

		// test matrix inversion
//		var mat = new Matrix2x2(1, 2, 3, 4);
//		var inv = mat.getInverse();
//		trace(mat.mulMat(inv).toString());

		super();

		rot = 0;
		lines = [
			new Vec2(1,-1),
			new Vec2(1,1),
			new Vec2(-1,1),
			new Vec2(-1,-1)
		];


		t = new Timer(16);
		t.run = update;
	}

	private function update():Void {

		graphics.clear();
		drawLines(new Point(2,2), 0);

		rot += 0.6;
		drawLines(new Point(5,2), rot);
	}

	private function drawLines(origin:Point, rotation:Float) {

		var draw:DebugVec2 = new DebugVec2(graphics, 20);

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

		var up = new Vec2(0, -1).rotate(rotation);
		var right = new Vec2(1, 0).rotate(rotation);

		var mat = new Matrix2x2(up.x, right.x, up.y, right.y);
		draw.vec2(mat.mulVec(lines[0]), 0xff0000, origin);
		draw.vec2(mat.mulVec(lines[1]), 0x00ff00, origin);
		draw.vec2(mat.mulVec(lines[2]), 0x0000ff, origin);
		draw.vec2(mat.mulVec(lines[3]), 0x000000, origin);
	}
}
