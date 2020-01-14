package se.salomonsson.math.test;
import flash.events.KeyboardEvent;
import flash.display.Stage;
class KeyboardHelper {

	private var keysDown:Array<Bool>;

	public function new(stage:Stage) {
		keysDown = new Array<Bool>();

		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}

	private function onKeyDown(e:KeyboardEvent) {
		keysDown[e.keyCode] = true;
	}
	private function onKeyUp(e:KeyboardEvent) {
		keysDown[e.keyCode] = false;
	}

	public function keyIsDown(key:UInt):Bool {
		return keysDown[key];
	}
}
