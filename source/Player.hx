package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class Player extends Character {

    public function new(?X:Float=0, ?Y:Float=0) {
        super(X, Y, FlxColor.BLUE, 5);
        _healthbarVisible = true;
    }
	override public function update(elapsed:Float):Void {
	}
	override public function _update(elapsed:Float):Void {
		super._update(elapsed);
	}
}