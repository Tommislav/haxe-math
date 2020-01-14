package se.salomonsson.math;
class M4Helper {

	public static inline function getTranslateMatrix(x:Float, y:Float, z:Float) {
		var m:Matrix = new Matrix(4,4);
		m.set([
			1,0,0, x,
			0,1,0, y,
			0,0,1, z,
			0,0,0,1
		]);
		return m;
	}
	public static inline function getScaleMatrix(sx:Float, sy:Float, sz:Float) {
		var m:Matrix = new Matrix(4,4);
		m.set([
			sx, 0, 0, 0,
			0, sy, 0, 0,
			0, 0, sz, 0,
			0, 0, 0, 1
		]);
		return m;
	}
	public static inline function getYRotationMatrix(cosAng:Float, sinAng:Float) {
		var m:Matrix = new Matrix(4,4);
		m.set([
			cosAng, 0, sinAng, 0,
			0, 1, 0, 0,
			-sinAng, 0, cosAng, 0,
			0, 0, 0, 1
		]);
		return m;
	}
	public static inline function getXRotationMatrix(cosAng:Float, sinAng:Float) {
		var m:Matrix = new Matrix(4,4);
		m.set([
			1, 0, 0, 0,
			0, cosAng, -sinAng, 0,
			0, sinAng, cosAng, 0,
			0, 0, 0, 1
		]);
		return m;
	}
	public static inline function getZRotationMatrix(cosAng:Float, sinAng:Float) {
		var m:Matrix = new Matrix(4,4);
		m.set([
			cosAng, -sinAng, 0, 0,
			sinAng, cosAng, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 1
		]);
		return m;
	}
	public static inline function cross(a:Array<Float>, b:Array<Float>):Array<Float> {
		// cross product
		// Cx = AyBz - AzBy
		// Cy = AzBx - AxBz
		// Cz = AxBy - AyBx
		return [
			a[1] * b[2] - a[2] * b[1],
			a[2] * b[0] - a[0] * b[2],
			a[0] * b[1] - a[1] * b[0],
			0
		];
	}
	public static inline function dot(a:Array<Float>, b:Array<Float>):Float {
		return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
	}



	public function new() {
	}
}
