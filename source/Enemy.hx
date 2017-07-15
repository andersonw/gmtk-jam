package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Enemy extends FlxSprite {

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        makeGraphic(32, 32, FlxColor.ORANGE, true);
    }

}
