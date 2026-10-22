package controllers.games.flipnfind;

import controllers.MenuState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxDestroyUtil;
import models.flipnfind.GameAssets;
import models.flipnfind.Levels;
import models.flipnfind.Progress;
import views.flipnfind.LevelSelectUI;
import views.flipnfind.Viewport;

// Entry point of Flip n Find from the hub menu: the level select screen.
class LevelSelectState extends FlxState
{
	// true from the moment the player comes in from the hub until they go back to it
	static var inGame = false;

	// hub settings that Flip n Find changes, put back when going back to the hub
	static var hubSystemCursor = false;
	static var hubAntialiasing = false;

	var ui:LevelSelectUI;
	var selected = 0;

	override public function create()
	{
		super.create();

		if (!inGame)
			enterGame();

		Viewport.setup();

		ui = new LevelSelectUI(Progress.bestScores(), Progress.unlocked());
		add(ui);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Input.rules() || Input.clicked(ui.infoButton))
		{
			openSubState(new RulesSubState());
			return;
		}

		if (Input.back())
		{
			leaveGame();
			return;
		}

		var last = Levels.all.length - 1;
		if (Input.left() && selected > 0)
			selected--;
		if (Input.right() && selected < last)
			selected++;
		if (Input.up() && selected >= 5)
			selected -= 5;
		if (Input.down() && selected < 5)
			selected += 5;

		for (i in 0...ui.levelCards.length)
		{
			if (Input.hovered(ui.levelCards[i]))
			{
				if (Input.mouseMoved())
					selected = i;
				if (Input.mousePressed())
					startLevel(i);
			}
		}

		if (Input.select())
			startLevel(selected);

		ui.select(selected);
	}

	function startLevel(level:Int)
	{
		if (level >= Progress.unlocked())
		{
			FlxG.sound.play(GameAssets.MISS);
			return;
		}
		FlxG.sound.play(GameAssets.CLICK);
		FlxG.switchState(() -> new LevelPlayState(level));
	}

	function enterGame()
	{
		inGame = true;

		// the cards and texts are scaled down to fit the hub screen, so smooth them
		hubAntialiasing = FlxSprite.defaultAntialiasing;
		FlxSprite.defaultAntialiasing = true;

		#if FLX_MOUSE
		hubSystemCursor = FlxG.mouse.useSystemCursor;
		FlxG.mouse.useSystemCursor = true;
		#end

		FlxG.sound.playMusic(GameAssets.MUSIC, 0.5);
	}

	function leaveGame()
	{
		inGame = false;

		FlxSprite.defaultAntialiasing = hubAntialiasing;

		#if FLX_MOUSE
		FlxG.mouse.useSystemCursor = hubSystemCursor;
		#end

		FlxG.sound.music = FlxDestroyUtil.destroy(FlxG.sound.music);

		FlxG.switchState(MenuState.new);
	}
}
