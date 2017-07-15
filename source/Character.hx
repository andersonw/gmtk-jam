package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class Character extends FlxSpriteGroup {
	private var characterSprite:FlxSprite;
    private var healthbarSprite:FlxSprite;
    private var healthbarVisible:Bool;

    public function new(?X:Float=0, ?Y:Float=0, ?color:FlxColor=FlxColor.BLUE) {
        super(X, Y);
		
		characterSprite = new FlxSprite();
        characterSprite.makeGraphic(32, 32, color, true);
		characterSprite.x = characterSprite.y = -16;
		add(characterSprite);

        healthbarSprite = new FlxSprite();
        healthbarSprite.makeGraphic(32, 10, FlxColor.RED);
        healthbarSprite.x = characterSprite.x;
        healthbarSprite.y = characterSprite.y + 16;
        add(healthbarSprite);
    }
	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
		super.update(elapsed);
	}
}