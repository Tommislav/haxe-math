package se.salomonsson.math;
class Matrix {

	private var m:Array<Array<Float>>;
	//private var w:Int;
//	private var h:Int;

	public var w(default,null):Int;
	public var h(default,null):Int;

	public function new(w:Int, h:Int) {
		this.w = w;
		this.h = h;

		m = new Array();
		for (i in 0...h) {
			m[i] = new Array();

			for (j in 0...w) {
				m[i][j] = (i == j) ? 1 : 0;
			}
		}
	}




	public function set(vals:Array<Float>) {
		if (vals.length > (w*h)) {
			throw "Incorrect size";
		}

		var d = 0;
		for (i in 0...h) {
			for (j in 0...w) {
				m[i][j] = vals[d++];
			}
		}
	}

	public function setAt(x:Int, y:Int, val:Float) {
		m[y][x] = val;
	}

	public function getAt(x:Int, y:Int) {
		return m[y][x];
	}


	public function multiplyScalar(s:Float){
		for (i in 0...h) {
			for (j in 0...w) {
				m[i][j] = m[i][j] * s;
			}
		}
	}

	public function multiplyVector(vec:Array<Float>) {
		if (vec.length != w) { throw "Cannot multiply vector with matrix, size do not match!"; }

		var result:Array<Float> = new Array();
		for(y in 0...h) {
			var r = 0.0;
			for (x in 0...w) {
				r += vec[x] * m[y][x];
			}
			result[y] = r;
		}
		return result;
	}

	public function multiplyMatrix(mat:Matrix):Matrix {
		if (mat.h != w) { throw "Cannot multiply matrix, size do not match!"; }

		var a = new Array<Float>();
		for(y in 0...h) {
			for (x in 0...w) {

				var m = 0.0;

				// we grab the HORIZONTAL column vector from THIS matrix at our current y
				// and get the dot product from the VERTICAL vector from THE OTHER matrix at our current x

				// so we need an extra for-loop here!
				for (i in 0...w) {
					m += getAt(i, y) * mat.getAt(x, i);
				}

				a.push(m);
			}
		}

//		trace("array = " + a);
		var m2 = new Matrix(w,h);
		m2.set(a);

		return m2;
	}


	public function clone():Matrix {
		var m = new Matrix(w,h);
		for (y in 0...h) {
			for (x in 0...w) {
				m.setAt(x,y,getAt(x,y));
			}
		}
		return m;
	}



	public function toString():String {
		var s:String = "Matrix_" + w + "x" + h + ":\n";

		for (i in 0...h) {
			s += "| ";
			for (j in 0...w) {
				s += m[i][j] + " | ";
			}
			s += "\n";
		}

		return s;
	}
}
