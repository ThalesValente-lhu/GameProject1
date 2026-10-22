package views.flipnfind;

import flixel.FlxCamera;
import flixel.FlxG;

// Flip n Find is laid out for 1280 x 720, but the hub game can have any size. Every Flip n Find
// state calls setup() so the 1280 x 720 area is scaled to fit the screen with black bars around it.
// FlxG.switchState resets the cameras, so the hub and the other games never see this camera.
class Viewport
{
	public static inline var WIDTH = 1280;
	public static inline var HEIGHT = 720;
	public static inline var BACKGROUND = 0xff1c1646;

	public static function setup()
	{
		var zoom = Math.min(FlxG.width / WIDTH, FlxG.height / HEIGHT);
		var x = (FlxG.width - WIDTH * zoom) / 2;
		var y = (FlxG.height - HEIGHT * zoom) / 2;

		var camera = new FlxCamera(x, y, WIDTH, HEIGHT, zoom);
		camera.bgColor = BACKGROUND;
		FlxG.cameras.reset(camera);
	}
}
