package;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;
import openfl.display.BitmapData;
import flixel.system.FlxSound;

using flixel.util.FlxSpriteUtil;
using Powerup.PowerupType;

class PowerupBomb extends FlxSpriteGroup {
	public static var PARALYZE_DURATION:Float = 4.0;
	
	private var _playState:PlayState;

	public var bombSprite:FlxSprite;
	private var bombOutlineSprite:FlxSprite;
	private var bombFuseSprite:FlxSprite = null;
	private var explosionEmitter:FlxEmitter;
	
	private var SPRITE_WIDTH:Int = 40;
	private var SPRITE_HEIGHT:Int = 40;
	private var FUSE_WIDTH:Int = 60;
	private var FUSE_HEIGHT:Int = 20;
	
	private var _bombState:Int = 0;  // unlit
	public var tickDuration:Float = 1;
	private var radius:Float;

    private var _explosionSound:FlxSound;
    private var _tickSound:FlxSound;
	
	private var _type:PowerupType;
    public function new(?X:Float=0, ?Y:Float=0, type:PowerupType, ?playState:PlayState) {
        super(X, Y);
		_type = type;
		_playState = playState;
		radius = 250;
        _explosionSound = FlxG.sound.load(AssetPaths.explosion__wav);
        _tickSound = FlxG.sound.load(AssetPaths.bombTicking__wav);
		if (type == PowerupType.LIGHTNING) {
			radius = 380;
		}
		
		var bombBitmapData:BitmapData = Assets.getBitmapData("assets/images/bomb.png");
		
		var bombInteriorBitmapData:BitmapData = new BitmapData(SPRITE_WIDTH, SPRITE_HEIGHT);
		bombInteriorBitmapData.copyPixels(
			bombBitmapData, new Rectangle(SPRITE_WIDTH, 0, SPRITE_WIDTH, SPRITE_HEIGHT), new Point(0, 0));
		var desiredColor:FlxColor = Powerup.getColorOfType(type);
		bombInteriorBitmapData.colorTransform(
			bombInteriorBitmapData.rect,
			new ColorTransform(1, 1, 1, 1,
							   desiredColor.red * 7/10, desiredColor.green * 7/10, desiredColor.blue * 7/10));
			
		var bombOutlineBitmapData:BitmapData = new BitmapData(SPRITE_WIDTH, 40);
		bombOutlineBitmapData.copyPixels(
			bombBitmapData, new Rectangle(0, 0, SPRITE_WIDTH, SPRITE_HEIGHT), new Point(0, 0));
			
		bombSprite = new FlxSprite();
		bombSprite.loadGraphic(bombInteriorBitmapData);
		bombSprite.x = -SPRITE_WIDTH / 2;
		bombSprite.y = -SPRITE_HEIGHT / 2;
		
		bombOutlineSprite = new FlxSprite();
		bombOutlineSprite.loadGraphic(bombOutlineBitmapData);
		bombOutlineSprite.x = -SPRITE_WIDTH / 2;
		bombOutlineSprite.y = -SPRITE_HEIGHT / 2;
		
		add(bombSprite);
		add(bombOutlineSprite);
		makeBombFuseSprite();
    }
	public function getType():PowerupType {
		return _type;
	}
	
	public function isLit():Bool {
		return _bombState != 0;
	}
	
	public function light():Void {
		_bombState = 1;
		makeBombFuseSprite();
		_tickSound.play(true, 0.7);
	}
	
	public function isExploding():Bool {
		return _bombState == 4;
	}
	
	public function processExplosion(timer:FlxTimer):Void {
        _explosionSound.play();
		_playState.removeBullets(bombSprite.x, bombSprite.y, radius);
		_playState.chainExplosions(bombSprite.x, bombSprite.y, radius);
		if (_type == PowerupType.METAL) {
			_playState.removePillars(bombSprite.x, bombSprite.y, radius);
		}
		for (enemy in _playState._enemies) {
			var distance:Float = (enemy.x - bombSprite.x)*(enemy.x - bombSprite.x) +
							   (enemy.y - bombSprite.y)*(enemy.y - bombSprite.y);
			if (distance < radius * radius) {
				_playState._gameState.score += 10;
				var damageAmount:Int = 30;
				if (_type == PowerupType.LIGHTNING) {
					damageAmount = 4;
					enemy.paralyze(PARALYZE_DURATION);
				} else if (_type == PowerupType.METAL) {
					damageAmount = 6;
				}
				_playState.damageEnemy(enemy, damageAmount, true);
			}
		}
	}
	public function explode():Void {
		var explosionFX:ExplosionFX = new ExplosionFX(bombSprite.x, bombSprite.y, radius, Powerup.getColorOfType(_type));
		_playState.add(explosionFX);
		
		new FlxTimer().start(0.2, processExplosion, 1);
	}
	
	public function addToTickDuration(amt:Float):Void {
		tickDuration += amt;
	}
	
	private function makeBombFuseSprite() {
		if (bombFuseSprite != null) {
			bombFuseSprite.destroy();
		}
		var bombFuseSrcBitmapData:BitmapData = Assets.getBitmapData("assets/images/bomb_fuse.png");
		
		var bombFuseBitmapData:BitmapData = new BitmapData(FUSE_WIDTH, FUSE_HEIGHT);
			bombFuseBitmapData.copyPixels(
				bombFuseSrcBitmapData, new Rectangle(0, FUSE_HEIGHT * _bombState, FUSE_WIDTH, FUSE_HEIGHT), new Point(0, 0));
		bombFuseSprite = new FlxSprite();
		bombFuseSprite.loadGraphic(bombFuseBitmapData);
		bombFuseSprite.x = -40;
		bombFuseSprite.y = -26;
		add(bombFuseSprite);
	}
	
	override public function getHitbox(?rect:FlxRect):FlxRect {
		return bombSprite.getHitbox();
	}
	
	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
		if (_bombState > 0) {
			tickDuration += 1.0 * elapsed;
			var newState:Int = Std.int(tickDuration);
			if (newState > _bombState) {
				if (newState >= 4) {
					_bombState = newState = 4;  // just in case!
					explode();
				} else {
					_tickSound.play(true, 0.7);
					_bombState = newState;
					makeBombFuseSprite();
				}
			}
		}
		super.update(elapsed);
	}
}