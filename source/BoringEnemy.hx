package;

class BoringEnemy extends Enemy {
    public function new(?X:Float=0, ?Y:Float=0, ?playState:PlayState) {
        super(X, Y, playState);
    }
    override public function update(elapsed:Float):Void {
	}
	override public function _update(elapsed:Float):Void {
		super._update(elapsed);
	}

    override public function move():Void {
        var ENEMY_VELOCITY:Float = 30.0;
		var angle:Float = Math.atan2(_playState._player.y - y, _playState._player.x - x);
		velocity.set(ENEMY_VELOCITY * Math.cos(angle), ENEMY_VELOCITY * Math.sin(angle));
    }
}