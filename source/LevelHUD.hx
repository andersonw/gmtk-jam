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

	private static var POWERUP_BAR_HEIGHT = 80;
	
    public function new(?X:Float=0, ?Y:Float=0, ?playState:PlayState) {
        super(X, Y);
		this.playState = playState;

		bgMenuImage = new FlxSprite();
		bgMenuImage.loadGraphic("assets/images/level_hud_bg.png");
		
		powerupCard = new FlxSprite();
		powerupCard.loadGraphic(AssetPaths.normal_card__png);
		powerupCard.x = 20;
		powerupCard.y = 15;

		powerupBar = new FlxSprite(103, 20);
		powerupBar.makeGraphic(10, POWERUP_BAR_HEIGHT, FlxColor.WHITE);
		powerupBarCover = new FlxSprite(103, 20);
		powerupBarCover.makeGraphic(10, POWERUP_BAR_HEIGHT, FlxColor.GREEN);
		
		scoreText = new FlxText(130, 30, 0, "");
		scoreText.size = 30;
		scoreText.setFormat("assets/fonts/RobotoSlab-Bold.ttf");
		levelText = new FlxText(130, 60, 0, "");
		levelText.size = 30;
		levelText.setFormat("assets/fonts/RobotoSlab-Bold.ttf");
		
		add(bgMenuImage);
		
		add(powerupCard);
		add(powerupBar);
		add(powerupBarCover);
		add(scoreText);
		add(levelText);
		updateText(0, 1);
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
	public function updateText(score:Int, level:Int) {
		scoreText.text = "Score: " + score;
		scoreText.size = 24;
		levelText.text = "Level: " + level;
		levelText.size = 24;
	}
	public override function update(elapsed:Float):Void {
		if (playState._player.powerupType == Powerup.PowerupType.NONE) {
			powerupBarCover.makeGraphic(10, POWERUP_BAR_HEIGHT, new FlxColor(0xFF434343));
		}
		else {
			var currentPowerup:Powerup.PowerupType = playState._player.powerupType;
			var timeFraction:Float = playState._player.timeUntilPowerupExpires / 
									 Powerup.getCooldownOfType(currentPowerup);
			if (timeFraction < 0) timeFraction = 0;
			var barHeight:Int = Std.int((1-timeFraction) * POWERUP_BAR_HEIGHT);
			if (barHeight > 0) {
				powerupBarCover.makeGraphic(10, barHeight, new FlxColor(0xFF434343));
			}
		}
		super.update(elapsed);
	}
}