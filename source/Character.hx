package;

import flash.display3D.textures.RectangleTexture;
import flash.geom.ColorTransform;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import openfl.Assets;
import openfl.display.BitmapData;

class Character extends FlxSpriteGroup {
	public var _characterSprite:FlxSprite;
    public var _healthbarSprite:FlxSprite;
    private var _healthbarVisible:Bool;

    public var currentHealth:Int;
    public var maxHealth:Int;
	public var invulnerable:Bool;

    public function new(?X:Float=0, ?Y:Float=0, ?color:FlxColor=FlxColor.BLUE, ?maxHealth:Int=1) {
        super(X, Y);
		drawCharacterSprite(color);
        this.maxHealth = maxHealth;
        currentHealth = maxHealth;
		invulnerable = false;

		var characterSpriteData:BitmapData = Assets.getBitmapData(AssetPaths.robot_sprites_packed__png).clone();
		var ratio:Float = 0.3;
		if (color == FlxColor.BLUE) {
			ratio = 0.2;
		}
		characterSpriteData.colorTransform(characterSpriteData.rect,
			new ColorTransform(1. - ratio, 1. - ratio, 1. - ratio, 1,
							   ratio * color.red, ratio * color.green, ratio * color.blue));
		_characterSprite = new FlxSprite();
		_characterSprite.loadGraphic(characterSpriteData, true, 70, 110);
		_characterSprite.setFacingFlip(FlxObject.LEFT, false, false);
		_characterSprite.setFacingFlip(FlxObject.RIGHT, true, false);
		
		_characterSprite.animation.add("lr", [8, 9, 8, 10], 3, false);
		_characterSprite.animation.add("u", [4, 5, 4, 6], 3, false);
		_characterSprite.animation.add("d", [0, 1, 0, 2], 3, false);
		_characterSprite.animation.add("stand", [0], 3, false);
		
		_characterSprite.x = -35;
		_characterSprite.y = -87;
		add(_characterSprite);
        drawHealthbarSprite();
    }

	public function drawCharacterSprite(color:FlxColor) {
	}

    public function drawHealthbarSprite() {
        _healthbarSprite = new FlxSprite();
        _healthbarSprite.alpha = 0.3;
        _healthbarSprite.makeGraphic(32, 10, FlxColor.RED);
        _healthbarSprite.x = _characterSprite.x - this.x;
        _healthbarSprite.y = _characterSprite.y - this.y + 120;
        add(_healthbarSprite);
	}
	
	override public function getHitbox(?rect:FlxRect):FlxRect {
		return new FlxRect(_characterSprite.x - 25, _characterSprite.y - 15, 50, 50);
	}

    public function characterSprite():FlxSprite {
        return _characterSprite;
    }

	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
        _healthbarSprite.visible = _healthbarVisible;
        if (currentHealth > 0) {
            _healthbarSprite.makeGraphic(Math.ceil(currentHealth/maxHealth*_characterSprite.width), 10, FlxColor.RED);
        }
        else {
            _healthbarSprite.visible = false;
        }
		super.update(elapsed);
	}
}