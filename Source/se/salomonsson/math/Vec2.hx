package se.salomonsson.math;
class Vec2 {

	private var _x:Float;
	private var _y:Float;
	private var _lenDirty:Bool;
	private var _len:Float;

	public function new(x:Float = 0, y:Float = 0) {
		_x = x;
		_y = y;
		_lenDirty = true;
	}

	public var x(get, null):Float;
	private function get_x() { return _x; }

	public var y(get, null):Float;
	private function get_y() { return _y; }

	public var length(get, null):Float;
	private function get_length() {
		if (!_lenDirty) {
			return _len;
		}
		_len = Math.sqrt(_x *_x + _y * _y);
		_lenDirty = false;
		return _len;
	}

	public var inverse(get, null):Vec2;
	private function get_inverse():Vec2 {
		return new Vec2(-_x, -_y);
	}

	public function normalize():Vec2 {
		return new Vec2(_x / length, _y / length);
	}

	public function add(v:Vec2):Vec2 {
		return new Vec2(_x + v.x, _y + v.y);
	}

	public function sub(v:Vec2) {
		return new Vec2(_x - v.x, _y - v.y);
	}

	public function mul(scalar:Float) {
		return new Vec2(_x * scalar, _y * scalar);
	}

	public function dev(scalar:Float) {
		return new Vec2(_x/scalar, _y/scalar);
	}

	public function toString():String {
		return "Vec2[x:"+_x+", y:"+_y+"]";
	}
}
