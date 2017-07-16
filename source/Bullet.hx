package;

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import openfl.Assets;
import openfl.display.BitmapData;

using flixel.util.FlxSpriteUtil;

enum BulletType {
	REGULAR;
	FIRE;
	SMOKE;  // used to make the flamethrower look prettier
}

enum BulletOwner {
	PLAYER;
	ENEMY;
}

class Bullet extends FlxSpriteGroup {
	private var bulletSprite:FlxSprite;
	
	public var type:BulletType;
	public var owner:BulletOwner;
	public var timeAlive:Float = 0;
	public var originalVelocity:FlxPoint;
	
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
		} else if (type == BulletType.FIRE) {
			var fireCircle:BitmapData = Assets.getBitmapData("assets/images/glow_circle.png").clone();
			var colorVariance:Float = 8;
			fireCircle.colorTransform(fireCircle.rect, new ColorTransform(1, 1, 1, 1,
				2 * colorVariance * Math.random() - colorVariance,
				2 * colorVariance * Math.random() - colorVariance, 0));
			bulletSprite = new FlxSprite();
			bulletSprite.loadGraphic(fireCircle);
			bulletSprite.x = bulletSprite.y = -20;
			add(bulletSprite);
			
			originalVelocity = this.velocity;
		} else if (type == BulletType.SMOKE) {
			var smokeCircle:BitmapData = Assets.getBitmapData("assets/images/glow_circle.png").clone();
			var color:Float = 20 + 30 * Math.random();
			smokeCircle.colorTransform(smokeCircle.rect, new ColorTransform(0, 0, 0, 1, color, color, color));
			bulletSprite = new FlxSprite();
			bulletSprite.loadGraphic(smokeCircle);
			bulletSprite.x = bulletSprite.y = -20;
			add(bulletSprite);
			var bulletSpriteScale:Float = 0.8 - 0.3 * Math.random();
			bulletSprite.scale = new FlxPoint(bulletSpriteScale, bulletSpriteScale);
			
			originalVelocity = this.velocity;
		}
    }
	public function shouldDelete():Bool {
		if (type == BulletType.FIRE) {
			return timeAlive >= 1.0;
		} else if (type == BulletType.SMOKE) {
			return timeAlive >= 0.8;
		}
		return false;
	}
	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
		super.update(elapsed);
		var origTimeAlive = timeAlive;
		timeAlive += elapsed;
		
		if (type == BulletType.FIRE) {
			this.velocity.set(originalVelocity.x * (1. - 0.13 * timeAlive),
							  originalVelocity.y * (1. - 0.13 * timeAlive));
			
			if (origTimeAlive < 0.33 && timeAlive >= 0.33) {
				this.bulletSprite.scale = new FlxPoint(0.9, 0.9);
				this.bulletSprite.alpha = 0.66;
				this.bulletSprite.updateHitbox();
			}
			if (origTimeAlive < 0.66 && timeAlive >= 0.66) { 
				this.bulletSprite.scale = new FlxPoint(0.8, 0.8);
				this.bulletSprite.alpha = 0.33;
				this.bulletSprite.updateHitbox();
			}
		} else if (type == BulletType.SMOKE) {
			this.velocity.set(originalVelocity.x * (1. - 0.17 * timeAlive),
							  originalVelocity.y * (1. - 0.17 * timeAlive));
		}
	}
}