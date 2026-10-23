package controllers.games.midnight;

import models.midnight.Settings;
import views.midnight.Theme;
import views.midnight.UIButton;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText.FlxTextAlign;

/** Pause menu. The game's timers stop because the parent state doesn't update while this is open. */
class PauseSubState extends FlxSubState
{
	var nav:MenuNav;
	var musicBtn:UIButton;
	var inputBtn:UIButton;
	var screenBtn:UIButton;

	override public function create():Void
	{
		super.create();
		Controls.strict = false;
		FlxG.mouse.visible = true;

		var dim = new FlxSprite(0, 0);
		dim.makeGraphic(FlxG.width, FlxG.height, 0xC00A0816);
		add(dim);
		add(Theme.panel(390, 130, 500, 470, 0xFF221C40, Theme.PANEL_LINE, 32));
		add(Theme.title(390, 160, 500, "Paused", 44, FlxTextAlign.CENTER));
		add(Theme.text(390, 222, 500, "The customers will wait. For now.", 16, Theme.MUTED, false, FlxTextAlign.CENTER));

		var resume = new UIButton(440, 270, 400, 54, "Resume", close, true);
		musicBtn = new UIButton(440, 336, 400, 50, "", () ->
		{
			Settings.toggleMusic();
			refresh();
		});
		inputBtn = new UIButton(440, 396, 400, 50, "", () ->
		{
			Settings.inputMode = (Settings.inputMode + 1) % 3;
			Settings.persist();
			refresh();
		});
		screenBtn = new UIButton(440, 456, 400, 50, "", () ->
		{
			Settings.fullscreen = !Settings.fullscreen;
			#if desktop
			Settings.apply();
			#else
			FlxG.fullscreen = Settings.fullscreen;
			#end
			Settings.persist();
			refresh();
		});
		var quit = new UIButton(440, 524, 400, 50, "Close shop (quit to menu)", () -> FlxG.switchState(() -> new MidnightMenuState()));
		var buttons = [resume, musicBtn, inputBtn, screenBtn, quit];
		for (b in buttons) add(b);
		nav = new MenuNav(buttons);
		refresh();
	}

	function refresh():Void
	{
		musicBtn.setText("Music: " + (Settings.musicOn ? "On" : "Off"));
		inputBtn.setText("Input: " + Settings.INPUT_NAMES[Settings.inputMode]);
		screenBtn.setText("Display: " + (Settings.fullscreen ? "Fullscreen" : "Windowed"));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (Controls.pause())
		{
			close();
			return;
		}
		nav.update();
	}
}
