package;

import flash.display3D.textures.RectangleTexture;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class Character extends FlxSpriteGroup {
	private var _characterSprite:FlxSprite;
    private var _healthbarSprite:FlxSprite;
    private var _healthbarVisible:Bool;

    public var currentHealth:Int;
    public var maxHealth:Int;

    public function new(?X:Float=0, ?Y:Float=0, ?color:FlxColor=FlxColor.BLUE, ?maxHealth:Int=1) {
        super(X, Y);
		drawCharacterSprite(color);
        this.maxHealth = maxHealth;
        currentHealth = maxHealth;

		_characterSprite = new FlxSprite();
		_characterSprite.loadGraphic(AssetPaths.robot_sprites_packed__png, true, 70, 110);
		_characterSprite.setFacingFlip(FlxObject.LEFT, false, false);
		_characterSprite.setFacingFlip(FlxObject.RIGHT, true, false);
		
		_characterSprite.animation.add("lr", [8], 6, false);
		_characterSprite.animation.add("u", [4, 5, 4, 6], 6, false);
		_characterSprite.animation.add("d", [0, 1, 0, 2], 6, false);
		
		_characterSprite.x = -35;
		_characterSprite.y = -87;
		add(_characterSprite);
        drawHealthbarSprite();
    }

	public function drawCharacterSprite(color:FlxColor) {
	}

    public function drawHealthbarSprite() {
        _healthbarSprite = new FlxSprite();
        _healthbarSprite.makeGraphic(32, 10, FlxColor.RED);
        _healthbarSprite.x = _characterSprite.x - this.x;
        _healthbarSprite.y = _characterSprite.y - this.y + 120;
        add(_healthbarSprite);
	}
	
	override public function getHitbox(?rect:FlxRect):FlxRect {
		return new FlxRect(_characterSprite.x - 25, _characterSprite.y - 5, 50, 40);
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