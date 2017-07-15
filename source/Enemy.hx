package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Enemy extends Character {
    private var _playState:PlayState;

    public function new(?X:Float=0, ?Y:Float=0, ?playState:PlayState) {
        super(X, Y, FlxColor.ORANGE, 5);
        _healthbarVisible = true;
        _playState = playState;
    }
	override public function update(elapsed:Float):Void {
	}
	override public function _update(elapsed:Float):Void {
		super._update(elapsed);
	}

    public function move():Void {
        // default Colin move
        var ENEMY_VELOCITY:Float = 30.0;
        velocity.set(ENEMY_VELOCITY,0);
		velocity.rotate(FlxPoint.weak(0, 0), (Math.random() * 360));
    }
}
