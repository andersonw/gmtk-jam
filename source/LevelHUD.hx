package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;

using Powerup.PowerupType;

class LevelHUD extends FlxSpriteGroup {
	private var duration:Float;
	
	private var bgMenuImage:FlxSprite;
	public var powerupCard:FlxSprite;
	private var scoreText:FlxText;
	private var levelText:FlxText;
	private var enemiesLeftText:FlxText;
	
    public function new(?X:Float=0, ?Y:Float=0, ?duration:Float) {
        super(X, Y);
		
		bgMenuImage = new FlxSprite();
		bgMenuImage.loadGraphic("assets/images/level_hud_bg.png");
		
		powerupCard = new FlxSprite();
		powerupCard.loadGraphic(AssetPaths.normal_card__png);
		powerupCard.x = 20;
		powerupCard.y = 15;
		
		scoreText = new FlxText(115, 20, 0, "");
		scoreText.setFormat("assets/fonts/RobotoSlab-Bold.ttf");
		
		levelText = new FlxText(115, 50, 0, "");
		levelText.setFormat("assets/fonts/RobotoSlab-Bold.ttf");
		
		enemiesLeftText = new FlxText(115, 80, 0, "");
		enemiesLeftText.setFormat("assets/fonts/RobotoSlab-Bold.ttf");
		
		add(bgMenuImage);
		
		add(powerupCard);
		add(scoreText);
		add(levelText);
		add(enemiesLeftText);
		updateText(0, 1, 0);
    }
	public function updateCard(type:PowerupType) {
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
		levelText.size = 20;
		enemiesLeftText.text = "Enemies Left: " + enemiesLeft;
		enemiesLeftText.size = 20;
	}
	public override function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}