package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.text.FlxText.FlxTextAlign;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.FlxTweenType;
import flixel.util.FlxColor;

/** Title screen with the rules summary, Play / Options / Quit. */
class MenuState extends FlxState
{
	var nav:MenuNav;

	override public function create():Void
	{
		super.create();
		bgColor = Theme.BG;
		FlxG.mouse.visible = true;
		Controls.strict = false;
		Settings.startMusic();

		// decorative bubbling cauldron on the left
		var cauldron = new FlxSprite(190, 300, "assets/images/ui/cauldron.png");
		cauldron.antialiasing = true;
		var liquid = new FlxSprite(cauldron.x + 28, cauldron.y + 20, "assets/images/ui/liquid.png");
		liquid.color = 0xFF8A6CD8;
		liquid.antialiasing = true;
		var bubbles = new FlxEmitter(cauldron.x + 50, cauldron.y + 24, 40);
		bubbles.width = 140;
		bubbles.makeParticles(6, 6, FlxColor.WHITE, 40);
		bubbles.color.set(0xFFB49CFF, 0xFFE0D4FF);
		bubbles.launchAngle.set(-100, -80);
		bubbles.speed.set(30, 70);
		bubbles.lifespan.set(0.8, 1.6);
		bubbles.alpha.set(0.9, 0.9, 0, 0);
		add(cauldron);
		add(liquid);
		add(bubbles);
		bubbles.start(false, 0.08);

		var t = Theme.title(0, 70, FlxG.width, "Midnight Apothecary", 64, FlxTextAlign.CENTER);
		add(t);
		FlxTween.tween(t, {y: 80}, 2.2, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});

		// rules panel
		add(Theme.panel(560, 190, 620, 380));
		var rules = "Customers flash their recipe at you for a few seconds. Then it's hidden, and you brew it from memory.\n\n"
			+ "-  Add the ingredients in the exact order shown.\n"
			+ "-  Serve before the customer runs out of patience.\n"
			+ "-  Recipes get longer and peeks get shorter as you go.\n"
			+ "-  Three wrong (or late) potions and the shop closes.";
		add(Theme.text(590, 215, 560, rules, 19));
		add(Theme.text(590, 470, 560, "Keyboard: 1-8 add, Backspace undo, Enter serve, Space skip peek, Esc pause, M music.\n"
			+ "Gamepad: D-pad choose, A add, B undo, Y serve, Start pause.", 14, Theme.MUTED));

		var play = new UIButton(560, 600, 300, 60, "Open the shop", () -> FlxG.switchState(() -> new PlayState()), true, 22);
		var opts = new UIButton(880, 600, 140, 60, "Options", () -> FlxG.switchState(() -> new OptionsState()));
		var buttons = [play, opts];
		#if sys
		var quit = new UIButton(1040, 600, 140, 60, "Quit", () -> Sys.exit(0));
		buttons.push(quit);
		#end
		for (b in buttons) add(b);
		nav = new MenuNav(buttons);

		add(Theme.text(60, 660, 480, "Best score: " + Settings.highScore, 18, Theme.GOLD, true));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		nav.update();
		if (Controls.music()) Settings.toggleMusic();
	}
}
