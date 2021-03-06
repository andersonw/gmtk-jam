package;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.system.FlxSound;

class TankEnemy extends Enemy {
    private var _bulletSpawnTimer:Float;
    private static var BULLET_COOLDOWN:Float = 2.0;
    private var _bulletSound:FlxSound;

    private static var CHASE_DISTANCE:Float = 450.0; // distance at which it will start chasing the player
    private static var STOP_CHASE_DISTANCE:Float = 750.0; // distance at which it stops chasing the player
    
    public function new(?X:Float=0, ?Y:Float=0, ?playState:PlayState) {
        super(X, Y, FlxColor.GREEN, 40, playState);
        _bulletSpawnTimer = 0;
        enemyType = "tank";
        _bulletSound = FlxG.sound.load(AssetPaths.enemy_bullet__wav);
    }
    override public function update(elapsed:Float):Void {
	}
	override public function _update(elapsed:Float):Void {
        _bulletSpawnTimer += elapsed;
        if (_bulletSpawnTimer > BULLET_COOLDOWN) {
            _bulletSpawnTimer -= BULLET_COOLDOWN + FlxG.random.float(-1,1);
            for (i in 0...10) {
                var angle:Float = Math.atan2(_playState._player.y - y, _playState._player.x - x) + FlxG.random.float(-0.5,0.5);
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
/*
    override public function drawHealthbarSprite() {
        _healthbarSprite = new FlxSprite();
        _healthbarSprite.makeGraphic(32, 10, FlxColor.RED);
        _healthbarSprite.x = _characterSprite.x - this.x;
        _healthbarSprite.y = _characterSprite.y - this.y + 72;
        add(_healthbarSprite);
    }

    override public function drawCharacterSprite(color:FlxColor) {
		_characterSprite = new FlxSprite();
        _characterSprite.makeGraphic(64, 64, color, true);
		_characterSprite.x = _characterSprite.y = -16;
		add(_characterSprite);
	}
*/
    override public function move():Void {
        var playerDistance:Float = (this.x - _playState._player.x)*(this.x - _playState._player.x) +
                                   (this.y - _playState._player.y)*(this.y - _playState._player.y);

        if (_state == Enemy.EnemyState.IDLE) {
            if (playerDistance < CHASE_DISTANCE * CHASE_DISTANCE) {
                _state = Enemy.EnemyState.CHASING;
            }
        }
        else if (_state == Enemy.EnemyState.CHASING) {
            var ENEMY_VELOCITY:Float = 10.0;
            var angle:Float = Math.atan2(_playState._player.y - y, _playState._player.x - x);
            velocity.set(ENEMY_VELOCITY * Math.cos(angle), ENEMY_VELOCITY * Math.sin(angle));

            if (playerDistance > STOP_CHASE_DISTANCE * STOP_CHASE_DISTANCE) {
                _state = Enemy.EnemyState.IDLE;
            }
        }
    }
}