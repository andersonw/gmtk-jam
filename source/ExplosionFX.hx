package;

import flash.geom.ColorTransform;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import openfl.Assets;
import openfl.display.BitmapData;

class ExplosionFX extends FlxSpriteGroup {
	private var duration:Float;
	
	private var maxRadius:Float;
	private var explosionSprite:FlxSprite;
	private var MAX_DURATION = 1.8;
	
    public function new(?X:Float=0, ?Y:Float=0, ?maxRadius:Float, ?color:FlxColor) {
        super(X, Y);
		this.duration = MAX_DURATION;
		this.maxRadius = maxRadius;
		
		var glowCircle:BitmapData = Assets.getBitmapData("assets/images/glow_circle.png").clone();
		var colorVariance:Float = 8;
		glowCircle.colorTransform(glowCircle.rect, new ColorTransform(0.1, 0.1, 0.1, 2,
			color.red * 7 / 10, color.green * 7 / 10, color.blue * 7 / 10));
		explosionSprite = new FlxSprite();
		explosionSprite.loadGraphic(glowCircle);
		explosionSprite.x = explosionSprite.y = -20;
		add(explosionSprite);
    }
	public override function update(elapsed:Float):Void {
		super.update(elapsed);
		
		this.duration -= elapsed;
		
		var radius:Float;
		
		if (this.duration > MAX_DURATION - 0.4) {
			radius = (MAX_DURATION - this.duration) / 0.4 * maxRadius;
		} else if (this.duration > 0.8) {
			radius = maxRadius;
		} else {
			radius = maxRadius - 0.4 * maxRadius * (1. - this.duration / 0.8);
			explosionSprite.alpha = this.duration;
		}
		explosionSprite.scale = new FlxPoint(radius / 25, radius / 25);
		
		if (this.duration <= 0) {
			this.destroy();
		}
	}
}