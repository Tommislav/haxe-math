package ;
import flash.geom.Rectangle;
import flash.Lib;
import flash.geom.Point;
import se.salomonsson.math.debug.DebugVec2;
import flash.display.Sprite;
import se.salomonsson.math.Vec2;
class Main extends Sprite {

	static function main() {

//		trace(new Vec2(6,7).sub(new Vec2(1,1)));
//
//		trace(new Vec2(10,0).normalize());
//		trace(new Vec2(0,10).normalize().mul(2));
//
//		trace(new Vec2(1,1).length);
//		trace(new Vec2(1,0).length);
//		trace(new Vec2(5,6).normalize().length);

		var m:Main = new Main();
		Lib.current.stage.addChild(m);	
	}

	function new() {
		super();
		
		//trace(stage.window.renderer.type);

		//4,6
		//-4,-6

		var draw:DebugVec2 = new DebugVec2(graphics, 40);

//		draw.vec2(new Vec2(1,2).add(new Vec2(3,4)),
//			0xff0000, new Point(5,8));
//
//		draw.vec2(new Vec2(1,2).add(new Vec2(3,4)).inverse,
//			0x00ff00, new Point(5,8));
//
//		draw.point(new Point(5, 8), 0x0000ff);

		var rect:Rectangle = new Rectangle(2,3,3,4);
		var vec:Vec2 = new Vec2(14,9);

		draw.rect(rect, 0xcc00cc);
		draw.vec2(vec, 0xff0000);

		var velLen = vec.length;


		// clip vector along y axis
		var yLen = vec.y - 0;
		var y1 = rect.top / yLen;
		var y2 = rect.bottom / yLen;

		var yClipStart = (y1 < y2) ? y1 : y2;
		var yClipEnd = (y1 < y2) ? y2 : y1;

		draw.vec2(new Vec2(vec.y * yClipStart, 0), 0x00ff00, new Point(0,0.5));
		draw.vec2(new Vec2(vec.y * yClipEnd, 0), 0x00ff00, new Point(0,1));


		// clip vector along x axis, keep within the clipped y-bounds
		var xLen = vec.x;
		var x1 = rect.left / xLen;
		var x2 = rect.right / xLen;
		var xClipStart = (x1 < x2) ? x1 : x2;
		var xClipEnd = (x1 < x2) ? x2 : x1;

		draw.vec2(new Vec2(vec.x * xClipStart, 0), 0xff0000, new Point(0,1.5));
		draw.vec2(new Vec2(vec.x * xClipEnd, 0), 0xff0000, new Point(0,2));


		trace(xClipStart, yClipStart);

		// get the clipped vector that is inside the rectangle
		var clipStart = new Vec2(vec.x * xClipStart, vec.y * yClipStart);
		var clipEnd = new Vec2(vec.x * xClipEnd, vec.y * yClipEnd);
		//draw.vec2(clipEnd.sub(clipStart), 0x00ff00, new Point(clipStart.x, clipStart.y));

		draw.vec2(vec.mul(yClipStart), 0x00ff00);
		draw.vec2(vec.mul(xClipEnd), 0x0000ff, new Point(0.1, 0));
	}
}
