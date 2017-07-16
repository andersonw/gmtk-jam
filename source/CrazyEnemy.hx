package;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

class CrazyEnemy extends Enemy {
    private var _bulletSpawnTimer:Float;
    private static var BULLET_COOLDOWN:Float = 0.6;
    private var _bulletSound:FlxSound;

    private static var SHOOT_DISTANCE:Float = 650.0;

    public function new(?X:Float=0, ?Y:Float=0, ?playState:PlayState) {
        super(X, Y, FlxColor.RED, 5, playState);
        _bulletSpawnTimer = 0;
        enemyType = "crazy";
        _bulletSound = FlxG.sound.load(AssetPaths.enemy_bullet__wav);
    }
    override public function update(elapsed:Float):Void {
	}
	override public function _update(elapsed:Float):Void {
        var playerDistance:Float = (this.x - _playState._player.x)*(this.x - _playState._player.x) +
                                   (this.y - _playState._player.y)*(this.y - _playState._player.y);
        if (playerDistance < SHOOT_DISTANCE * SHOOT_DISTANCE) {
            _bulletSpawnTimer += elapsed;
            if (_bulletSpawnTimer > BULLET_COOLDOWN) {
                _bulletSpawnTimer -= BULLET_COOLDOWN;
                
                var angle:Float = FlxG.random.float(0,2*Math.PI);
                var DISTANCE_SPAWN_FROM_ENEMY:Float = 32.0;
                var BULLET_VELOCITY:Float = 70.0;
                var bullet:Bullet = new Bullet(x + DISTANCE_SPAWN_FROM_ENEMY * Math.cos(angle),
                                            y + DISTANCE_SPAWN_FROM_ENEMY * Math.sin(angle),
                                            Bullet.BulletType.REGULAR, Bullet.BulletOwner.ENEMY);
                bullet.velocity.set(BULLET_VELOCITY * Math.cos(angle), BULLET_VELOCITY * Math.sin(angle));
                _playState._bullets.push(bullet);
                _playState.bulletLayer.add(bullet);
                _bulletSound.play();
            }
        }
		super._update(elapsed);
	}

    override public function move():Void {
        var ENEMY_VELOCITY:Float = 300.0;
        velocity.set(ENEMY_VELOCITY,0);
		velocity.rotate(FlxPoint.weak(0, 0), (Math.random() * 360));
    }
}