package;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class TankEnemy extends Enemy {
    private var _bulletSpawnTimer:Float;
    private static var BULLET_COOLDOWN:Float = 2.0;

    public function new(?X:Float=0, ?Y:Float=0, ?playState:PlayState) {
        super(X, Y, FlxColor.GREEN, 20, playState);
        _bulletSpawnTimer = 0;
        enemyType = "tank";
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
        var ENEMY_VELOCITY:Float = 10.0;
		var angle:Float = Math.atan2(_playState._player.y - y, _playState._player.x - x);
		velocity.set(ENEMY_VELOCITY * Math.cos(angle), ENEMY_VELOCITY * Math.sin(angle));
    }
}