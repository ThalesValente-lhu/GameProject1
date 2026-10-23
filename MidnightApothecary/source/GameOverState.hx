package;

import PlayState.RunStats;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText.FlxTextAlign;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/** End screen: final score, customers served, best streak, high score. */
class GameOverState extends FlxState
{
	var nav:MenuNav;

	override public function create():Void
	{
		super.create();
		bgColor = Theme.BG;
		Controls.strict = false;
		FlxG.mouse.visible = true;
		Settings.sfx("gameover");

		add(Theme.title(0, 90, FlxG.width, "The shop is closed", 56, FlxTextAlign.CENTER));
		add(Theme.panel(340, 200, 600, 300));

		var big = Theme.text(340, 230, 600, Std.string(RunStats.score), 72, Theme.GOLD, true, FlxTextAlign.CENTER);
		add(big);
		big.scale.set(0.3, 0.3);
		FlxTween.tween(big.scale, {x: 1, y: 1}, 0.6, {ease: FlxEase.elasticOut});

		add(Theme.text(340, 330, 600, "points", 20, Theme.MUTED, false, FlxTextAlign.CENTER));
		add(Theme.text(340, 380, 600, 'Customers served: ${RunStats.served}     Best streak: ${RunStats.bestStreak}', 20, Theme.TEXT, false,
			FlxTextAlign.CENTER));
		var bestLine = RunStats.newBest ? "New best score!" : 'Best score: ${Settings.highScore}';
		add(Theme.text(340, 430, 600, bestLine, 22, RunStats.newBest ? Theme.GOOD : Theme.GOLD, true, FlxTextAlign.CENTER));

		var again = new UIButton(340, 540, 290, 60, "Open again", () -> FlxG.switchState(() -> new PlayState()), true, 22);
		var menu = new UIButton(650, 540, 290, 60, "Main menu", () -> FlxG.switchState(() -> new MenuState()), false, 22);
		add(again);
		add(menu);
		nav = new MenuNav([again, menu]);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		nav.update();
	}
}
