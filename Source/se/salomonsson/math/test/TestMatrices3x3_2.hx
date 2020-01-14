package se.salomonsson.math.test;
import flash.display.Sprite;
import haxe.Timer;
class TestMatrices3x3_2 extends Sprite {

	private var t:Timer;


	private var lines:Array<Float>;
	private var rot:Float = 0;

	public function new() {
		super();

		// a simple box 40 by 40 pixels
		lines = [
			20,		-20,
			20,		20,
			-20,	20,
			-20,	-20
		];

		t = new Timer(16);
		t.run = update;

	}

	private function update() {
		rot += 0.03;
		var cosAng = Math.cos(rot);
		var sinAng = Math.sin(rot);

		var cosAng2 = Math.cos(rot/2.0);
		var sinAng2 = Math.sin(rot/2.0);

		var cosAng3 = Math.cos(-rot * 2);
		var sinAng3 = Math.sin(-rot * 2);

		// Matrix for first box

		var t1 = new Matrix3x3(
			1,0,120,
			0,1,100,
			0,0,1
		);
		var r1 = new Matrix3x3(
			cosAng, 	-sinAng, 0,
			sinAng, 	cosAng, 0,
			0,			0,		1
		);
		var M1 = t1.mulMat(r1);

		// Matrix for second box (parented to M1)
		var t2 = new Matrix3x3(
			1,0,28,
			0,1,0,
			0,0,1
		);
		var r2 = new Matrix3x3(
			cosAng2, 	-sinAng2, 0,
			sinAng2, 	cosAng2, 0,
			0,			0,		1
		);
		var scale2 = new Matrix3x3(
			0.5, 0, 0,
			0, 0.5, 0,
			0, 0, 1
		);
		var M2 = M1.mulMat(t2.mulMat(r2).mulMat(scale2));

		//Matrix for third box (parented to M2)
		var t3 = new Matrix3x3(
			1,0,60,
			0,1,0,
			0,0,1
		);
		var r3 = new Matrix3x3(
			cosAng3, 	-sinAng3, 0,
			sinAng3, 	cosAng3, 0,
			0,			0,		1
		);
		var M3 = M2.mulMat(t3.mulMat(r3));

		graphics.clear();
		graphics.lineStyle(1, 0);
		drawBox(M1);
		drawBox(M2);
		drawBox(M3);
	}


	private function drawBox(m:Matrix3x3) {
		var it = lines.iterator();

		var start = m.mulVec([it.next(), it.next(), 1]);

		graphics.moveTo(start[0], start[1]);
		while(it.hasNext()) {
			var p = m.mulVec([it.next(), it.next(), 1]);
			graphics.lineTo(p[0], p[1]);
		}
		graphics.lineTo(start[0], start[1]);

		graphics.endFill();
	}
}
