package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class Player extends FlxSpriteGroup {
	private var playerSprite:FlxSprite;
    public function new(?X:Float=0, ?Y:Float=0) {
        super(X, Y);
		
		playerSprite = new FlxSprite();
        playerSprite.makeGraphic(32, 32, FlxColor.BLUE);
		playerSprite.x = playerSprite.y = -16;
		add(playerSprite);
    }
}