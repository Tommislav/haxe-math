package se.salomonsson.math.test;
import flash.text.TextField;
import flash.geom.Point;
import se.salomonsson.math.debug.DebugVec2;
import haxe.Timer;
import flash.display.Sprite;
class TestDotProduct extends Sprite {

	private var t:Timer;

	private var v1:Vec2;
	private var v2:Vec2;
	private var rot:Float;
	private var pos:Point;

	private var draw:DebugVec2;

	private var tf:TextField;

	public function new() {
		super();

		v1 = new Vec2(1,0);
		v2 = new Vec2(0,1);

		var scale = 50.0;
		var p = 100 / scale;
		pos = new Point(p,p);
		draw = new DebugVec2(graphics, scale);

		tf = new TextField();
		tf.x = 100 + 70;
		tf.y = 100 - 10;
		addChild(tf);

		t = new Timer(64);
		t.run = update;

		var vv1:Vec2 = new Vec2(1,1);
		var vv2:Vec2 = new Vec2(10,10);
	}

	public function update():Void {
		v2 = v2.rotate(1);

		graphics.clear();
		draw.vec2(v1, 0x00ff00, pos);
		draw.vec2(v2, 0xff0000, pos);

		// the dot product is defined as:
		// v1.length * v2.lenght * cos(theta)
		// but is the same as:
		// v1.x * v2.x + v1.y * v2.y
		// if v1 and v2 are both of unit lenght, then the dot
		// product will give us the cosine of the angle
		//
		// meaning that if angle is perpendicular, the dot is 0
		// if the angle is parallell then it's 1 or -1 depending
		// on if it is facing the same way or not
		//
		// if not unit lenght, then 0 will still be the same
		// but 1 and -1 will be the multiplied lenght instead
		// so length 3 and 2 will be 6 and -6
		//
		// remember that Math.cos(0) is 1, so if the theta is
		// 0 (looking the same direction) then dot product will
		// be 1!

		var dot:Float = Math.round((v1.x * v2.x + v1.y * v2.y) * 100.0) / 100.0;
		tf.text = dot + "";

	}
}
