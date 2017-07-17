package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using Powerup.PowerupType;

class LevelHUD extends FlxSpriteGroup {
	private var playState:PlayState;
	
	private var bgMenuImage:FlxSprite;
	public var powerupCard:FlxSprite;
	private var powerupBar:FlxSprite;
	private var powerupBarCover:FlxSprite;
	private var scoreText:FlxText;
	private var levelText:FlxText;
	private var enemiesLeftText:FlxText;
	private var timeText:FlxText;

	private static var POWERUP_BAR_HEIGHT = 80;
	
    public function new(?X:Float=0, ?Y:Float=0, ?playState:PlayState) {
        super(X, Y);
		this.playState = playState;

		bgMenuImage = new FlxSprite();
		bgMenuImage.loadGraphic("assets/images/level_hud_bg.png");
		
		powerupCard = new FlxSprite();
		powerupCard.loadGraphic(AssetPaths.normal_card__png);
		powerupCard.x = 20;
		powerupCard.y = 17;

		powerupBar = new FlxSprite(98, 22);
		powerupBar.makeGraphic(10, POWERUP_BAR_HEIGHT, FlxColor.WHITE);
		powerupBarCover = new FlxSprite(98, 22);
		powerupBarCover.makeGraphic(10, POWERUP_BAR_HEIGHT, FlxColor.GREEN);
		
		var TEXT_X_POSITION:Float = 118;
		var TEXT_Y_POSITION:Float = 16;
		var TEXT_SPACING:Float = 30;
		
		scoreText = new FlxText(TEXT_X_POSITION, TEXT_Y_POSITION, 0, "");
		scoreText.setFormat("assets/fonts/RobotoSlab_Bold.ttf");
		
		levelText = new FlxText(TEXT_X_POSITION, TEXT_Y_POSITION + TEXT_SPACING + 3, 0, "");
		levelText.setFormat("assets/fonts/RobotoSlab_Bold.ttf");
		
		enemiesLeftText = new FlxText(TEXT_X_POSITION, TEXT_Y_POSITION + 2*TEXT_SPACING, 0, "");
		enemiesLeftText.setFormat("assets/fonts/RobotoSlab_Bold.ttf");

		timeText = new FlxText(TEXT_X_POSITION + 80, TEXT_Y_POSITION + TEXT_SPACING + 3, 0, "");
		timeText.setFormat(AssetPaths.RobotoSlab_Bold__ttf);
		timeText.size = 16;
		
		add(bgMenuImage);
		
		add(powerupCard);
		add(powerupBar);
		add(powerupBarCover);
		add(scoreText);
		add(levelText);
		add(enemiesLeftText);
		add(timeText);
		updateText(0, 1, 0);
    }
	public function updateCard(type:PowerupType) {
		powerupBar.color = Powerup.getColorOfType(type);
		if (type == PowerupType.FIRE) {
			powerupCard.loadGraphic(AssetPaths.fire_card__png);
		} else if (type == PowerupType.LIGHTNING) {
			powerupCard.loadGraphic(AssetPaths.lightning_card__png);
		} else if (type == PowerupType.METAL) {
			powerupCard.loadGraphic(AssetPaths.metal_card__png);
		} else {
			powerupCard.loadGraphic(AssetPaths.normal_card__png);
		}
	}
	public function updateText(score:Int, level:Int, enemiesLeft:Int) {
		scoreText.text = "Score: " + score;
		scoreText.size = 20;
		levelText.text = "Level: " + level;
		levelText.size = 16;
        // BOSS LEVEL
        if(level == 5) {
            enemiesLeftText.text = "Defeat the Boss!";
            enemiesLeftText.size = 20;
        }
        else {
            enemiesLeftText.text = "Enemies Left: " + enemiesLeft;
            enemiesLeftText.size = 20;
        }
	}
	public override function update(elapsed:Float):Void {
		timeText.text = "Time: " + Std.int(playState._gameState.timeLeft + 1);

		if (playState._player.powerupType == Powerup.PowerupType.NONE) {
			powerupBarCover.makeGraphic(10, POWERUP_BAR_HEIGHT, new FlxColor(0xFF434343));
		}
		else {
			var currentPowerup:Powerup.PowerupType = playState._player.powerupType;
			var timeFraction:Float = playState._player.timeUntilPowerupExpires / 
									 Powerup.getCooldownOfType(currentPowerup);
			if (timeFraction < 0) timeFraction = 0;
			var barHeight:Int = Std.int((1-timeFraction) * POWERUP_BAR_HEIGHT);
			if (barHeight == 0) {
				powerupBarCover.visible = false;
			}
			else if (barHeight > 0) {
				powerupBarCover.visible = true;
				powerupBarCover.makeGraphic(10, barHeight, new FlxColor(0xFF434343));
			}
		}
		super.update(elapsed);
	}
}