package se.salomonsson.math.test;
import flash.geom.Point;
import se.salomonsson.math.debug.DebugVec2;
import flash.ui.Keyboard;
import flash.events.KeyboardEvent;
import flash.Lib;
import haxe.Timer;
import flash.display.Sprite;
class TestCamera extends Sprite {

	private var t:Timer;
	private var points:Array<Float>;
	private var lines:Array<Int>;
	private var rot:Float = 0;

	private var STAGEW:Float;
	private var STAGEH:Float;


	private var perspective:Matrix;
	private var camera:Matrix;
	private var camX:Float;
	private var camY:Float;
	private var camZ:Float;
	private var camRot:Float;

	private var keysDown:Array<UInt>;

	private var debugDraw:DebugVec2;
	private var minimap:Sprite;

	private function getTranslateMatrix(x:Float, y:Float, z:Float) {
		var m:Matrix = new Matrix(4,4);
		m.set([
			1,0,0, x,
			0,1,0, y,
			0,0,1, z,
			0,0,0,1
		]);
		return m;
	}
	private function getScaleMatrix(sx:Float, sy:Float, sz:Float) {
		var m:Matrix = new Matrix(4,4);
		m.set([
			sx, 0, 0, 0,
			0, sy, 0, 0,
			0, 0, sz, 0,
			0, 0, 0, 1
		]);
		return m;
	}
	private function getYRotationMatrix(cosAng:Float, sinAng:Float) {
		var m:Matrix = new Matrix(4,4);
		m.set([
			cosAng, 0, sinAng, 0,
			0, 1, 0, 0,
			-sinAng, 0, cosAng, 0,
			0, 0, 0, 1
		]);
		return m;
	}
	private function getXRotationMatrix(cosAng:Float, sinAng:Float) {
		var m:Matrix = new Matrix(4,4);
		m.set([
			1, 0, 0, 0,
			0, cosAng, -sinAng, 0,
			0, sinAng, cosAng, 0,
			0, 0, 0, 1
		]);
		return m;
	}
	private function getZRotationMatrix(cosAng:Float, sinAng:Float) {
		var m:Matrix = new Matrix(4,4);
		m.set([
			cosAng, -sinAng, 0, 0,
			sinAng, cosAng, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 1
		]);
		return m;
	}

	private function onKeyDown(e:KeyboardEvent) {
		keysDown[e.keyCode] = 1;
	}
	private function onKeyUp(e:KeyboardEvent) {
		keysDown[e.keyCode] = 0;
	}


	public function new() {
		super();

		STAGEW = Lib.current.stage.stageWidth / 2.0;
		STAGEH = Lib.current.stage.stageHeight / 2.0;

		keysDown = new Array<UInt>();
		minimap = new Sprite();
		minimap.graphics.lineStyle(0,0);
		minimap.x = STAGEW;
		minimap.y = STAGEH;
		addChild(minimap);
		var minimapDraw = new DebugVec2(minimap.graphics, 20);

		debugDraw = new DebugVec2(graphics, 20);



		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

		camX = camY = camZ = camRot =0.0;


		lines = new Array<Int>();
		points = new Array<Float>();

		perspective = new Matrix(4,4);
		perspective.set([
			1,0,0,0,
			0,1,0,0,
			0,0,1,0,
			0,0,-(1/200),0
		]);

		camera = new Matrix(4,4);

		// build world
		var coords:Array<Float> = new Array();
		for (i in 0...6) {
			for (j in 0...6) {
					var x = i * 60 - 150;
					var z = j * 60 - 150;
					coords.push(x);
					coords.push(0);
					coords.push(z);
					minimapDraw.point(new Point(x/20,z/20), 0xcccccc);

			}
		}



		var cIt:Iterator<Float> = coords.iterator();

		var pOff:Int = 0;
		while(cIt.hasNext()) {

			var tX = cIt.next();
			var tY = cIt.next();
			var tZ = cIt.next();

			var pIt:Iterator<Float> = Cube.points.iterator();
			var m:Matrix = perspective.multiplyMatrix(getTranslateMatrix(tX, tY, tZ)).multiplyMatrix(getScaleMatrix(10,10,10));
			while(pIt.hasNext()) {
				var v:Array<Float> = m.multiplyVector([pIt.next(), pIt.next(), pIt.next(), 1]);
				points.push(v[0]);
				points.push(v[1]);
				points.push(v[2]);
			}
			for(i in 0...Cube.lines.length) {
				lines.push(Cube.lines[i] + pOff);
			}
			pOff = Std.int(points.length/3.0);
		}


		t = new Timer(16);
		t.run = update;
	}

