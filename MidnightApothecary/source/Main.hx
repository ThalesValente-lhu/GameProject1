package;

import flixel.FlxGame;
import openfl.display.Sprite;

/**
 * Entry point. The game always renders at 1280x720 internally and is
 * letterboxed/scaled to whatever window size or monitor the player picks
 * in the Options menu.
 */
class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(1280, 720, () -> new BootState(), 60, 60, true, false));
	}
}
