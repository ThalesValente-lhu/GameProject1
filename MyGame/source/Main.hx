package;

import flixel.FlxGame;
import openfl.display.Sprite;
import controllers.MenuState;

class Main extends Sprite
{
	public function new()
	{
		super();
		// 1280x720: Midnight Apothecary's screens are laid out for this size.
		addChild(new FlxGame(1280, 720, MenuState));
	}
}
