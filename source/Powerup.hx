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

enum PowerupType {
	NONE;
	FIRE;
	ICE;
	LIGHTNING;
	METAL;
	LUGE;
}

class Powerup extends FlxSpriteGroup {
	private var _playState:PlayState;
    public var isInvincible:Bool;
    public var isInvincibleToBombs:Bool;
	private var SPRITE_WIDTH:Int = 40;
	private var SPRITE_HEIGHT:Int = 40;

	private static var kPowerupToColorMap:Map<PowerupType, FlxColor> =
		[FIRE => FlxColor.RED, ICE => FlxColor.BLUE,
		 LIGHTNING => FlxColor.YELLOW, METAL => FlxColor.GRAY,
		 LUGE => FlxColor.WHITE];
	
	// just in case we want to change individual cooldowns
	private static var kPowerupToCooldownMap:Map<PowerupType, Int> =
		[FIRE => 15, ICE => 5, LIGHTNING => 25, METAL => 25, LUGE => 9999999];		
	 
	public var bombSprite:FlxSprite;
	private var bombOutlineSprite:FlxSprite;
	private var _type:PowerupType;
    public function new(?X:Float=0, ?Y:Float=0, type:PowerupType, ?playState:PlayState) {
        super(X, Y);
		_type = type;
		_playState = playState;
		isInvincible = true;
        haxe.Timer.delay(makeVulnerable.bind(), 1000);
		
		
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

    public function makeVulnerable() {
        isInvincible = false;
    }
	public function setInvulnerableToBombs() {
		isInvincibleToBombs = true;
        haxe.Timer.delay(makeVulnerableToBombs.bind(), 3000);
	}
    public function makeVulnerableToBombs() {
        isInvincibleToBombs = false;
    }
	
	override public function getHitbox(?rect:FlxRect):FlxRect {
		return bombSprite.getHitbox();
	}
	
	// static methods
	public static function getRandomType():PowerupType {
		return [FIRE, LIGHTNING, METAL][Std.int(Math.random() * 3)];
	}
	public static function getColorOfType(type:PowerupType):FlxColor {
		return kPowerupToColorMap[type];
	}
	public static function getCooldownOfType(type:PowerupType):Int {
		return kPowerupToCooldownMap[type];
	}
	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
		super.update(elapsed);
	}
}