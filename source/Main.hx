package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite {
	public static var GAME_WIDTH:Int = 1024;
	public static var GAME_HEIGHT:Int = 768;
	
	public static var gameState:GameState;
	
	public function new() {
		super();
		gameState = new GameState();
		
		addChild(new FlxGame(GAME_WIDTH, GAME_HEIGHT, MenuState));
	}
}
