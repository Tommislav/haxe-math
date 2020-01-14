package se.salomonsson.math.debug;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Graphics;

class DebugVec2 {



	private var _canvas:Graphics;
	private var _scale:Float;

	public var scaleStartingPos = false;

	public function new (canvas:Graphics, scale:Float = 1) {
		_canvas = canvas;
		_scale = scale;
	}

	public function vec2(v:Vec2, color:Int, pos:Point = null) {
		if (pos == null) pos = new Point();

		var start = new Vec2(pos.x, pos.y);
		var end = start.add(v);

		if (_scale != 1) {
			start = start.mul(_scale);
			end = end.mul(_scale);
		}


		var tipLen = 8;
		var arrowTip1 = end.add( v.rotate(150).normalize().mul(tipLen) );
		var arrowTip2 = end.add( v.rotate(-150).normalize().mul(tipLen) );

		_canvas.lineStyle(1.0, color);
		_canvas.moveTo(start.x, start.y);
		_canvas.lineTo(end.x, end.y);

		_canvas.lineTo(arrowTip1.x, arrowTip1.y);
		_canvas.moveTo(end.x, end.y);
		_canvas.lineTo(arrowTip2.x, arrowTip2.y);

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
