package;

import flash.Vector;
import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Timer;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileSquare;
import flixel.addons.transition.TransitionData;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
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

class PlayState extends FlxTransitionableState {

	public var backgroundLayer:FlxSpriteGroup;
	public var bulletLayer:FlxSpriteGroup;
	public var enemyLayer:FlxSpriteGroup;
	public var healthbarLayer:FlxSpriteGroup;
	
	// these have underscores because VSCode can't refactor the names :(
	public var _player:Player;
	public var _bullets:Array<Bullet>;
	public var _enemies:Array<Enemy>;
	public var _powerups:Array<Powerup>;
	public var _powerupBombs:Array<PowerupBomb>;
	public var _camera:FlxCamera;
    public var _gameState:GameState;
	
	private var _mapPillars:Array<FlxSprite>;
	private var _mapPillarBGs:Array<FlxSprite>;
	private var _mapSprite:FlxSprite;
	private var mapHandler:MapHandler;
	private var mapBitmapData:BitmapData;
	public var levelHUD:LevelHUD;

    public var bulletReady:Bool = true;
	public var lockPlayerControls:Bool = false;
	public var ignorePlayerWallCollision:Bool = false;

    private var _bulletSound:FlxSound;
    private var _flameSound:FlxSound;
    private var _shotgunSound:FlxSound;
    private var _lightningSound:FlxSound;
    private var _bulletHitSound:FlxSound;
    private var _powerupSound:FlxSound;
    private var _levelCompleteSound:FlxSound;
	
	private var TILE_WIDTH:Int = 64;
	private var TILE_HEIGHT:Int = 64;
	
	private function getRectByTileCode(code:Int) {
		return new Rectangle(TILE_WIDTH / 2 * (code % 8),
							 TILE_HEIGHT / 2 * Std.int(code / 8),
							 TILE_WIDTH / 2, TILE_HEIGHT / 2);
	}

	override public function create():Void {
		backgroundLayer = new FlxSpriteGroup();
		bulletLayer = new FlxSpriteGroup();
		enemyLayer = new FlxSpriteGroup();
		healthbarLayer = new FlxSpriteGroup();
		
		_bullets = new Array <Bullet>();
		_enemies = new Array <Enemy>();
		_powerups = new Array <Powerup>();
		_powerupBombs = new Array <PowerupBomb>();
		_camera = new FlxCamera();
        _gameState = Main.gameState;
		_gameState.initNewLevel();
		
		mapHandler = new MapHandler();
		_mapPillars = new Array<FlxSprite>();
		_mapPillarBGs = new Array<FlxSprite>();
		
		FlxG.sound.playMusic(AssetPaths.silly_song3__wav);

        _bulletSound = FlxG.sound.load(AssetPaths.generic_bullet__wav);
        _flameSound = FlxG.sound.load(AssetPaths.flamethrower__wav);
        _shotgunSound = FlxG.sound.load(AssetPaths.shotgun__wav);
        _lightningSound = FlxG.sound.load(AssetPaths.lightning__wav);
        _bulletHitSound = FlxG.sound.load(AssetPaths.bullet_impact__wav);
        _powerupSound = FlxG.sound.load(AssetPaths.powerup__wav);
        _levelCompleteSound = FlxG.sound.load(AssetPaths.levelComplete__wav);
		
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
					
					tileCode =  (occupiedNW == 1 ? 1 : 0) +
							2 * (occupiedNE == 1 ? 1 : 0) +
							4 * (occupiedSW == 1 ? 1 : 0) +
							8 * (occupiedSE == 1 ? 1 : 0);
				}
				if (tileCode == 15 && mapHandler.getHalfTileValOrSolid(x, y - 1) != 1) {
					tileCode = 16;  // pillars below tiles
				}

				mapBitmapData.copyPixels(mapSrcBitmapData, getRectByTileCode(tileCode),
										new Point(TILE_WIDTH / 2 * x, TILE_HEIGHT / 2 * y));
				
