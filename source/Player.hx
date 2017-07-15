package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite {
    public function new(?X:Float=0, ?Y:Float=0) {
        super(X, Y);
        makeGraphic(32, 32, FlxColor.BLUE);
    }
}