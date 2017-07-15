package;
import flixel.FlxG;

class CrazyEnemy extends Enemy {
    private var _bulletSpawnTimer:Float;
    private static var BULLET_COOLDOWN:Float = 0.03;

    public function new(?X:Float=0, ?Y:Float=0, ?playState:PlayState) {
        super(X, Y, playState);
        _bulletSpawnTimer = 0;
    }
    override public function update(elapsed:Float):Void {
	}
	override public function _update(elapsed:Float):Void {
        _bulletSpawnTimer += elapsed;
        if (_bulletSpawnTimer > BULLET_COOLDOWN) {
            _bulletSpawnTimer -= BULLET_COOLDOWN;
            
            var angle:Float = FlxG.random.float(0,2*Math.PI);
            var DISTANCE_SPAWN_FROM_ENEMY:Float = 32.0;
			var BULLET_VELOCITY:Float = 300.0;
            var bullet:Bullet = new Bullet(x + DISTANCE_SPAWN_FROM_ENEMY * Math.cos(angle),
										   y + DISTANCE_SPAWN_FROM_ENEMY * Math.sin(angle),
										   Bullet.BulletType.REGULAR, Bullet.BulletOwner.ENEMY);
            bullet.velocity.set(BULLET_VELOCITY * Math.cos(angle), BULLET_VELOCITY * Math.sin(angle));
            _playState._bullets.push(bullet);
            _playState.add(bullet);
        }
		super._update(elapsed);
	}

    override public function move():Void {
        var ENEMY_VELOCITY:Float = 300.0;
    }
}