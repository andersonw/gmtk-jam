package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Enemy extends FlxSprite {
	public var _velocity:FlxPoint;

    public function new(?X:Float=0, ?Y:Float=0) {
        super(X, Y);
        makeGraphic(32, 32, FlxColor.ORANGE, true);
    }
	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
