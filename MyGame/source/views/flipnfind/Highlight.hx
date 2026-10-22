package views.flipnfind;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

// a white rounded frame that slowly fades in and out around the selected card
class Highlight extends FlxSprite
{
	public function new(width:Float, height:Float)
	{
		super();
		makeGraphic(Std.int(width), Std.int(height), FlxColor.TRANSPARENT, true);
		FlxSpriteUtil.drawRoundRect(this, 3, 3, width - 6, height - 6, 24, 24, FlxColor.TRANSPARENT, {thickness: 5, color: FlxColor.WHITE});
		FlxTween.tween(this, {alpha: 0.3}, 0.6, {type: PINGPONG});
	}
}
