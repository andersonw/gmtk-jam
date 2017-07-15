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

    public function new(?X:Float=0, ?Y:Float=0, ?color:FlxColor=FlxColor.BLUE) {
        super(X, Y);
		
		_characterSprite = new FlxSprite();
        _characterSprite.makeGraphic(32, 32, color, true);
		_characterSprite.x = _characterSprite.y = -16;
		add(_characterSprite);

        _healthbarSprite = new FlxSprite();
        _healthbarSprite.makeGraphic(32, 10, FlxColor.RED);
        _healthbarSprite.x = _characterSprite.x - this.x;
        _healthbarSprite.y = _characterSprite.y - this.y + 40;
        add(_healthbarSprite);
    }

    public function characterSprite():FlxSprite {
        return _characterSprite;
    }

	override public function update(elapsed:Float):Void {
	}
	public function _update(elapsed:Float):Void {
        _healthbarSprite.visible = _healthbarVisible;
		super.update(elapsed);
	}
}