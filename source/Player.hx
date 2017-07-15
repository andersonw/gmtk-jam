package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class Player extends FlxSpriteGroup {
	public var _velocity:FlxPoint;
	
	private var playerSprite:FlxSprite;
    public function new(?X:Float=0, ?Y:Float=0) {
        super(X, Y);
		
		playerSprite = new FlxSprite();
        playerSprite.makeGraphic(32, 32, FlxColor.BLUE);
		playerSprite.x = playerSprite.y = -16;
		add(playerSprite);
    }
	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
		super.update(elapsed);
	}
}