				if ((x % 2 == 0) && (y % 2 == 0) && mapHandler.getHalfTileValOrSolid(x, y) == 2) {
					var pillarSpriteData:BitmapData = new BitmapData(TILE_WIDTH, 2 * TILE_HEIGHT, true, 0);
					var pillarBGSpriteData:BitmapData = new BitmapData(TILE_WIDTH, 2 * TILE_HEIGHT, true, 0);
					var pillar:FlxSprite = new FlxSprite();
					var pillarBG:FlxSprite = new FlxSprite();
					
					var pillarTiles:Array<Int> = [ 7, 11, 13, 14, 17, 17, 16, 16 ];
					
					if (mapHandler.getHalfTileValOrSolid(x + 2, y) == 2) {
						pillarTiles[1] -= 8;
						pillarTiles[3] -= 2;
					}
					if (mapHandler.getHalfTileValOrSolid(x - 2, y) == 2) {
						pillarTiles[0] -= 4;
						pillarTiles[2] -= 1;
					}
					if (mapHandler.getHalfTileValOrSolid(x, y - 2) == 2) {
						pillarTiles[0] -= 2;
						pillarTiles[1] -= 1;
					}
					if (mapHandler.getHalfTileValOrSolid(x, y + 2) == 2) {
						pillarTiles[2] -= 8;
						pillarTiles[3] -= 4;
					}
					
					for (i in 0...8) {
						if (i < 6 || mapHandler.getHalfTileValOrSolid(x, y) == 1) {
							tileCode = pillarTiles[i];
							var dataToCopyTo = pillarSpriteData;
							if (i >= 2) {
								dataToCopyTo = pillarBGSpriteData;
							}
							dataToCopyTo.copyPixels(mapSrcBitmapData, getRectByTileCode(tileCode),
													new Point(TILE_WIDTH / 2 * (i % 2), TILE_HEIGHT / 2 * Std.int(i / 2)));
						}
					}
					pillarSpriteData.colorTransform(pillarSpriteData.rect, new ColorTransform(0.6, 0.6, 0.6, 1));
					pillarBGSpriteData.colorTransform(pillarSpriteData.rect, new ColorTransform(0.6, 0.6, 0.6, 1));
					pillar.loadGraphic(pillarSpriteData);
					pillarBG.loadGraphic(pillarBGSpriteData);
					pillar.x = pillarBG.x = x * TILE_WIDTH / 2;
					pillar.y = pillarBG.y = y * TILE_HEIGHT / 2 - 32;
					_mapPillars.push(pillar);
					_mapPillarBGs.push(pillarBG);
				}
			}
		}
		
		_mapSprite = new FlxSprite();
		_mapSprite.loadGraphic(mapBitmapData);
		add(_mapSprite);
		
		add(backgroundLayer);
		add(bulletLayer);

		for (pillar in _mapPillarBGs) {
			add(pillar);
		}
		// The pillars are added in this order because isometric projections are hard :(
		add(enemyLayer);
		
		var randomFreePosition = mapHandler.getRandomPathableSquare();
        var randX = TILE_WIDTH * (randomFreePosition % MapHandler.LEVEL_WIDTH) + TILE_WIDTH / 2;
        var randY = TILE_HEIGHT * Std.int(randomFreePosition / MapHandler.LEVEL_WIDTH) + TILE_HEIGHT / 2;
		_player = new Player(randX, randY, this);
		add(_player._characterSprite);
		handleScrolls();
			
		_player.drawCharacterSprite(Powerup.getColorOfType(Powerup.PowerupType.FIRE));
		_player.powerupType = Powerup.PowerupType.FIRE;

		for (pillar in _mapPillars) {
			add(pillar);
		}

		add(healthbarLayer);
		add(_player._healthbarSprite);

		levelHUD = new LevelHUD(0, Main.GAME_HEIGHT - 120, this);
		levelHUD.scrollFactor.set(0, 0);

		add(levelHUD);
		
        var enemySpawner = new FlxTimer().start(_gameState.randomEnemySpawnrate[_gameState.level], spawnRandomEnemies, 0);
        spawnLevelEnemies();
		super.create();
		
		// initialize transitions
		FlxTransitionableState.defaultTransIn = new TransitionData();
		FlxTransitionableState.defaultTransOut = new TransitionData();
		
		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;
		
		FlxTransitionableState.defaultTransIn.color = FlxColor.BLACK;
		FlxTransitionableState.defaultTransOut.color = FlxColor.BLACK;
		FlxTransitionableState.defaultTransIn.type = flixel.addons.transition.TransitionType.TILES;
		FlxTransitionableState.defaultTransOut.type = flixel.addons.transition.TransitionType.TILES;
		FlxTransitionableState.defaultTransIn.tileData = { asset: diamond, width: 32, height: 32 };
		FlxTransitionableState.defaultTransOut.tileData = { asset: diamond, width: 32, height: 32 };
		transOut = FlxTransitionableState.defaultTransOut;
	}

    private function spawnRandomEnemies(Timer:FlxTimer):Void {
        if (FlxG.random.int(0, 100) < Timer.elapsedLoops) {
			var randomFreePosition = mapHandler.getRandomPathableSquare();
            var randX = TILE_WIDTH * (randomFreePosition % MapHandler.LEVEL_WIDTH) + TILE_WIDTH / 2;
            var randY = TILE_HEIGHT * Std.int(randomFreePosition / MapHandler.LEVEL_WIDTH) + TILE_HEIGHT / 2;
            if(FlxMath.distanceToPoint(_player, new FlxPoint(randX, randY)) > 250) {
                var enemy:Enemy;
                var randomEnemy = FlxG.random.float(0, 1);
                if(randomEnemy < 0.2) {
                    enemy = new TankEnemy(randX, randY, this);
                }                
                else if(randomEnemy < 0.5) {
                    enemy = new CrazyEnemy(randX, randY, this);
                }
                else {
                    enemy = new BoringEnemy(randX, randY, this);
                }
                enemyLayer.add(enemy._characterSprite);
				healthbarLayer.add(enemy._healthbarSprite);
                _enemies.push(enemy);
                Timer.reset(0.1);
            }
        }
    }

    private function spawnLevelEnemies() {
        for(enemyType in _gameState.fixedEnemyTypes) {
            for(i in 0..._gameState.enemyCount[enemyType]) {
                var randX:Float;
                var randY:Float;
                var enemy:Enemy;
                do {
                    var randomFreePosition = mapHandler.getRandomPathableSquare();
                    randX = TILE_WIDTH * (randomFreePosition % MapHandler.LEVEL_WIDTH) + TILE_WIDTH / 2;
                    randY = TILE_HEIGHT * Std.int(randomFreePosition / MapHandler.LEVEL_WIDTH) + TILE_HEIGHT / 2;
                } while (FlxMath.distanceToPoint(_player, new FlxPoint(randX, randY)) < 250);
                switch(enemyType) {
                    case "boring": enemy = new BoringEnemy(randX, randY, this);
                    case "crazy": enemy = new CrazyEnemy(randX, randY, this);
                    case "tank": enemy = new TankEnemy(randX, randY, this);
                    default: enemy = new BoringEnemy(randX, randY, this);
                }
                enemyLayer.add(enemy);
                _enemies.push(enemy);
            }
        }
    }

	public function resetLevel() {
		FlxG.switchState(new PlayState());
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
		
		var playerSprite = _player.characterSprite();

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
				playerSprite.facing = FlxObject.UP;
            } else if (_down) {
                mA = 90;
                if (_left) {
                    mA += 45;
                } else if (_right) {
                    mA -= 45;
                }
				playerSprite.facing = FlxObject.DOWN;
            } else if (_left) {
                mA = 180;
				playerSprite.facing = FlxObject.LEFT;
            } else if (_right) {
                mA = 0;
				playerSprite.facing = FlxObject.RIGHT;
            }
            _player.velocity.set(speed, 0);
            _player.velocity.rotate(FlxPoint.weak(0, 0), mA);
			
			switch (playerSprite.facing) {
				case FlxObject.LEFT, FlxObject.RIGHT:
					playerSprite.animation.play("lr");
				case FlxObject.UP:
					playerSprite.animation.play("u");
				case FlxObject.DOWN:
					playerSprite.animation.play("d");
			}
        }
        else {
            _player.velocity.set(0, 0);
			playerSprite.animation.play("stand");
        }
    }

    function moveEnemies():Void {
		for (enemy in _enemies) {
			var enemySprite = enemy.characterSprite();
			enemy.move();
			
			if (Math.abs(enemy.velocity.x) >= Math.abs(enemy.velocity.y)) {
				if (enemy.velocity.x >= 0) {
					enemySprite.facing = FlxObject.RIGHT;
				} else {
					enemySprite.facing = FlxObject.LEFT;
				}
				enemySprite.animation.play("lr");
			} else {
				if (enemy.velocity.y >= 0) {
					enemySprite.facing = FlxObject.DOWN;
					enemySprite.animation.play("d");
				} else {
					enemySprite.facing = FlxObject.UP;
					enemySprite.animation.play("u");
				}
			}
		}
    }
	
	// ==============================================================================
	// Bullet-related functions
	// ==============================================================================
	
	function handleMousePress():Void {
		if (FlxG.mouse.pressed && bulletReady) {
			var angle:Float = Math.atan2(FlxG.mouse.y - _player.y, FlxG.mouse.x - _player.x);
			
			if (_player.powerupType == Powerup.PowerupType.NONE ||
				_player.powerupType == Powerup.PowerupType.ICE ||
				_player.powerupType == Powerup.PowerupType.LUGE) {
				bulletReady = false;
				var bulletTimer = new FlxTimer().start(0.3, reload, 1);
				var DISTANCE_SPAWN_FROM_PLAYER:Float = 32.0;
				var BULLET_VELOCITY:Float = 300.0;
				
				var bullet:Bullet = new Bullet(_player.x + DISTANCE_SPAWN_FROM_PLAYER * Math.cos(angle),
											   _player.y + DISTANCE_SPAWN_FROM_PLAYER * Math.sin(angle),
											   Bullet.BulletType.REGULAR, Bullet.BulletOwner.PLAYER);
				
				bullet.velocity.set(BULLET_VELOCITY * Math.cos(angle), BULLET_VELOCITY * Math.sin(angle));
				_bulletSound.play();
				_bullets.push(bullet);
				bulletLayer.add(bullet);
			} else if (_player.powerupType == Powerup.PowerupType.FIRE) {
				bulletReady = false;
				var bulletTimer = new FlxTimer().start(0.05, reload, 1);
				var DISTANCE_SPAWN_FROM_PLAYER:Float = 35.0;
				var BULLET_VELOCITY:Float = 520.0;
				var SMOKE_VELOCITY:Float = 270.0;
				var SMOKE_VELOCITY_VARIANCE:Float = 120.0;
				
				var realAngle:Float = angle + 0.4 * Math.random() - 0.2;
				var bullet:Bullet = new Bullet(_player.x + DISTANCE_SPAWN_FROM_PLAYER * Math.cos(realAngle),
											   _player.y + DISTANCE_SPAWN_FROM_PLAYER * Math.sin(realAngle),
											   Bullet.BulletType.FIRE, Bullet.BulletOwner.PLAYER);
				
				bullet.velocity.set(BULLET_VELOCITY * Math.cos(angle), BULLET_VELOCITY * Math.sin(angle));
                _flameSound.play();
				_bullets.push(bullet);
				bulletLayer.add(bullet);
				
				for (rep in 0...2) {
					var tweakedAngle:Float = angle + 0.5 * Math.random() - 0.25;
					var smokeBullet:Bullet = new Bullet(_player.x + DISTANCE_SPAWN_FROM_PLAYER * Math.cos(tweakedAngle),
														_player.y + DISTANCE_SPAWN_FROM_PLAYER * Math.sin(tweakedAngle),
														Bullet.BulletType.SMOKE, Bullet.BulletOwner.PLAYER);
					
					var smokeVelocityActual = SMOKE_VELOCITY + SMOKE_VELOCITY_VARIANCE * Math.random();
					smokeBullet.velocity.set(smokeVelocityActual * Math.cos(tweakedAngle),
											 smokeVelocityActual * Math.sin(tweakedAngle));
					_bullets.push(smokeBullet);
					backgroundLayer.add(smokeBullet);
				}
			} else if (_player.powerupType == Powerup.PowerupType.LIGHTNING) {
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
						bulletLayer.add(lightningFX);
						_lightningSound.play();
						damageEnemy(bestEnemy, 1);
					}
				}
			} else if (_player.powerupType == Powerup.PowerupType.METAL) {
				bulletReady = false;
				var knockbackDuration:Float = 0.2;
				var cooldownDuration:Float = 0.8;
				var bulletTimer = new FlxTimer().start(cooldownDuration, reload, 1);
				var DISTANCE_SPAWN_FROM_PLAYER:Float = 32.0;
				var BULLET_VELOCITY:Float = 180.0;
				var BULLET_VELOCITY_VARIANCE:Float = 280.0;
				
				for (rep in 0...11) {
					var tweakedAngle:Float = angle + 0.7 * Math.random() - 0.35;
					var ratio:Float = Math.random();
					var tweakedVelocity:Float = BULLET_VELOCITY + ratio * BULLET_VELOCITY_VARIANCE;
					
					var bullet:Bullet = new Bullet(_player.x + DISTANCE_SPAWN_FROM_PLAYER * Math.cos(tweakedAngle),
												   _player.y + DISTANCE_SPAWN_FROM_PLAYER * Math.sin(tweakedAngle),
												   Bullet.BulletType.REGULAR, Bullet.BulletOwner.PLAYER, 3 + Std.int(5 * ratio));
					bullet.velocity.set(tweakedVelocity * Math.cos(tweakedAngle), tweakedVelocity * Math.sin(tweakedAngle));
					
					_bullets.push(bullet);
					bulletLayer.add(bullet);
				}
                _shotgunSound.play();
				
				var velocityToTry:Float = 800.;
				_player.x -= velocityToTry * knockbackDuration * Math.cos(angle);
				_player.y -= velocityToTry * knockbackDuration * Math.sin(angle);
				
				// TODO: Make more sophisticated?
				_player.velocity.set( -velocityToTry * Math.cos(angle), -velocityToTry * Math.sin(angle));
				if (!hitTestWall(_player)) {
					ignorePlayerWallCollision = true;
				}
				_player.x += velocityToTry * knockbackDuration * Math.cos(angle);
				_player.y += velocityToTry * knockbackDuration * Math.sin(angle);
				
				lockPlayerControls = true;
				var lockTimer = new FlxTimer().start(knockbackDuration, function(timer:FlxTimer) { ignorePlayerWallCollision = false; lockPlayerControls = false; }, 1);
			}
		}
	}

    private function reload(Timer:FlxTimer):Void {
        bulletReady = true;
    }
	
	private function advanceLevel(timer:FlxTimer):Void {
		_gameState.level += 1;
        resetLevel();
	}
	
	public function damageEnemy(enemy:Enemy, amt:Int, ?immuneToBombs:Bool = false):Void {
		enemy.currentHealth -= amt;
		
		if (enemy.currentHealth <= 0) {
            _gameState.killedEnemyCount[enemy.getEnemyType()] += 1;
            levelHUD.updateText(_gameState.score,_gameState.level, _gameState.totalEnemiesLeft);
			enemy.destroy();
			_enemies.remove(enemy);
			_gameState.totalEnemiesLeft -= 1;
			_gameState.score += 20;
			
			if (_gameState.levelComplete()) {
				_player.invulnerable = true;
				lockPlayerControls = true;
				_player.velocity.set(0, 0);
				_player.characterSprite().animation.play("stand");
                _levelCompleteSound.play();
				
				for (i in 0...2) {
					var beatLevelEmitter = new FlxEmitter(_player.x - 8 + 14*i, _player.y - 60, 200);
					beatLevelEmitter.makeParticles(3, 3, FlxColor.WHITE, 200);
					beatLevelEmitter.color.set(FlxColor.GREEN, FlxColor.WHITE);
					beatLevelEmitter.launchMode = flixel.effects.particles.FlxEmitterMode.SQUARE;
					beatLevelEmitter.velocity.set(-100, -250, 100, -400);
					beatLevelEmitter.lifespan.set(0.15, 0.3);
					
					add(beatLevelEmitter);
					beatLevelEmitter.start(false, 0.01);
				}
				
				new FlxTimer().start(2, advanceLevel, 2);
            }

            if(FlxG.random.float(0,1) < 1) {
                spawnPowerup(enemy.x,enemy.y, immuneToBombs);
            }

		}
	}

    private function spawnPowerup(x,y, ?immuneToBombs:Bool = false):Void {
        var powerup:Powerup = new Powerup(x, y, Powerup.getRandomType(), this);
		_powerups.push(powerup);
		if (immuneToBombs) {
			powerup.setInvulnerableToBombs();
		}
		bulletLayer.add(powerup);
    }
	
	function checkBulletCollisions():Void {
		var i:Int = 0;
		while (i < _bullets.length) {
			var bullet:Bullet = _bullets[i];
			
			// collision with walls?
			var bulletTileX = Std.int(bullet.x / TILE_WIDTH);
			var bulletTileY = Std.int(bullet.y / TILE_HEIGHT);
			if (mapHandler.getVal(bulletTileX, bulletTileY) == 2) {
				bullet.destroy();
				_bullets.splice(i, 1);
				continue;
			}
			
			if (bullet.type == Bullet.BulletType.SMOKE) {
				++i;
				continue;
			}
			
			if (bullet.owner == Bullet.BulletOwner.ENEMY) {
				// check for collision with player
				if (overlapCenteredHitboxes(bullet, _player)) {
					if (!_player.invulnerable) {
						_bulletHitSound.play();
						_player.currentHealth -= 1;
						if (_player.currentHealth <= 0) {
							//TODO: figure out what happens when the player dies
						}
					}
					bullet.destroy();
					_bullets.splice(i, 1);
					continue;
				}
			}
			else if (bullet.owner == Bullet.BulletOwner.PLAYER) {
				// check for collision with an enemy
				var collisionFound:Bool = false;
				for (j in 0..._enemies.length) {
					var enemy:Enemy = _enemies[j];
					if (overlapCenteredHitboxes(bullet, enemy)) {
                        _bulletHitSound.play();
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
					if (overlap(bullet, powerup) && !powerup.isInvincible) {
						bullet.destroy();
						_bullets.splice(i, 1);
						
						var powerupBomb:PowerupBomb = new PowerupBomb(powerup.x, powerup.y, powerup.getType(), this);
						powerup.destroy();
						_powerups.splice(j, 1);
						
						bulletLayer.add(powerupBomb);
						_powerupBombs.push(powerupBomb);
						powerupBomb.light();
						
						collisionFound = true;
						break;
					}
				}
				if (collisionFound) {
					continue;
				}
				
				for (j in 0..._powerupBombs.length) {
					var bomb:PowerupBomb = _powerupBombs[j];
					var accelerateAmt = 0.5;
					if (bullet.type == Bullet.BulletType.FIRE) {
						accelerateAmt = 0.1;
					}
					
					if (overlap(bullet, bomb)) {
						
						if (bomb.isLit() && bomb.tickDuration < 3.2) {
							bomb.addToTickDuration(accelerateAmt / 2.0);
						} else {
							bomb.light();
						}
						var newVelocity = bomb.velocity.addPoint(bullet.velocity.scale(accelerateAmt));
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
			
			if (overlapCenteredHitboxes(powerup, _player)) {
				_player.drawCharacterSprite(Powerup.getColorOfType(powerup.getType()));
				_player.powerupType = powerup.getType();
				_player.timeUntilPowerupExpires = Powerup.getCooldownOfType(powerup.getType());
				levelHUD.updateCard(_player.powerupType);
				
				powerup.destroy();
				_powerups.splice(i, 1);
                _powerupSound.play();
				continue;
			}
			++i;
		}
	}
	
	public function removeBullets(srcX:Float, srcY:Float, radius:Float):Void {
		for (bullet in _bullets) {
			var distance:Float = (srcX - bullet.bulletSprite.x)*(srcX - bullet.bulletSprite.x) +
								 (srcY - bullet.bulletSprite.y) * (srcY - bullet.bulletSprite.y);
			
			if (distance < radius * radius && bullet.owner != Bullet.BulletOwner.PLAYER) {
				_bullets.remove(bullet);
				bullet.destroy();
				
				_gameState.score += 1;
			}
		}
	}
	
	public function chainExplosions(srcX:Float, srcY:Float, radius:Float):Void {
		for (bomb in _powerupBombs) {
			// Process bombs first, since powerups will turn into bombs and
			// would otherwise be double-counted.
			var distance:Float = (srcX - bomb.bombSprite.x)*(srcX - bomb.bombSprite.x) +
								(srcY - bomb.bombSprite.y)*(srcY - bomb.bombSprite.y);
			if (distance < radius * radius) {
				bomb.addToTickDuration(3.0);
			}
		}
		
		for (powerup in _powerups) {
			var distance:Float = (srcX - powerup.bombSprite.x)*(srcX - powerup.bombSprite.x) +
								(srcY - powerup.bombSprite.y)*(srcY - powerup.bombSprite.y);
			if (distance < radius * radius && !powerup.isInvincibleToBombs) {
				var powerupBomb:PowerupBomb = new PowerupBomb(powerup.x, powerup.y, powerup.getType(), this);
				
				powerup.destroy();
				_powerups.remove(powerup);
						
				bulletLayer.add(powerupBomb);
				_powerupBombs.push(powerupBomb);
				powerupBomb.light();
				powerupBomb.addToTickDuration(1.3);
			}
		}
	}
	
	// ==============================================================================
	// Core update logic
	// ==============================================================================
	
	function updateAndHandleCollisions(elapsed:Float):Void {
		_player._update(elapsed);
		if (!ignorePlayerWallCollision) {
			snapObjectToTiles(_player, elapsed);
		}
		var i:Int = 0;
		while (i < _bullets.length) {
			var bullet = _bullets[i];
			bullet._update(elapsed);
			if (bullet.shouldDelete()) {
				bullet.destroy();
				_bullets.splice(i, 1);
				continue;
			}
			if (bullet.x < camera.scroll.x - 100 || bullet.x > Main.GAME_WIDTH + camera.scroll.x + 100 ||
				bullet.y < camera.scroll.y - 100 || bullet.y > Main.GAME_HEIGHT + camera.scroll.y + 100) {
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
			snapObjectToTiles(enemy, elapsed);
		}
		for (bomb in _powerupBombs) {
			bomb._update(elapsed);
			var hitDirection:FlxPoint = snapObjectToTiles(bomb, elapsed);
			if (hitDirection.x > 0.5) {
				bomb.velocity.set( -bomb.velocity.x, bomb.velocity.y);
			}
			if (hitDirection.y > 0.5) {
				bomb.velocity.set(bomb.velocity.x, - bomb.velocity.y);
			}
			if (bomb.isExploding()) {
				bomb.destroy();
				_powerupBombs.remove(bomb);
			}
		}
		handleScrolls();
	}
	
	function updateMenu(elapsed:Float):Void {
		levelHUD.updateText(_gameState.score, _gameState.level, _gameState.totalEnemiesLeft);
		levelHUD.update(elapsed);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		if (!lockPlayerControls) {
			handlePlayerMovement();
		}
        moveEnemies();
		updateAndHandleCollisions(elapsed);
		updateMenu(elapsed);
		
		handleMousePress();

        if(FlxG.keys.justPressed.R) {
            FlxG.switchState(new PlayState());
        }
	}
	
	// ==============================================================================
	// Utility functions
	// ==============================================================================
	
	function hitTestWall(object:FlxObject):Bool {
		var leftX:Float = object.x - object.getHitbox().width / 2;
		var rightX:Float = object.x + object.getHitbox().width / 2;
		var topY:Float = object.y - object.getHitbox().height / 2;
		var bottomY:Float = object.y + object.getHitbox().height / 2;
		
		var nwTileValue:Int = mapHandler.getVal(Std.int(leftX / TILE_WIDTH), Std.int(topY / TILE_HEIGHT));
		var neTileValue:Int = mapHandler.getVal(Std.int(rightX / TILE_WIDTH), Std.int(topY / TILE_HEIGHT));
		var swTileValue:Int = mapHandler.getVal(Std.int(leftX / TILE_WIDTH), Std.int(bottomY / TILE_HEIGHT));
		var seTileValue:Int = mapHandler.getVal(Std.int(rightX / TILE_WIDTH), Std.int(bottomY / TILE_HEIGHT));
		
		return nwTileValue != 0 || neTileValue != 0 || swTileValue != 0 || seTileValue != 0;
	}
	function snapObjectToTiles(object:FlxObject, elapsed:Float):FlxPoint {
		if (!hitTestWall(object)) {
			return new FlxPoint(0, 0);
		}
		
		var xDistance:Float = object.velocity.x * elapsed;
		var yDistance:Float = object.velocity.y * elapsed;
		var hitWithoutX:Bool = false;
		var hitWithoutY:Bool = false;
		object.x -= xDistance;
		if (hitTestWall(object)) {
			hitWithoutX = true;
		}
		object.x += xDistance;
		object.y -= yDistance;
		if (hitTestWall(object)) {
			hitWithoutY = true;
		}
		if (hitWithoutX && hitWithoutY) {
			object.x -= xDistance;
			return new FlxPoint(1, 1);
		} else if (hitWithoutX) {
			return new FlxPoint(0, 1);
		} else {
			object.y += yDistance;
			object.x -= xDistance;
			return new FlxPoint(1, 0);
		}
	}
	
	function handleScrolls() {
		camera.scroll.x = _player.x - Main.GAME_WIDTH / 2;
		camera.scroll.y = _player.y - Main.GAME_HEIGHT / 2;
		if (camera.x < 0) camera.x = 0;
	}
	
	function overlapCenteredHitboxes(obj1:FlxObject, obj2:FlxObject):Bool {
		var hitbox1:FlxRect = obj1.getHitbox();
		var hitbox2:FlxRect = obj2.getHitbox();
		
		return 	obj1.x + hitbox1.width/2 >= obj2.x - hitbox2.width/2 &&
				obj2.x + hitbox2.width/2 >= obj1.x - hitbox1.width/2 &&
				obj1.y + hitbox1.height/2 >= obj2.y - hitbox2.height/2 &&
				obj2.y + hitbox2.height/2 >= obj1.y - hitbox1.height/2;
	}
	
	function overlap(obj1:FlxObject, obj2:FlxObject):Bool {
		var hitbox1:FlxRect = obj1.getHitbox();
		var hitbox2:FlxRect = obj2.getHitbox();
		
		return 	hitbox1.x + hitbox1.width >= hitbox2.x &&
				hitbox2.x + hitbox2.width >= hitbox1.x &&
				hitbox1.y + hitbox1.height >= hitbox2.y &&
				hitbox2.y + hitbox2.height >= hitbox1.y;
	}
}
