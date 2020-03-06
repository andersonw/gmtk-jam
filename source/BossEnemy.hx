package;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

class BossEnemy extends Enemy {
    private var _bulletSpawnTimer:Float;
    private static var BULLET_COOLDOWN:Float = 0.15;
    private static var CHASE_DISTANCE:Float = 9999.0; // distance at which it will start chasing the player
    private static var STOP_CHASE_DISTANCE:Float = 99999.0; // distance at which it stops chasing the player
    private var _bulletSound:FlxSound;

    public function new(?X:Float=0, ?Y:Float=0, ?playState:PlayState) {
        super(X, Y, FlxColor.BLACK, 300, playState);
        _bulletSpawnTimer = 0;
        enemyType = "boss";
        _bulletSound = FlxG.sound.load(AssetPaths.enemy_bullet__wav);
    }
    override public function update(elapsed:Float):Void {
	}
	override public function _update(elapsed:Float):Void {
        if (_state == Enemy.EnemyState.CHASING) {
            _bulletSpawnTimer += elapsed;
            if (_bulletSpawnTimer > BULLET_COOLDOWN) {
                _bulletSpawnTimer -= BULLET_COOLDOWN + FlxG.random.float(-0.15,0.15);
                
                var angle:Float = Math.atan2(_playState._player.y - y, _playState._player.x - x) + FlxG.random.float(-1,1);
                var DISTANCE_SPAWN_FROM_ENEMY:Float = 32.0;
                var BULLET_VELOCITY:Float = 100.0;
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
        var playerDistance:Float = (this.x - _playState._player.x)*(this.x - _playState._player.x) +
                                   (this.y - _playState._player.y)*(this.y - _playState._player.y);

        if (_state == Enemy.EnemyState.IDLE) {
            if (playerDistance < CHASE_DISTANCE * CHASE_DISTANCE) {
                _state = Enemy.EnemyState.CHASING;
            }
        }
        else if (_state == Enemy.EnemyState.CHASING) {
            var ENEMY_VELOCITY:Float = 60.0;
            var angle:Float = Math.atan2(_playState._player.y - y, _playState._player.x - x);
            velocity.set(ENEMY_VELOCITY * Math.cos(angle), ENEMY_VELOCITY * Math.sin(angle));

            if (playerDistance > STOP_CHASE_DISTANCE * STOP_CHASE_DISTANCE) {
                _state = Enemy.EnemyState.IDLE;
            }
        }
    }
}
