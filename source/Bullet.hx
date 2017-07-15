package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Bullet extends FlxSpriteGroup {
	private var bulletSprite:FlxSprite;
    public function new(?X:Float=0, ?Y:Float=0) {
        super(X, Y);
		
		bulletSprite = new FlxSprite();
		bulletSprite.makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
		bulletSprite.x = bulletSprite.y = -5;
		bulletSprite.drawCircle(5, 5, 5, FlxColor.YELLOW);
		add(bulletSprite);
    }
	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
		super.update(elapsed);
	}
}