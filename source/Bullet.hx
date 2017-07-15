package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

enum BulletType {
	REGULAR;
}

enum BulletOwner {
	PLAYER;
	ENEMY;
}

class Bullet extends FlxSpriteGroup {
	private var bulletSprite:FlxSprite;
	
	public var type:BulletType;
	public var owner:BulletOwner;
	
    public function new(?X:Float=0, ?Y:Float=0, ?type:BulletType, ?owner:BulletOwner) {
        super(X, Y);
		this.type = type;
		this.owner = owner;
		
		if (type == BulletType.REGULAR) {
			bulletSprite = new FlxSprite();
			bulletSprite.makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
			bulletSprite.x = bulletSprite.y = -5;
			if (owner == BulletOwner.PLAYER) {
				bulletSprite.drawCircle(5, 5, 5, FlxColor.YELLOW);
			}
			else if (owner == BulletOwner.ENEMY) {
				bulletSprite.drawCircle(5, 5, 5, FlxColor.RED);
			}
			add(bulletSprite);
		}
    }
	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
		super.update(elapsed);
	}
}