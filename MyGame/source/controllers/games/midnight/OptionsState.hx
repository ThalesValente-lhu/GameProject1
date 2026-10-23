package controllers.games.midnight;

import models.midnight.Settings;
import views.midnight.Theme;
import views.midnight.UIButton;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextAlign;

typedef OptionRow =
{
	var label:String;
	var value:Void->String;
	var change:Int->Void;
}

/**
 * Lets the player choose the display (monitor), window resolution,
 * windowed/fullscreen, input device, and audio levels at any time.
 * Also reachable from the pause menu.
 */
class OptionsState extends FlxState
{
	/** Where to go when leaving Options (menu or back into a paused game is handled by caller). */
	public static var returnToMenu:Bool = true;

	var rows:Array<OptionRow>;
	var labels:Array<FlxText> = [];
	var values:Array<FlxText> = [];
	var arrows:Array<UIButton> = [];
	var selected:Int = 0;
	var backBtn:UIButton;
	var note:FlxText;

	override public function create():Void
	{
		super.create();
		bgColor = Theme.BG;
		FlxG.mouse.visible = true;
		Controls.strict = false;

		add(Theme.title(0, 40, FlxG.width, "Options", 52, FlxTextAlign.CENTER));
		add(Theme.panel(240, 130, 800, 480));

		rows = [
			{
				label: "Music",
				value: () -> Settings.musicOn ? "On" : "Off",
				change: function(d:Int):Void { Settings.toggleMusic(); }
			},
			{
				label: "Music volume",
				value: () -> Std.int(Math.round(Settings.musicVolume * 100)) + "%",
				change: function(d:Int):Void
				{
					Settings.musicVolume = clamp(Settings.musicVolume + d * 0.1);
					Settings.applyAudio();
				}
			},
			{
				label: "Sound effects",
				value: () -> Std.int(Math.round(Settings.sfxVolume * 100)) + "%",
				change: function(d:Int):Void
				{
					Settings.sfxVolume = clamp(Settings.sfxVolume + d * 0.1);
					Settings.sfx("add");
				}
			},
			{
				label: "Input device",
				value: () -> Settings.INPUT_NAMES[Settings.inputMode],
				change: function(d:Int):Void { Settings.inputMode = (Settings.inputMode + d + 3) % 3; }
			},
			{
				label: "Display mode",
				value: () -> Settings.fullscreen ? "Fullscreen" : "Windowed",
				change: function(d:Int):Void
				{
					Settings.fullscreen = !Settings.fullscreen;
					#if desktop
					Settings.apply();
					#else
					FlxG.fullscreen = Settings.fullscreen;
					#end
				}
			}
		];
		#if desktop
		rows.push({
			label: "Resolution",
			value: () ->
			{
				var r = Settings.RESOLUTIONS[Settings.resolutionIndex];
				return r[0] + " x " + r[1];
			},
			change: function(d:Int):Void
			{
				Settings.resolutionIndex = (Settings.resolutionIndex + d + Settings.RESOLUTIONS.length) % Settings.RESOLUTIONS.length;
				Settings.apply();
			}
		});
		rows.push({
			label: "Monitor",
			value: () -> Settings.displayName(Settings.displayIndex),
			change: function(d:Int):Void
			{
				var n = Settings.displayCount();
				Settings.displayIndex = (Settings.displayIndex + d + n) % n;
				Settings.apply();
			}
		});
		#end

		var y = 160.0;
		for (i in 0...rows.length)
		{
			var row = rows[i];
			var l = Theme.text(280, y + 8, 300, row.label, 22);
			labels.push(l);
			add(l);
			var v = Theme.text(680, y + 8, 260, "", 22, Theme.GOLD, true, FlxTextAlign.CENTER);
			values.push(v);
			add(v);
			var idx = i;
			var left = new UIButton(620, y, 50, 44, "<", () -> changeRow(idx, -1));
			var right = new UIButton(950, y, 50, 44, ">", () -> changeRow(idx, 1));
			arrows.push(left);
			arrows.push(right);
			add(left);
			add(right);
			y += 58;
		}

		note = Theme.text(280, 560, 720, "", 15, Theme.MUTED);
		add(note);

		backBtn = new UIButton(490, 630, 300, 56, "Back", leave, true);
		add(backBtn);
		refresh();
	}

	static function clamp(v:Float):Float
		return Math.max(0, Math.min(1, Math.round(v * 10) / 10));

	function changeRow(i:Int, dir:Int):Void
	{
		selected = i;
		rows[i].change(dir);
		Settings.persist();
		refresh();
	}

	function leave():Void
	{
		Settings.persist();
		FlxG.switchState(() -> new MidnightMenuState());
	}

	function refresh():Void
	{
		for (i in 0...rows.length)
		{
			values[i].text = rows[i].value();
			labels[i].color = i == selected ? Theme.GOLD_LIGHT : Theme.TEXT;
		}
		backBtn.focused = selected == rows.length;

		var n = "Use Up/Down to pick a setting and Left/Right to change it. Settings are saved automatically.";
		if (Settings.inputMode == Settings.INPUT_GAMEPAD && FlxG.gamepads.numActiveGamepads == 0)
			n = "No gamepad detected - plug one in (menus still accept keyboard and mouse).";
		#if html5
		n += " Resolution and monitor follow your browser window on the web build.";
		#end
		note.text = n;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		var count = rows.length + 1; // + Back button
		if (Controls.up())
		{
			selected = (selected - 1 + count) % count;
			Settings.sfx("tick", 0.6);
			refresh();
		}
		else if (Controls.down())
		{
			selected = (selected + 1) % count;
			Settings.sfx("tick", 0.6);
			refresh();
		}
		else if (selected < rows.length && Controls.left()) changeRow(selected, -1);
		else if (selected < rows.length && Controls.right()) changeRow(selected, 1);
		else if (selected == rows.length && Controls.confirm()) backBtn.press();
		else if (Controls.back()) leave();
	}
}
