package controllers.games.flipnfind;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

// Keyboard, gamepad and mouse controls of Flip n Find. The hub turns off the mouse and keyboard
// on mobile (see Project.xml), so they are only read here, behind the FLX_ defines.
class Input
{
	public static function left():Bool
	{
		return key([LEFT, A]) || button([DPAD_LEFT]);
	}

	public static function right():Bool
	{
		return key([RIGHT, D]) || button([DPAD_RIGHT]);
	}

	public static function up():Bool
	{
		return key([UP, W]) || button([DPAD_UP]);
	}

	public static function down():Bool
	{
		return key([DOWN, S]) || button([DPAD_DOWN]);
	}

	public static function select():Bool
	{
		return key([ENTER, SPACE]) || button([A]);
	}

	public static function retry():Bool
	{
		return key([R]) || button([X]);
	}

	public static function back():Bool
	{
		return key([ESCAPE, BACKSPACE]) || button([B]);
	}

	public static function rules():Bool
	{
		return key([I]) || button([Y]);
	}

	public static function mousePressed():Bool
	{
		#if FLX_MOUSE
		return FlxG.mouse.justPressed;
		#else
		return false;
		#end
	}

	public static function mouseMoved():Bool
	{
		#if FLX_MOUSE
		return FlxG.mouse.justMoved;
		#else
		return false;
		#end
	}

	public static function hovered(sprite:FlxSprite):Bool
	{
		#if FLX_MOUSE
		return FlxG.mouse.overlaps(sprite);
		#else
		return false;
		#end
	}

	public static function clicked(sprite:FlxSprite):Bool
	{
		return mousePressed() && hovered(sprite);
	}

	static function key(keys:Array<FlxKey>):Bool
	{
		#if FLX_KEYBOARD
		return FlxG.keys.anyJustPressed(keys);
		#else
		return false;
		#end
	}

	static function button(buttons:Array<FlxGamepadInputID>):Bool
	{
		#if FLX_GAMEPAD
		var gamepad = FlxG.gamepads.lastActive;
		return gamepad != null && gamepad.anyJustPressed(buttons);
		#else
		return false;
		#end
	}
}
