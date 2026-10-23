package;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.FlxKey;

/**
 * Central input mapping. During gameplay only the device chosen in Options
 * is listened to. Menus always accept every device so a player can never
 * get stuck (e.g. picking Gamepad with no controller plugged in).
 */
class Controls
{
	/** When true, only the chosen device counts (set by PlayState). */
	public static var strict:Bool = false;

	public static function mouseEnabled():Bool
		return !strict || Settings.inputMode == Settings.INPUT_MOUSE_KEYS;

	public static function keysEnabled():Bool
		return !strict || Settings.inputMode != Settings.INPUT_GAMEPAD;

	public static function pad():FlxGamepad
	{
		if (strict && Settings.inputMode != Settings.INPUT_GAMEPAD) return null;
		return FlxG.gamepads.lastActive;
	}

	static function key(keys:Array<FlxKey>):Bool
		return keysEnabled() && FlxG.keys.anyJustPressed(keys);

	public static function confirm():Bool
	{
		var p = pad();
		return key([ENTER, SPACE]) || (p != null && p.justPressed.A);
	}

	public static function back():Bool
	{
		var p = pad();
		return FlxG.keys.justPressed.ESCAPE || (p != null && p.justPressed.B);
	}

	public static function up():Bool
	{
		var p = pad();
		return key([UP, W]) || (p != null && p.justPressed.DPAD_UP);
	}

	public static function down():Bool
	{
		var p = pad();
		return key([DOWN, S]) || (p != null && p.justPressed.DPAD_DOWN);
	}

	public static function left():Bool
	{
		var p = pad();
		return key([LEFT, A]) || (p != null && p.justPressed.DPAD_LEFT);
	}

	public static function right():Bool
	{
		var p = pad();
		return key([RIGHT, D]) || (p != null && p.justPressed.DPAD_RIGHT);
	}

	// ----------------------------------------------------------- gameplay only

	static final NUMBER_KEYS:Array<Array<FlxKey>> = [
		[ONE, NUMPADONE], [TWO, NUMPADTWO], [THREE, NUMPADTHREE], [FOUR, NUMPADFOUR],
		[FIVE, NUMPADFIVE], [SIX, NUMPADSIX], [SEVEN, NUMPADSEVEN], [EIGHT, NUMPADEIGHT]
	];

	/** Returns 0-7 if a number key was just pressed, otherwise -1. */
	public static function ingredientKey():Int
	{
		if (!keysEnabled()) return -1;
		for (i in 0...NUMBER_KEYS.length)
			if (FlxG.keys.anyJustPressed(NUMBER_KEYS[i])) return i;
		return -1;
	}

	public static function undo():Bool
	{
		var p = pad();
		return key([BACKSPACE, DELETE]) || (p != null && p.justPressed.B);
	}

	public static function serve():Bool
	{
		var p = pad();
		return key([ENTER]) || (p != null && p.justPressed.Y);
	}

	public static function skipPeek():Bool
	{
		var p = pad();
		return key([SPACE]) || (p != null && p.justPressed.A);
	}

	/** Gamepad A adds the highlighted ingredient while brewing. */
	public static function padAdd():Bool
	{
		var p = pad();
		return p != null && p.justPressed.A;
	}

	public static function pause():Bool
	{
		var p = pad();
		return FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.P || (p != null && p.justPressed.START);
	}

	public static function music():Bool
	{
		var p = pad();
		return key([M]) || (p != null && p.justPressed.BACK);
	}
}
