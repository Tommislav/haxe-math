package se.salomonsson.math;
class Vec {

	public static function addVector(v:Array<Float>, add:Array<Float>):Array<Float> {
		var r:Array<Float> = new Array<Float>();
		for (i in 0...v.length) {
			r[i] = v[i] + add[i];
		}
		return r;
	}

	public static  inline function subVector(v1:Array<Float>, v2:Array<Float>):Array<Float> {
		var r:Array<Float> = new Array<Float>();
		for (i in 0...v1.length){
			r[i] = v1[i] - v2[i];
		}
		return r;
}

	public static inline function multiplyScalar(v:Array<Float>, amnt:Float):Array<Float> {
		for (i in 0...v.length) {
			v[i] *= amnt;
		}
		return v;
	}
	public static inline function getLength(v:Array<Float>) {
		if (v.length < 2) throw "Error";
		else if (v.length == 2) return Math.sqrt(v[0] * v[0] + v[1] * v[1]);
		else return Math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
	}
	public static inline function normalizeV3(v:Array<Float>):Void {
		var len = Vec.getLength(v);
		for (i in 0...3){
			v[i] /= len;
		}
	}
	public static inline function normalizeV2(v:Array<Float>):Void {
		var len = Vec.getLength(v);
		v[0] /= len;
		v[1] /= len;
	}
	public static function toString(v:Array<Float>):String {
		var s:String = "Vec" + v.length + "[";
		for (i in 0...v.length) {
			s += (Math.round(v[i] * 100.0) / 100.0) + "";
			if (i < v.length-1) s += ",";
		}
		return s + "]";
	}


	public function new() {
	}
}
