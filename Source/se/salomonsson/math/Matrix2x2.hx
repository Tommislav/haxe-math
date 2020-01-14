package se.salomonsson.math;
class Matrix2x2 {

	public static var identity:Matrix2x2 = new Matrix2x2(1, 0, 0, 1);

	public var a:Float;
	public var b:Float;
	public var c:Float;
	public var d:Float;

	/*
	---------
	| a | b |
	---------
	| c | d |
	---------
	 */

	public function new(a=0.0, b=0.0, c=0.0, d=0.0) {
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
	}


	public function add(m:Matrix2x2):Matrix2x2 {
		// addition only works on matrices with equal dimensions
		return new Matrix2x2(a + m.a, b + m.b, c + m.c, d + m.d);
	}

	public function mul(scalar:Float):Matrix2x2 {
		return new Matrix2x2(a*scalar, b*scalar, c*scalar, d*scalar);
	}

	public function mulVec(v:Vec2):Vec2 {
		// ax + by, cx + dy
		return new Vec2(a * v.x + b * v.y, c * v.x + d * v.y);
	}



	public function mulMat(m:Matrix2x2) {
		// a * ma + b * mc,		a * mb + b * md
		// c * ma + d * mc,		c * mb + d * md

		return new Matrix2x2(	a * m.a + b * m.c, 		a * m.b + b * m.d,
								c * m.a + d * m.c,		c * m.b + d * m.d	);
	}

	// mathematical notation is |A| (bolded A)
	public function getDeterminant():Float { return a * d - b * c;	}

	// multiply a matrix with its inverse will result in an identity matrix
	public function getInverse():Matrix2x2 {
		// (1/determinant) * new Matrix(d, -b, -c, a)
		// switch a and d
		// negate b and c

		return new Matrix2x2(d, -b, -c, a).mul(1 / getDeterminant());
	}

	public function toString() {
		return "Matrix2x2\n---------\n| "+a+" | "+b+" |\n---------\n| "+c+" | "+d+" |\n---------";
	}
}
