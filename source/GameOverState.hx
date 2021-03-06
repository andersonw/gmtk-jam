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
		if(Main.gameState.gameCompleted) {
            gameOverText = new FlxText(70, 50, 0, "CONGRATULATIONS!
            YOU WIN!");
        }
        else {
            gameOverText = new FlxText(70, 50, 0, "GAME OVER");
        }
		gameOverText.setFormat("assets/fonts/RobotoSlab_Bold.ttf");
		gameOverText.size = 64;
		add(gameOverText);

		infoText = new FlxText(500, 550, 0, "Your score: " + Main.gameState.score);
		infoText.setFormat("assets/fonts/RobotoSlab_Bold.ttf");
		infoText.size = 32;
		add(infoText);

		helpText = new FlxText(500, 650, 0, "[SPACE] Return to Main Menu");
		helpText.setFormat("assets/fonts/RobotoSlab_Bold.ttf");
		helpText.size = 32;
		add(helpText);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE) {
            Main.gameState.resetGame();
			FlxG.switchState(new MenuState());
		}
	}
}
