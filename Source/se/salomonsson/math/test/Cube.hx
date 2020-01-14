package se.salomonsson.math.test;
class Cube {

	public static var points:Array<Float> = [
		1,		-1,	1,	// RTN
		1,		1,	1,	// RBN
		-1,		1,	1,	// LBN
		-1,		-1,	1,	// LTN

		1,		-1,	-1, // RTF
		1,		1,	-1,	// RBF
		-1,		1,	-1, // LBF
		-1,		-1,	-1 	// LTF
	];

	public static var lines:Array<Int> = [
		//	near square
		0,1,
		1,2,
		2,3,
		3,0,
			// far square
		4,5,
		5,6,
		6,7,
		7,4,
			// connect near and far
		0,4,
		1,5,
		2,6,
		3,7
	];

}