	private function update() {

		if (keysDown[Keyboard.UP] == 1 || keysDown[Keyboard.DOWN] == 1) {
			var spd = keysDown[Keyboard.UP] == 1 ? -0.5 : 0.5;
			var mvX = Math.sin(camRot) * spd;
			var mvZ = Math.cos(camRot) * spd;
			camX += mvX;
			camZ += mvZ;
		}
		if (keysDown[Keyboard.LEFT] == 1) {
			camRot += 0.01;
		} else if (keysDown[Keyboard.RIGHT] == 1) {
			camRot -= 0.01;
		}


//		rot += 0.01;
//		camRot = Math.sin(rot) * 0.5;
//		camZ -= 0.2;

		graphics.clear();
		graphics.lineStyle(0, 0);

		// camera is actually the inverse of our camera!
		var camRotMatrix:Matrix = getYRotationMatrix(Math.cos(camRot), Math.sin(camRot));
		camera = getTranslateMatrix(camX, camY, camZ).multiplyMatrix(camRotMatrix);

		// See this video for info on how to inverse a TR-matrix very fast:
		// https://www.youtube.com/watch?v=7CxKAtWqHC8

		var transpose:Matrix = new Matrix(3,3);
		for(i in 0...3) {
			for (j in 0...3) {
				transpose.setAt(i,j,camera.getAt(j,i));
			}
		}
		var invTranslation = transpose.multiplyVector([
			-camera.getAt(3,0),
			-camera.getAt(3,1),
			-camera.getAt(3,2)
		]);
		var cameraInverse = new Matrix(4,4);
		for(i in 0...3) {
			for (j in 0...3) {
				camera.setAt(j,i,transpose.getAt(j,i));
				cameraInverse.setAt(j,i,transpose.getAt(j,i));
			}
		}
		cameraInverse.setAt(3,0,invTranslation[0]);
		cameraInverse.setAt(3,1,invTranslation[1]);
		cameraInverse.setAt(3,2,invTranslation[2]);


		camera.setAt(3,0, -camera.getAt(3,0));
		camera.setAt(3,0, -camera.getAt(3,0));
		camera.setAt(3,0, -camera.getAt(3,0));

		var m:Matrix = perspective.multiplyMatrix(cameraInverse);

		var dx = camera.getAt(3,0);
		var dz = camera.getAt(3,2);

		draw(m, points, lines);
		debugDraw.vec2(new Vec2(Math.cos(-camRot-Math.PI/2), Math.sin(-camRot-Math.PI/2)), 0x00ff00, new Point(STAGEW/20 + camX/20, STAGEH/20 + camZ/20));
//		debugDraw.vec2(new Vec2(Math.cos(-camRot-Math.PI/2), Math.sin(-camRot-Math.PI/2)), 0xff0000, new Point(STAGEW/20 + dx/20, STAGEH/20 + dz/20));

	}

	private function draw(m:Matrix, p:Array<Float>, l:Array<Int>) {

		var transformedPoints:Array<Array<Float>> = new Array<Array<Float>>();
		var orgIt = p.iterator();
		while(orgIt.hasNext()) {
			var x = orgIt.next();
			var y = orgIt.next();
			var z = orgIt.next();
			transformedPoints.push(m.multiplyVector([x,y,z,1]));
		}

		var lineIt = l.iterator();
		while(lineIt.hasNext()) {
			var pStart = lineIt.next();
			var pEnd = lineIt.next();

			var startValid = transformedPoints[pStart][2] < 0;
			var endValid = transformedPoints[pEnd][2] < 0;

			if (startValid && endValid) { // don't draw anything behind the camera!
				var start = getXY(transformedPoints[pStart]);
				var end = getXY(transformedPoints[pEnd]);

				graphics.moveTo(start[0], start[1]);
				graphics.lineTo(end[0], end[1]);
			}
		}
	}

	private function getXY(vec:Array<Float>):Array<Float> {
		var x = vec[0];
		var y = vec[1];
		var z = vec[2];
		var w = vec[3];
		return [(x/w) + STAGEW, (y/w) + STAGEH];
	}
}
