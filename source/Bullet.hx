package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

enum BulletType {
	REGULAR;
}

class Bullet extends FlxSpriteGroup {
	private var bulletSprite:FlxSprite;
	
	public var type:BulletType;
	
    public function new(?X:Float=0, ?Y:Float=0, ?type:BulletType) {
        super(X, Y);
		this.type = type;
		
		if (type == BulletType.REGULAR) {
			bulletSprite = new FlxSprite();
			bulletSprite.makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
			bulletSprite.x = bulletSprite.y = -5;
			bulletSprite.drawCircle(5, 5, 5, FlxColor.YELLOW);
			add(bulletSprite);
		}
    }
	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
		super.update(elapsed);
	}
}