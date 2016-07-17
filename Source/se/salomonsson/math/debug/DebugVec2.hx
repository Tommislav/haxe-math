package se.salomonsson.math.debug;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;

class DebugVec2 {



	private var _canvas:Graphics;
	private var _scale:Float;

	public function new (canvas:Graphics, scale:Float = 1) {
		_canvas = canvas;
		_scale = scale;
	}

	public function vec2(v:Vec2, color:Int, pos:Point = null) {
		if (pos == null) pos = new Point();
		var startX:Float = pos.x * _scale;
		var startY:Float = pos.y * _scale;
		var endX:Float = startX + v.x * _scale;
		var endY:Float = startY + v.y * _scale;


		_canvas.lineStyle(1.0, color);
		_canvas.moveTo(startX, startY);
		_canvas.lineTo(endX, endY);
		_canvas.drawCircle(endX, endY, 2.0);
	}

	public function point(p:Point, color:Int, pos:Point = null) {
		if (pos == null) pos = new Point(0,0);
		_canvas.lineStyle(1.0, color);
		_canvas.drawCircle((p.x + pos.x) * _scale, (p.y + pos.y) * _scale, 5.0);
	}

	public function rect(r:Rectangle, color:Int, pos:Point = null) {
		if (pos == null) pos = new Point(0,0);
		_canvas.lineStyle(1, color);
		_canvas.drawRect((r.x + pos.x) * _scale, (r.y + pos.y) * _scale,
			(r.width + pos.x) * _scale, (r.height + pos.y) * _scale);
	}

}
