package se.salomonsson.math;
class Matrix3x3 {
	public static var identity:Matrix3x3 = new Matrix3x3(
		1, 0, 0,
		0, 1, 0,
		0, 0, 1);

	public var a:Float;
	public var b:Float;
	public var c:Float;
	public var d:Float;
	public var e:Float;
	public var f:Float;
	public var g:Float;
	public var h:Float;
	public var i:Float;

	/*
	-------------
	| a | b | c |
	-------------
	| d | e | f |
	-------------
	| g | h | i |
	-------------
	 */

	public function new(a=0.0, b=0.0, c=0.0, d=0.0, e=0.0, f=0.0, g=0.0, h=0.0, i=0.0) {
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.e = e;
		this.f = f;
		this.g = g;
		this.h = h;
		this.i = i;
	}


	public function mul(scalar:Float):Matrix3x3 {
		return new Matrix3x3(a*scalar, b*scalar, c*scalar, d*scalar, e*scalar, f*scalar, g*scalar, h*scalar, i*scalar);
	}

	public function mulVec(p:Array<Float>):Array<Float> {
		// ax + by + cz, 	dx + ey + fz,		gx + hy + iz
		var x:Float = p[0];
		var y:Float = p[1];
		var z:Float = p[2];
		return [
			a*x + b*y + c*z,
			d*x + e*y + f*z,
			g*x + h*y + i*z
		];
	}



	public function mulMat(m:Matrix3x3):Matrix3x3 {

		// a*m.a + b*m.d + c*m.g,		a*m.b + b*m.e + c*m.h,		a*m.c + b*m.f + c*m.i
		// d*m.a + e*m.d + f*m.g,		d*m.b + e*m.e + f*m.h,		d*m.c + e*m.f + f*m.i
		// g*m.a + h*m.d + i*m.g,		g*m.b + h*m.e + i*m.h,		g*m.c + h*m.f + i*m.i


		return new Matrix3x3(
			a*m.a + b*m.d + c*m.g,		a*m.b + b*m.e + c*m.h,		a*m.c + b*m.f + c*m.i,
			d*m.a + e*m.d + f*m.g,		d*m.b + e*m.e + f*m.h,		d*m.c + e*m.f + f*m.i,
			g*m.a + h*m.d + i*m.g,		g*m.b + h*m.e + i*m.h,		g*m.c + h*m.f + i*m.i
		);
	}

	public function toString() {
		return a + ", " + b + ", " + c + ", \n" + d + ", " + e + ", " + f + ", \n" + g + ", " + h + ", " + i;
	}
}
