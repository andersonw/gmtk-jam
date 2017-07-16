package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;

class LevelHUD extends FlxSpriteGroup {
	private var duration:Float;
	
	private var bgMenuImage:FlxSprite;
	private var scoreText:FlxText;
	private var levelText:FlxText;
	
    public function new(?X:Float=0, ?Y:Float=0, ?duration:Float) {
        super(X, Y);
		
		bgMenuImage = new FlxSprite();
		bgMenuImage.loadGraphic("assets/images/level_hud_bg.png");
		
		scoreText = new FlxText(70, 30, 0, "");
		scoreText.size = 30;
		scoreText.setFormat("assets/fonts/RobotoSlab-Bold.ttf");
		levelText = new FlxText(70, 60, 0, "");
		levelText.size = 30;
		levelText.setFormat("assets/fonts/RobotoSlab-Bold.ttf");
		
		add(bgMenuImage);
		add(scoreText);
		add(levelText);
		updateText(0, 1);
    }
	public function updateText(score:Int, level:Int) {
		scoreText.text = "Score: " + score;
		scoreText.size = 24;
		levelText.text = "Level: " + level;
		levelText.size = 24;
	}
	public override function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}