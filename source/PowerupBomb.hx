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
	
	private var SPRITE_WIDTH:Int = 40;
	private var SPRITE_HEIGHT:Int = 40;
	
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
    }
	public function getType():PowerupType {
		return _type;
	}
	
	override public function getHitbox(?rect:FlxRect):FlxRect {
		return bombSprite.getHitbox();
	}
	
	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
		super.update(elapsed);
	}
}