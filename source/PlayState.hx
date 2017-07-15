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

	var redSquare:FlxSprite;

	private var _shrinkSound:FlxSound;

	override public function create():Void {
		super.create();

		bgColor = new FlxColor(0xff303030);

		titleText = new FlxText(40, 100, 0, "Luge Brothers XXIV");
		titleText.setFormat(AssetPaths.pixelmix__ttf, 48, FlxColor.WHITE);
		add(titleText);

		helpText = new FlxText(500, 450, 0, "[SPACE] START");
		helpText.setFormat(AssetPaths.pixelmix__ttf, 32, FlxColor.WHITE);
		add(helpText);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE) {
			FlxG.switchState(new PlayState());
		}
	}
}