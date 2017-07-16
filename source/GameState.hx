package;

class GameState {
	public var score:Int;
	public var level:Int;
	public function new() {
		reset();
	}
	public function reset() {
		score = 0;
		level = 1;
	}
}