package;

import flash.Vector;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;

class PlayState extends FlxState {
	private var _player:Player;
    private var _enemy:Enemy;
	private var _bullets:Array<Bullet>;

	override public function create():Void {
		_bullets = new Array <Bullet>();
		
		_player = new Player(25, 25);
		add(_player);

        _enemy = new Enemy(300, 300);
        add(_enemy);
		super.create();
	}

	public function resetLevel(player:Player, enemy:Enemy)
	{
		FlxG.switchState(new PlayState());
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		handlePlayerMovement();
        moveEnemies();
        FlxG.overlap(_player, _enemy, resetLevel);
		handleMousePress();
	}
	
	function handlePlayerMovement():Void {
        var _up:Bool = false;
        var _down:Bool = false;
        var _left:Bool = false;
        var _right:Bool = false;
		var speed;

        _up = FlxG.keys.anyPressed([UP, W]);
        _down = FlxG.keys.anyPressed([DOWN, S]);
        _left = FlxG.keys.anyPressed([LEFT, A]);
        _right = FlxG.keys.anyPressed([RIGHT, D]);

        if (FlxG.keys.anyPressed([SHIFT]))
            speed = 50;
        else
            speed = 200;

        if (_up && _down)
            _up = _down = false;
        if (_left && _right)
            _left = _right = false;

        if (_up || _down || _left || _right) {
            var mA:Float = 0;
            if (_up) {
                mA = -90;
                if (_left) {
                    mA -= 45;
                } else if(_right) {
                    mA += 45;
                }
            } else if (_down) {
                mA = 90;
                if (_left) {
                    mA += 45;
                } else if (_right) {
                    mA -= 45;
                }
            } else if (_left) {
                mA = 180;
            } else if (_right) {
                mA = 0;
            }
            _player.velocity.set(speed, 0);
            _player.velocity.rotate(FlxPoint.weak(0,0), mA);
        }
        else {
            _player.velocity.set(0, 0);
        }
    }

    function moveEnemies():Void {
        _enemy.velocity.set(30,0);
        _enemy.velocity.rotate(FlxPoint.weak(0,0), (Math.random() * 360));
    }
	
	function handleMousePress():Void {
		if (FlxG.mouse.justPressed) {
			var DISTANCE_SPAWN_FROM_PLAYER:Float = 15.0;
			var BULLET_VELOCITY:Float = 300.0;
			
			var angle:Float = Math.atan2(FlxG.mouse.y - _player.y, FlxG.mouse.x - _player.x);
			
			var bullet:Bullet = new Bullet(_player.x + DISTANCE_SPAWN_FROM_PLAYER * Math.cos(angle),
										   _player.y + DISTANCE_SPAWN_FROM_PLAYER * Math.sin(angle));
			
			bullet.velocity.set(BULLET_VELOCITY * Math.cos(angle), BULLET_VELOCITY * Math.sin(angle));
			
			_bullets.push(bullet);
			add(bullet);
		}
	}
}
