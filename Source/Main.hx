package ;
import se.salomonsson.math.test.TestRasterizeTriangle3;
import se.salomonsson.math.test.TestRasterizeTriangle2;
import se.salomonsson.math.test.TestRasterizeTriangle1;
import se.salomonsson.math.test.TestFilledPolygon;
import se.salomonsson.math.test.TestProjection;
import se.salomonsson.math.test.TestDotProduct;
import se.salomonsson.math.test.TestCamera;
import se.salomonsson.math.test.TestPerspective1;
import se.salomonsson.math.test.TestMatrices3x3_2;
import se.salomonsson.math.test.TestMatrices3x3;
import se.salomonsson.math.test.TestMatrices2x2;
import se.salomonsson.math.Matrix2x2;
import se.salomonsson.math.test.TestDebugDrawVectors;
import se.salomonsson.math.test.AABBIntersection;
import flash.Lib;
import flash.display.Sprite;
class Main extends Sprite {

	static function main() {


//		Lib.current.stage.addChild( new AABBIntersection() );
//		Lib.current.stage.addChild( new TestDebugDrawVectors() );
//		Lib.current.stage.addChild( new TestMatrices2x2() );
//		Lib.current.stage.addChild( new TestMatrices3x3() );
//		Lib.current.stage.addChild( new TestMatrices3x3_2() );
//		Lib.current.stage.addChild( new TestPerspective1() );
//		Lib.current.stage.addChild( new TestCamera() );
//		Lib.current.stage.addChild( new TestDotProduct() );
//		Lib.current.stage.addChild( new TestProjection() );
//		Lib.current.stage.addChild( new TestFilledPolygon() );
//		Lib.current.stage.addChild( new TestRasterizeTriangle1() );
//		Lib.current.stage.addChild( new TestRasterizeTriangle2() );
		Lib.current.stage.addChild( new TestRasterizeTriangle3() );
	}

	function new() {
		super();


	}
}
