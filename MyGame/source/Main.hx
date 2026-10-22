package;

import flixel.FlxGame;
import openfl.display.Sprite;
import controllers.MenuState;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(800, 600, MenuState));
	}
}
