package views.flipnfind;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import models.flipnfind.GameAssets;

class Card extends FlxSprite
{
	public static inline var WIDTH = 128;
	public static inline var HEIGHT = 160;

	public var face:Int;
	public var isOpen = false;
	public var matched = false;

	var size:Float;

	public function new(x:Float, y:Float, face:Int, size:Float)
	{
		super(x, y);
		this.face = face;
		this.size = size;

		// frame 0 is the back of the card, frames 1 to 30 are the animals
		loadGraphic(GameAssets.CARDS, true, WIDTH, HEIGHT);
		scale.set(size, size);
		updateHitbox();
	}

	public function flip()
	{
		isOpen = !isOpen;
		FlxTween.tween(scale, {x: 0}, 0.1, {onComplete: showSide});
	}

	function showSide(tween:FlxTween)
	{
		if (isOpen)
			animation.frameIndex = face + 1;
		else
			animation.frameIndex = 0;
		FlxTween.tween(scale, {x: size}, 0.1);
	}

	public function fall()
	{
		matched = true;
		velocity.set(FlxG.random.float(-100, 100), -300);
		acceleration.y = 1000;
		angularVelocity = FlxG.random.float(-200, 200);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (matched && velocity.y > 0 && !isOnScreen())
			kill();
	}
}
