package;
import flixel.FlxG;
import flixel.util.FlxColor;

class TankEnemy extends Enemy {
    private var _bulletSpawnTimer:Float;
    private static var BULLET_COOLDOWN:Float = 1.0;

    public function new(?X:Float=0, ?Y:Float=0, ?playState:PlayState) {
        super(X, Y, FlxColor.GREEN, 100, playState);
        _bulletSpawnTimer = 0;
    }
    override public function update(elapsed:Float):Void {
	}
	override public function _update(elapsed:Float):Void {
        _bulletSpawnTimer += elapsed;
        if (_bulletSpawnTimer > BULLET_COOLDOWN) {
            _bulletSpawnTimer -= BULLET_COOLDOWN;
            for (i in 0...10) {
                var angle:Float = Math.atan2(_playState._player.y - y, _playState._player.x - x) + FlxG.random.float(-0.5,0.5);
                var DISTANCE_SPAWN_FROM_ENEMY:Float = 32.0;
                var BULLET_VELOCITY:Float = 100.0;
                var bullet:Bullet = new Bullet(x + DISTANCE_SPAWN_FROM_ENEMY * Math.cos(angle),
                                            y + DISTANCE_SPAWN_FROM_ENEMY * Math.sin(angle),
                                            Bullet.BulletType.REGULAR, Bullet.BulletOwner.ENEMY);
                bullet.velocity.set(BULLET_VELOCITY * Math.cos(angle), BULLET_VELOCITY * Math.sin(angle));
                _playState._bullets.push(bullet);
                _playState.add(bullet);
            }
        }
		super._update(elapsed);
	}

    override public function move():Void {
        var ENEMY_VELOCITY:Float = 10.0;
		var angle:Float = Math.atan2(_playState._player.y - y, _playState._player.x - x);
		velocity.set(ENEMY_VELOCITY * Math.cos(angle), ENEMY_VELOCITY * Math.sin(angle));
    }
}