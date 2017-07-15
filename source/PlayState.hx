package;

import flash.Vector;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import openfl.Assets;
import openfl.display.BitmapData;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState {
	// these have underscores because VSCode can't refactor the names :(
	public var _player:Player;
	public var _bullets:Array<Bullet>;
	public var _enemies:Array<Enemy>;
	public var _powerups:Array<Powerup>;
	public var _powerupBombs:Array<PowerupBomb>;
	
	private var _mapSprite:FlxSprite;
	private var mapHandler:MapHandler;
	private var mapBitmapData:BitmapData;

    public var bulletReady = true;
	
	private var TILE_WIDTH:Int = 64;
	private var TILE_HEIGHT:Int = 64;

	override public function create():Void {
		_bullets = new Array <Bullet>();
		_enemies = new Array <Enemy>();
		_powerups = new Array <Powerup>();
		_powerupBombs = new Array <PowerupBomb>();
		
		mapHandler = new MapHandler();
		
		var mapSrcBitmapData:BitmapData = Assets.getBitmapData("assets/images/dungeon_tiles_packed.png");
		
		mapBitmapData = new BitmapData(mapHandler.MapWidth * TILE_WIDTH, mapHandler.MapHeight * TILE_HEIGHT, true, 0);
		for (y in 0...2*mapHandler.MapHeight) {
			for (x in 0...2 * mapHandler.MapWidth) {
				var tileCode:Int = 15;  // filled tile
				if (mapHandler.getHalfTileValOrSolid(x, y) == 0) {
					var occupiedNW:Int = mapHandler.getHalfTileValOrSolid(x - 1, y - 1);
					var occupiedNE:Int = mapHandler.getHalfTileValOrSolid(x + 1, y - 1);
					var occupiedSW:Int = mapHandler.getHalfTileValOrSolid(x - 1, y + 1);
					var occupiedSE:Int = mapHandler.getHalfTileValOrSolid(x + 1, y + 1);
					
					if (mapHandler.getHalfTileValOrSolid(x - 1, y) == 1) {
						occupiedNW = occupiedSW = 1;
					}
					if (mapHandler.getHalfTileValOrSolid(x + 1, y) == 1) {
						occupiedNE = occupiedSE = 1;
					}
					if (mapHandler.getHalfTileValOrSolid(x, y - 1) == 1) {
						occupiedNW = occupiedNE = 1;
					}
					if (mapHandler.getHalfTileValOrSolid(x, y + 1) == 1) {
						occupiedSW = occupiedSE = 1;
					}
					
					tileCode = occupiedNW + 2 * occupiedNE + 4 * occupiedSW + 8 * occupiedSE;
				}
				if (tileCode == 15 && mapHandler.getHalfTileValOrSolid(x, y - 1) == 0) {
					tileCode = 16;  // pillars below tiles
				}

				mapBitmapData.copyPixels(mapSrcBitmapData, new Rectangle(TILE_WIDTH / 2 * (tileCode % 8),
																		 TILE_HEIGHT / 2 * Std.int(tileCode / 8),
																		 TILE_WIDTH / 2, TILE_HEIGHT / 2),
										new Point(TILE_WIDTH / 2 * x, TILE_HEIGHT / 2 * y));
			}
		}
		
		_mapSprite = new FlxSprite();
		_mapSprite.loadGraphic(mapBitmapData);
		add(_mapSprite);
		
		_player = new Player(Main.GAME_WIDTH/2, Main.GAME_HEIGHT/2);
		add(_player);

        var enemySpawner = new FlxTimer().start(0.1, spawnEnemies, 0);
		super.create();
		//FlxG.log.warn(_player.characterSprite().getHitbox());
	}

    private function spawnEnemies(Timer:FlxTimer):Void {
        if(FlxG.random.int(0, 100) < Timer.elapsedLoops) {
            var randX = FlxG.random.int(30, Main.GAME_WIDTH-30);
            var randY = FlxG.random.int(30, Main.GAME_HEIGHT-30);
            var randomPoint = new FlxPoint(randX, randY);
            if(FlxMath.distanceToPoint(_player, randomPoint) > 50) {
                var enemy = new BoringEnemy(randX, randY, this);
                add(enemy);
                _enemies.push(enemy);
                Timer.reset(0.1);
            }
        }
    }

	public function resetLevel(player:Player, enemy:Enemy) {
		FlxG.switchState(new PlayState());
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		handlePlayerMovement();
        moveEnemies();
		updateAndHandleCollisions(elapsed);
		
        //FlxG.overlap(_player, _enemy, resetLevel);
		handleMousePress();

        if(FlxG.keys.justPressed.R) {
            FlxG.switchState(new PlayState());
        }
	}
	
	// ==============================================================================
	// Movement-related functions
	// ==============================================================================
	
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

        if (!bulletReady)
            speed = 120;
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
		for (enemy in _enemies) {
			enemy.move();
		}
    }
	
	// ==============================================================================
	// Bullet-related functions
	// ==============================================================================
	
	function handleMousePress():Void {
		if (FlxG.mouse.pressed && bulletReady) {
			var angle:Float = Math.atan2(FlxG.mouse.y - _player.y, FlxG.mouse.x - _player.x);
			
			if (_player.powerupType != Powerup.PowerupType.LIGHTNING) {
				bulletReady = false;
				var bulletTimer = new FlxTimer().start(0.1, reload, 1);
				var DISTANCE_SPAWN_FROM_PLAYER:Float = 32.0;
				var BULLET_VELOCITY:Float = 300.0;
				
				var bullet:Bullet = new Bullet(_player.x + DISTANCE_SPAWN_FROM_PLAYER * Math.cos(angle),
											   _player.y + DISTANCE_SPAWN_FROM_PLAYER * Math.sin(angle),
											   Bullet.BulletType.REGULAR, Bullet.BulletOwner.PLAYER);
				
				bullet.velocity.set(BULLET_VELOCITY * Math.cos(angle), BULLET_VELOCITY * Math.sin(angle));
				
				_bullets.push(bullet);
				add(bullet);
			} else {
				if (_enemies.length > 0) {
					var bestEnemy:Enemy = null;
					var bestDistance:Int = 220;
					for (enemy in _enemies) {
						var enemyAngle:Float = Math.atan2(enemy.y - _player.y, enemy.x - _player.x);
						var angleCutoff:Float = 0.3;
						var angleWithinRange:Bool = (Math.abs(enemyAngle - angle) < angleCutoff ||
													 2 * Math.PI - Math.abs(enemyAngle - angle) < angleCutoff);
						
						if (angleWithinRange && FlxMath.isDistanceWithin(enemy, _player, bestDistance)) {
							bestEnemy = enemy;
							bestDistance = FlxMath.distanceBetween(enemy, _player);
						}
					}
					if (bestEnemy != null) {
						var offsetX = (bestEnemy.x - _player.x < 0 ? _player.x - bestEnemy.x : 0);
						var offsetY = (bestEnemy.y - _player.y < 0 ? _player.y - bestEnemy.y : 0);
						var lightningFX:StaticFX = new StaticFX(_player.x - offsetX, _player.y - offsetY, 0.2);
						lightningFX.makeGraphic(bestDistance, bestDistance, FlxColor.TRANSPARENT);
						lightningFX.drawLine(offsetX, offsetY, bestEnemy.x - _player.x + offsetX, bestEnemy.y - _player.y + offsetY,
							{"color": FlxColor.YELLOW, "thickness": 3 } );
						add(lightningFX);
						
						damageEnemy(bestEnemy, 1);
					}
				}
			}
		}
	}

    private function reload(Timer:FlxTimer):Void {
        bulletReady = true;
    }
	
	function damageEnemy(enemy:Enemy, amt:Int):Void {
		enemy.currentHealth -= amt;
		
		if (enemy.currentHealth <= 0) {			
			enemy.destroy();
			_enemies.remove(enemy);

            if(FlxG.random.float(0,1) < 0.5) {
                haxe.Timer.delay(spawnPowerup.bind(enemy.x,enemy.y),500);
            }

		}
	}

    private function spawnPowerup(x,y):Void {
        var powerup:Powerup = new Powerup(x, y, Powerup.getRandomType());
		_powerups.push(powerup);
		add(powerup);
    }
	
	function checkBulletCollisions():Void {
		var i:Int = 0;
		while (i < _bullets.length) {
			var bullet:Bullet = _bullets[i];
			
			if (bullet.owner == Bullet.BulletOwner.ENEMY) {
				// collision with player?
				if (overlap(bullet, _player.characterSprite())) {
					_player.currentHealth -= 1;
					if (_player.currentHealth <= 0) {
						//TODO: figure out what happens when the player dies
					}
					bullet.destroy();
					_bullets.splice(i, 1);
					continue;
				}
			}
			else if (bullet.owner == Bullet.BulletOwner.PLAYER) {
				// collision with an enemy?
				var collisionFound:Bool = false;
				for (j in 0..._enemies.length) {
					var enemy:Enemy = _enemies[j];
					if (overlap(bullet, enemy.characterSprite())) {
						bullet.destroy();
						_bullets.splice(i, 1);
						
						damageEnemy(enemy, 1);
							
						collisionFound = true;
						break;
					}
				}
				if (collisionFound) {
					continue;
				}
				
				for (j in 0..._powerups.length) {
					var powerup:Powerup = _powerups[j];
					if (overlap(bullet, powerup)) {
						bullet.destroy();
						_bullets.splice(i, 1);
						
						var powerupBomb:PowerupBomb = new PowerupBomb(powerup.x, powerup.y, powerup.getType());
						powerup.destroy();
						_powerups.splice(j, 1);
						
						add(powerupBomb);
						_powerupBombs.push(powerupBomb);
						
						collisionFound = true;
						break;
					}
				}
				if (collisionFound) {
					continue;
				}
				
				for (j in 0..._powerupBombs.length) {
					var bomb:PowerupBomb = _powerupBombs[j];
					var ACCELERATE_AMT_WHEN_HIT:Float = 0.6;
					
					if (overlap(bullet, bomb)) {
						
						if (bomb.isLit()) {
							bomb.addToTickDuration(ACCELERATE_AMT_WHEN_HIT);
						} else {
							bomb.light();
						}
						var newVelocity = bomb.velocity.addPoint(bullet.velocity.scale(0.5));
						bomb.velocity.set(newVelocity.x, newVelocity.y);
						
						bullet.destroy();
						_bullets.splice(i, 1);
						
						collisionFound = true;
						break;
					}
				}
				if (collisionFound) {
					continue;
				}
			}
			++i;
		}
	}
	
	// ==============================================================================
	// Powerup-related functions
	// ==============================================================================
	
	function checkPowerupCollisions():Void {
		var i:Int = 0;
		while (i < _powerups.length) {
			var powerup:Powerup = _powerups[i];
			
			if (overlap(powerup, _player.characterSprite())) {
				_player.drawCharacterSprite(Powerup.getColorOfType(powerup.getType()));
				_player.powerupType = powerup.getType();
				
				powerup.destroy();
				_powerups.splice(i, 1);
				continue;
			}
			++i;
		}
	}
	
	// ==============================================================================
	
	function updateAndHandleCollisions(elapsed:Float):Void {
		_player._update(elapsed);
		var i:Int = 0;
		while (i < _bullets.length) {
			var bullet = _bullets[i];
			bullet._update(elapsed);
			if (bullet.x < -100 || bullet.x > Main.GAME_WIDTH + 100 ||
				bullet.y < -100 || bullet.y > Main.GAME_HEIGHT + 100) {
				bullet.destroy();
				_bullets.splice(i, 1);
				continue;
			}
			++i;
		}
		checkBulletCollisions();
		checkPowerupCollisions();
		for (enemy in _enemies) {
			enemy._update(elapsed);
		}
		for (bomb in _powerupBombs) {
			bomb._update(elapsed);
			if (bomb.isExploding()) {
				bomb.destroy();
				_powerupBombs.remove(bomb);
			}
		}
	}
	
	function overlap(obj1:FlxObject, obj2:FlxObject):Bool {
		var hitbox1 = obj1.getHitbox();
		var hitbox2 = obj2.getHitbox();
		
		return 	hitbox1.x + hitbox1.width >= hitbox2.x &&
				hitbox2.x + hitbox2.width >= hitbox1.x &&
				hitbox1.y + hitbox1.height >= hitbox2.y &&
				hitbox2.y + hitbox2.height >= hitbox1.y;
	}
}
