package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxSprite;

enum EnemyState {
    IDLE;
    CHASING;
}

class Enemy extends Character {
    private var enemyType:String;
    private var _playState:PlayState;
    private var _state:EnemyState;

    public function new(?X:Float=0, ?Y:Float=0, ?color:FlxColor=FlxColor.ORANGE, ?maxHealth:Int=5, ?playState:PlayState) {
        super(X, Y, color, maxHealth);
        _healthbarVisible = true;
        _playState = playState;
        _state = EnemyState.IDLE;
    }
	override public function update(elapsed:Float):Void {
	}
	override public function _update(elapsed:Float):Void {
		super._update(elapsed);
	}

    public function move():Void {
        var ENEMY_VELOCITY:Float = 30.0;
        velocity.set(ENEMY_VELOCITY,0);
		velocity.rotate(FlxPoint.weak(0, 0), (Math.random() * 360));
    }

    public function getEnemyType(){
        return enemyType;
    }
}
