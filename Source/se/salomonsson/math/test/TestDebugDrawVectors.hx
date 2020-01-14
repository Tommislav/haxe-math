package se.salomonsson.math.test;
import flash.geom.Point;
import se.salomonsson.math.debug.DebugVec2;
import flash.display.Sprite;
class TestDebugDrawVectors extends Sprite {
	public function new() {
		super();

		var draw:DebugVec2 = new DebugVec2(graphics, 20);


		draw.vec2(new Vec2(6,7), 0xff0000, new Point(1,0.8));
		draw.vec2(new Vec2(6,7).sub(new Vec2(1,1)), 0xff0000, new Point(1,1));

		draw.vec2(new Vec2(4,0), 0xccaa00, new Point(5, 3.4));
		draw.vec2(new Vec2(4,0).normalize(), 0xccaa00, new Point(5, 3.65));
		draw.vec2(new Vec2(10,0).normalize().mul(2), 0x00ff00, new Point(5, 4));

		trace(new Vec2(1,1).length);
		trace(new Vec2(1,0).length);
		trace(new Vec2(5,6).normalize().length);



	}
}
