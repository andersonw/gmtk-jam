package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
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

        _healthbarSprite = new FlxSprite();
        _healthbarSprite.makeGraphic(32, 10, FlxColor.RED);
        _healthbarSprite.x = _characterSprite.x - this.x;
        _healthbarSprite.y = _characterSprite.y - this.y + 40;
        add(_healthbarSprite);

        this.maxHealth = maxHealth;
        currentHealth = maxHealth;
    }
	
	public function drawCharacterSprite(color:FlxColor) {
		_characterSprite = new FlxSprite();
        _characterSprite.makeGraphic(32, 32, color, true);
		_characterSprite.x = _characterSprite.y = -16;
		add(_characterSprite);
	}

    public function characterSprite():FlxSprite {
        return _characterSprite;
    }

	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
        _healthbarSprite.visible = _healthbarVisible;
        if (currentHealth > 0) {
            _healthbarSprite.makeGraphic(Std.int(currentHealth/maxHealth*_characterSprite.width), 10, FlxColor.RED);
        }
        else {
            _healthbarSprite.visible = false;
        }
		super.update(elapsed);
	}
}