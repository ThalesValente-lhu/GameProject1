package views.flipnfind;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import models.flipnfind.GameAssets;

// Flip n Find is laid out for 1280 x 720, but the hub game can have any size. Every Flip n Find
// state calls setup() so the 1280 x 720 area is scaled to fit and centered on the screen, and
// uses background() so the background image fills the rest of the screen around it.
// FlxG.switchState resets the cameras, so the hub and the other games never see this camera.
class Viewport
{
	public static inline var WIDTH = 1280;
	public static inline var HEIGHT = 720;
	public static inline var BACKGROUND = 0xff1c1646;

	public static function setup()
	{
		var zoom = Math.min(FlxG.width / WIDTH, FlxG.height / HEIGHT);

		// the camera covers the whole screen, scrolled so the 1280 x 720 area is in the middle
		var camera = new FlxCamera(0, 0, Math.ceil(FlxG.width / zoom), Math.ceil(FlxG.height / zoom), zoom);
		camera.scroll.set((WIDTH - camera.width) / 2, (HEIGHT - camera.height) / 2);
		camera.bgColor = BACKGROUND;
		FlxG.cameras.reset(camera);
	}

	// the background image scaled up to cover everything the camera shows, without stretching it
	public static function background():FlxSprite
	{
		var background = new FlxSprite(0, 0, GameAssets.BACKGROUND);
		var camera = FlxG.camera;
		var scale = Math.max(camera.width / background.frameWidth, camera.height / background.frameHeight);
		background.scale.set(scale, scale);
		background.updateHitbox();
		background.setPosition((WIDTH - background.width) / 2, (HEIGHT - background.height) / 2);
		return background;
	}
}
