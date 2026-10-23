package controllers.games;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import controllers.MenuState;
import controllers.games.midnight.Controls;
import controllers.games.midnight.MidnightMenuState;
import models.midnight.Settings;

/**
 * Entry point for Midnight Apothecary, launched from the hub menu.
 * Loads the saved settings, then opens the game's title screen.
 */
class MidnightApothecary extends FlxState
{
	override public function create():Void
	{
		super.create();
		FlxG.autoPause = true;
		Settings.load();
		Settings.apply();
		FlxG.switchState(() -> new MidnightMenuState());
	}

	/** Leaves the game and returns to the hub, undoing the game's global changes. */
	public static function exitToHub():Void
	{
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
			FlxG.sound.music = null;
		}
		Controls.strict = false;
		FlxG.mouse.visible = true;
		FlxG.cameras.bgColor = FlxColor.BLACK;
		FlxG.switchState(() -> new MenuState());
	}
}
