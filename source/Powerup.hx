package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

enum PowerupType {
	FIRE;
	ICE;
	LIGHTNING;
	POISON;
	LUGE;
}

class Powerup extends FlxSpriteGroup {
	private var powerupSprite:FlxSprite;
	private var _type:PowerupType;
    public function new(?X:Float=0, ?Y:Float=0, type:PowerupType) {
        super(X, Y);
		_type = type;
		
		powerupSprite = new FlxSprite();
		powerupSprite.makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
		powerupSprite.x = powerupSprite.y = -5;
		powerupSprite.drawPolygon([new FlxPoint(5, 0), new FlxPoint(0, 3), new FlxPoint(2, 9), new FlxPoint(8, 9), new FlxPoint(10, 3)],
								  FlxColor.GREEN, { }, { } );
		add(powerupSprite);
    }
	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
		super.update(elapsed);
	}
}