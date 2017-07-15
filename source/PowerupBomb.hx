package;

import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import openfl.Assets;
import openfl.display.BitmapData;

using flixel.util.FlxSpriteUtil;
using Powerup.PowerupType;

class PowerupBomb extends FlxSpriteGroup {
	private var bombSprite:FlxSprite;
	private var bombOutlineSprite:FlxSprite;
	private var bombFuseSprite:FlxSprite = null;
	
	private var SPRITE_WIDTH:Int = 40;
	private var SPRITE_HEIGHT:Int = 40;
	private var FUSE_WIDTH:Int = 60;
	private var FUSE_HEIGHT:Int = 20;
	
	private var _bombState:Int = 0;  // unlit
	private var _tickDuration:Float = 1;
	
	private var _type:PowerupType;
    public function new(?X:Float=0, ?Y:Float=0, type:PowerupType) {
        super(X, Y);
		_type = type;
		
		var bombBitmapData:BitmapData = Assets.getBitmapData("assets/images/bomb.png");
		
		var bombInteriorBitmapData:BitmapData = new BitmapData(SPRITE_WIDTH, SPRITE_HEIGHT);
		bombInteriorBitmapData.copyPixels(
			bombBitmapData, new Rectangle(SPRITE_WIDTH, 0, SPRITE_WIDTH, SPRITE_HEIGHT), new Point(0, 0));
		var desiredColor:FlxColor = Powerup.getColorOfType(type);
		bombInteriorBitmapData.colorTransform(
			bombInteriorBitmapData.rect,
			new ColorTransform(1, 1, 1, 1,
							   desiredColor.red * 7/10, desiredColor.green * 7/10, desiredColor.blue * 7/10));
			
		var bombOutlineBitmapData:BitmapData = new BitmapData(SPRITE_WIDTH, 40);
		bombOutlineBitmapData.copyPixels(
			bombBitmapData, new Rectangle(0, 0, SPRITE_WIDTH, SPRITE_HEIGHT), new Point(0, 0));
			
		bombSprite = new FlxSprite();
		bombSprite.loadGraphic(bombInteriorBitmapData);
		bombSprite.x = -SPRITE_WIDTH / 2;
		bombSprite.y = -SPRITE_HEIGHT / 2;
		
		bombOutlineSprite = new FlxSprite();
		bombOutlineSprite.loadGraphic(bombOutlineBitmapData);
		bombOutlineSprite.x = -SPRITE_WIDTH / 2;
		bombOutlineSprite.y = -SPRITE_HEIGHT / 2;
		
		add(bombSprite);
		add(bombOutlineSprite);
		makeBombFuseSprite();
    }
	public function getType():PowerupType {
		return _type;
	}
	
	public function isLit():Bool {
		return _bombState != 0;
	}
	
	public function light():Void {
		_bombState = 1;
		makeBombFuseSprite();
	}
	
	public function isExploding():Bool {
		return _bombState == 4;
	}
	
	public function addToTickDuration(amt:Float):Void {
		_tickDuration += amt;
	}
	
	private function makeBombFuseSprite() {
		if (bombFuseSprite != null) {
			bombFuseSprite.destroy();
		}
		var bombFuseSrcBitmapData:BitmapData = Assets.getBitmapData("assets/images/bomb_fuse.png");
		
		var bombFuseBitmapData:BitmapData = new BitmapData(FUSE_WIDTH, FUSE_HEIGHT);
			bombFuseBitmapData.copyPixels(
				bombFuseSrcBitmapData, new Rectangle(0, FUSE_HEIGHT * _bombState, FUSE_WIDTH, FUSE_HEIGHT), new Point(0, 0));
		bombFuseSprite = new FlxSprite();
		bombFuseSprite.loadGraphic(bombFuseBitmapData);
		bombFuseSprite.x = -40;
		bombFuseSprite.y = -26;
		add(bombFuseSprite);
	}
	
	override public function getHitbox(?rect:FlxRect):FlxRect {
		return bombSprite.getHitbox();
	}
	
	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
		if (_bombState > 0) {
			_tickDuration += elapsed;
			var newState:Int = Std.int(_tickDuration);
			if (newState > _bombState) {
				if (newState >= 4) {
					_bombState = newState = 4;  // just in case!
				} else {
					_bombState = newState;
					makeBombFuseSprite();
				}
			}
		}
		super.update(elapsed);
	}
}