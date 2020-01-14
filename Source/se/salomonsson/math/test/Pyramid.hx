package se.salomonsson.math.test;
class Pyramid {
	public static var points:Array<Float> = [
		0,-2,0,		// top
		-1,1,1,		// BLN
		1,1,1,		// BRN
		-1,1,-1,	// BLF
		1,1,-1		// BRF
	];

	public static var lines:Array<Int> = [
		0,1,
		0,2,
		0,3,
		0,4,
		1,2,
		3,4,
		1,3,
		2,4
	];
}
