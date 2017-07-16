package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;

class GameOverState extends FlxState {
	var gameOverText:FlxText;
	var infoText:FlxText;
	var helpText:FlxText;
	
	override public function create():Void {
		super.create();
		
		bgColor = new FlxColor(0xff000000);
		
		gameOverText = new FlxText(70, 100, 0, "GAME OVER");
		gameOverText.setFormat("assets/fonts/RobotoSlab-Bold.ttf");
		gameOverText.size = 64;
		add(gameOverText);

		infoText = new FlxText(500, 650, 0, "Your score: " + Main.gameState.score);
		infoText.setFormat("assets/fonts/RobotoSlab-Bold.ttf");
		infoText.size = 32;
		add(infoText);

		helpText = new FlxText(500, 650, 0, "[SPACE] Return to Main Menu");
		helpText.setFormat("assets/fonts/RobotoSlab-Bold.ttf");
		helpText.size = 32;
		add(helpText);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE) {
			FlxG.switchState(new MenuState());
		}
	}
}
