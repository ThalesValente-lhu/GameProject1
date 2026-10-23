package;

import flixel.FlxG;
import flixel.FlxState;

/** Loads saved settings once, applies them, then goes to the title screen. */
class BootState extends FlxState
{
	override public function create():Void
	{
		super.create();
		FlxG.autoPause = true;
		Settings.load();
		Settings.apply();
		FlxG.switchState(() -> new MenuState());
	}
}
