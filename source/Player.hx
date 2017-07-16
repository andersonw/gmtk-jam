package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

using Powerup.PowerupType;

class Player extends Character {
	public var powerupType:PowerupType;

    public function new(?X:Float=0, ?Y:Float=0) {
        super(X, Y, FlxColor.BLUE, 5);
        _healthbarVisible = true;
		powerupType = PowerupType.NONE;
    }
	override public function update(elapsed:Float):Void {
	}
	override public function _update(elapsed:Float):Void {
		super._update(elapsed);
	}
}