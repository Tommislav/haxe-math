package se.salomonsson.math.test;
import flash.geom.Point;
import se.salomonsson.math.debug.DebugVec2;
import flash.display.Sprite;
class TestProjection extends Sprite {



	public function new() {
		super();
		var ddraw:DebugVec2 = new DebugVec2(graphics, 1);

		var v1:Vec2 = new Vec2(50,50);
		var v2:Vec2 = new Vec2(30,170);

		ddraw.vec2(v1, 0xff0000, new Point(100,100));
		ddraw.vec2(v2, 0x00ff00, new Point(100,100));

		// project v1 on to v2
		// (vec1 dot normal) * normal
		var v2n = v2.normalize();
		var dot = v1.x * v2n.x + v1.y * v2n.y;

		var v3:Vec2 = v2n.mul(dot);
		ddraw.vec2(v3, 0, new Point(100,100));

		var e:Vec2 = v3.sub(v1);
		ddraw.vec2(e, 0xaaaa00, new Point(100+v1.x,100+v1.y));
	}
}
