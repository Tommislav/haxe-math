package se.salomonsson.math.test;
import flash.geom.Vector3D;
import flash.Vector;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import se.salomonsson.math.debug.DebugVec2;
import flash.display.Sprite;
class AABBIntersection extends Sprite {
	public function new() {
		super();
		//4,6
		//-4,-6

		var draw:DebugVec2 = new DebugVec2(graphics, 40);



		var rect:Rectangle = new Rectangle(2,3,3,4);
		var vec:Vec2 = new Vec2(7, 4.5);

		draw.rect(rect, 0x0000ff);


		doRaycast(draw, rect, vec, new Vec2(0,0));
//		doRaycast(draw, rect, vec, Matrix2x2 Vec2(1, 2.5));
//		doRaycast(draw, rect, Matrix2x2 Vec2(-6, 4), Matrix2x2 Vec2(7, 2));
//		doRaycast(draw, rect, Matrix2x2 Vec2(-7, -1.5), Matrix2x2 Vec2(8, 4));
//		doRaycast(draw, rect, Matrix2x2 Vec2(2,2), Matrix2x2 Vec2(6,4)); //MISS
//		doRaycast(draw, rect, Matrix2x2 Vec2(0, 4), Matrix2x2 Vec2(1, 1));

		var m:Matrix = new Matrix();
		var v:Vector3D = new Vector3D();

	}


	private function doRaycast(draw:DebugVec2, target:Rectangle, vec:Vec2, start:Vec2) {
		draw.vec2(vec, 0xff0000, new Point(start.x, start.y));

		var clipLow = 0.0;
		var clipHigh = 1.0;



		// clip vector along y axis
		if (vec.y != 0) {
			var yLen = vec.y;
			var y1 = (target.top - start.y) / yLen;
			var y2 = (target.bottom - start.y) / yLen;

			// swap?
			var yClipStart = (y1 < y2) ? y1 : y2;
			var yClipEnd = (y1 < y2) ? y2 : y1;

			if (yClipStart > clipHigh) return; // no hit
			if (yClipEnd < clipLow) return; // no hit

			if (yClipStart > clipLow) clipLow = yClipStart;
			if (yClipEnd < clipHigh) clipHigh = yClipEnd;


			draw.vec2(new Vec2(0, vec.y * yClipStart), 0x00FF00, new Point(start.x + 0.2, start.y));
			draw.vec2(new Vec2(0, vec.y * yClipEnd), 0x008000, new Point(start.x + 0.4, start.y));
		}






		// clip vector along x axis
		var xClipStart = clipLow;
		var xClipEnd = clipHigh;
		if (vec.x != 0) {
			var xLen = vec.x;
			var x1 = (target.left - start.x) / xLen;
			var x2 = (target.right - start.x) / xLen;

			// swap?
			xClipStart = (x1 < x2) ? x1 : x2;
			xClipEnd = (x1 < x2) ? x2 : x1;

			if (xClipStart > clipHigh) return; // no hit
			if (xClipEnd < clipLow) return; // no hit

			if (xClipStart > clipLow) clipLow = xClipStart;
			if (xClipEnd < clipHigh) clipHigh = xClipEnd;


			draw.vec2(new Vec2(vec.x * xClipStart), 0x00FF00, new Point(start.x, start.y + 0.2));
			draw.vec2(new Vec2(vec.x * xClipEnd), 0x008000, new Point(start.x, start.y + 0.4));
		}



		draw.vec2(vec.mul(clipHigh), 0x008000, new Point(start.x, start.y));
		draw.vec2(vec.mul(clipLow), 0x00FF00, new Point(start.x, start.y));

	}

}
