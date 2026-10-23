package models.midnight;



import flixel.FlxG;
import flixel.util.FlxSave;

/**
 * Player-controlled settings (display, resolution, input device, audio),
 * persisted between sessions with FlxSave.
 */
class Settings
{
	public static final RESOLUTIONS:Array<Array<Int>> = [[960, 540], [1280, 720], [1600, 900], [1920, 1080]];
	public static final INPUT_NAMES:Array<String> = ["Mouse + Keyboard", "Keyboard only", "Gamepad"];

	public static inline var INPUT_MOUSE_KEYS = 0;
	public static inline var INPUT_KEYS = 1;
	public static inline var INPUT_GAMEPAD = 2;

	public static var musicOn:Bool = true;
	public static var musicVolume:Float = 0.5;
	public static var sfxVolume:Float = 0.8;
	public static var inputMode:Int = INPUT_MOUSE_KEYS;
	public static var fullscreen:Bool = false;
	public static var resolutionIndex:Int = 1;
	public static var displayIndex:Int = 0;
	public static var highScore:Int = 0;

	static var save:FlxSave;

	public static function load():Void
	{
		save = new FlxSave();
		save.bind("midnight_apothecary");
		var d = save.data;
		if (d.musicOn != null) musicOn = d.musicOn;
		if (d.musicVolume != null) musicVolume = d.musicVolume;
		if (d.sfxVolume != null) sfxVolume = d.sfxVolume;
		if (d.inputMode != null) inputMode = d.inputMode;
		if (d.fullscreen != null) fullscreen = d.fullscreen;
		if (d.resolutionIndex != null) resolutionIndex = d.resolutionIndex;
		if (d.displayIndex != null) displayIndex = d.displayIndex;
		if (d.highScore != null) highScore = d.highScore;
	}

	public static function persist():Void
	{
		if (save == null) return;
		var d = save.data;
		d.musicOn = musicOn;
		d.musicVolume = musicVolume;
		d.sfxVolume = sfxVolume;
		d.inputMode = inputMode;
		d.fullscreen = fullscreen;
		d.resolutionIndex = resolutionIndex;
		d.displayIndex = displayIndex;
		d.highScore = highScore;
		save.flush();
	}

	/** Push the current settings to the window, mouse and audio. */
	public static function apply():Void
	{
		#if desktop
		if (displayIndex >= displayCount()) displayIndex = 0;
		FlxG.fullscreen = false;
		var r = RESOLUTIONS[resolutionIndex];
		FlxG.resizeWindow(r[0], r[1]);
		moveToDisplay(displayIndex);
		FlxG.fullscreen = fullscreen;
		#end
		applyAudio();
	}

	public static function applyAudio():Void
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.volume = musicOn ? musicVolume : 0;
	}

	// ---------------------------------------------------------------- display

	public static function displayCount():Int
	{
		#if desktop
		return lime.system.System.numDisplays;
		#else
		return 1;
		#end
	}

	public static function displayName(i:Int):String
	{
		#if desktop
		var d = lime.system.System.getDisplay(i);
		if (d != null && d.name != null && d.name != "") return '${i + 1}: ${d.name}';
		#end
		return 'Display ${i + 1}';
	}

	/** Centers the game window on the chosen monitor. */
	public static function moveToDisplay(i:Int):Void
	{
		#if desktop
		var d = lime.system.System.getDisplay(i);
		var win = lime.app.Application.current.window;
		if (d == null || win == null) return;
		var b = d.bounds;
		win.move(Std.int(b.x + (b.width - win.width) / 2), Std.int(b.y + (b.height - win.height) / 2));
		#end
	}

	// ------------------------------------------------------------------ audio

	public static function startMusic():Void
	{
		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
			FlxG.sound.playMusic("assets/music/midnight-music/theme.wav", musicOn ? musicVolume : 0, true);
		applyAudio();
	}

	public static function toggleMusic():Void
	{
		musicOn = !musicOn;
		applyAudio();
		persist();
	}

	public static function sfx(name:String, volume:Float = 1.0):Void
	{
		if (sfxVolume > 0)
			FlxG.sound.play('assets/sounds/midnight-sounds/$name.wav', sfxVolume * volume);
	}
}
