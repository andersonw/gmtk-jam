package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

enum PowerupType {
	NONE;
	FIRE;
	ICE;
	LIGHTNING;
	POISON;
	LUGE;
}

class Powerup extends FlxSpriteGroup {
	private var _playState:PlayState;

	private static var kPowerupToColorMap:Map<PowerupType, FlxColor> =
		[FIRE => FlxColor.RED, ICE => FlxColor.BLUE,
		 LIGHTNING => FlxColor.YELLOW, POISON => FlxColor.GREEN,
		 LUGE => FlxColor.WHITE];
	 
	private var powerupSprite:FlxSprite;
	private var _type:PowerupType;
    public function new(?X:Float=0, ?Y:Float=0, type:PowerupType, ?playState:PlayState) {
        super(X, Y);
		_type = type;
		_playState = playState;
		
		powerupSprite = new FlxSprite();
		powerupSprite.makeGraphic(20, 20, FlxColor.TRANSPARENT, true);
		powerupSprite.x = powerupSprite.y = -10;
		powerupSprite.drawPolygon([new FlxPoint(10, 0), new FlxPoint(0, 6), new FlxPoint(4, 20), new FlxPoint(16, 20), new FlxPoint(20, 6)],
								  kPowerupToColorMap[type], { }, { } );
		add(powerupSprite);
    }
	public function getType():PowerupType {
		return _type;
	}
	
	override public function getHitbox(?rect:FlxRect):FlxRect {
		return powerupSprite.getHitbox();
	}
	
	// static methods
	public static function getRandomType():PowerupType {
		return [FIRE, ICE, LIGHTNING, POISON, LUGE][Std.int(Math.random() * 5)];
	}
	public static function getColorOfType(type:PowerupType):FlxColor {
		return kPowerupToColorMap[type];
	}
	
	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
		super.update(elapsed);
	}
}