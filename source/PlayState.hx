package;

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

	override public function create():Void {
		_player = new Player(10, 10);
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
	}
	
	function handlePlayerMovement():Void {
        var _up:Bool = false;
        var _down:Bool = false;
        var _left:Bool = false;
        var _right:Bool = false;
		var speed;

        _up = FlxG.keys.anyPressed([UP]);
        _down = FlxG.keys.anyPressed([DOWN]);
        _left = FlxG.keys.anyPressed([LEFT]);
        _right = FlxG.keys.anyPressed([RIGHT]);

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
}
