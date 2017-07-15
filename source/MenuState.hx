package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;

class MenuState extends FlxState {
	var titleText:FlxText;
	var helpText:FlxText;
	
	override public function create():Void {
		super.create();
		
		bgColor = new FlxColor(0xff000000);

		var swatch:FlxSprite = new FlxSprite();
		swatch.loadGraphic("assets/images/swatch.png");
		swatch.x = 40;
		swatch.y = 118;
		add(swatch);
		
		titleText = new FlxText(70, 100, 0, "Luge Brothers XXIV");
		titleText.setFormat("assets/fonts/RobotoSlab-Bold.ttf");
		titleText.size = 40;
		//titleText.setFormat(AssetPaths.pixelmix__ttf, 48, FlxColor.RED);
		add(titleText);

		helpText = new FlxText(500, 650, 0, "[SPACE] START");
		helpText.setFormat("assets/fonts/RobotoSlab-Bold.ttf");
		helpText.size = 32;
		//helpText.setFormat(AssetPaths.pixelmix__ttf, 32, FlxColor.WHITE);
		add(helpText);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE) {
			FlxG.switchState(new PlayState());
		}
	}
}
