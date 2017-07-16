package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

using Powerup.PowerupType;

class Player extends Character {
	public var powerupType:PowerupType;
    public var timeUntilPowerupExpires:Float;
    private var _playState:PlayState;

    public function new(?X:Float=0, ?Y:Float=0, ?playState:PlayState) {
        super(X, Y, FlxColor.BLUE, 5);
        _playState = playState;

        _healthbarVisible = true;
		powerupType = PowerupType.NONE;
        timeUntilPowerupExpires = 0;
    }
	override public function update(elapsed:Float):Void {
	}
	override public function _update(elapsed:Float):Void {
        if (powerupType != PowerupType.NONE) {
            timeUntilPowerupExpires -= elapsed;
            if (timeUntilPowerupExpires <= 0) {
                powerupType = PowerupType.NONE;
                _playState.levelHUD.updateCard(PowerupType.NONE);
            }
        }
		super._update(elapsed);
	}
}