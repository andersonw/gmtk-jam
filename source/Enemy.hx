package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Enemy extends Character {

    public function new(?X:Float=0, ?Y:Float=0) {
        super(X, Y, FlxColor.ORANGE);
    }
	override public function update(elapsed:Float):Void {
	}
	override public function _update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
