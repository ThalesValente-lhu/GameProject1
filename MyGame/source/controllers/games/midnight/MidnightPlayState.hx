package controllers.games.midnight;

import models.midnight.Customer;
import models.midnight.Customer.CustomerData;
import models.midnight.Ingredient;
import models.midnight.Phase;
import models.midnight.RunStats;
import models.midnight.Settings;
import views.midnight.IngredientButton;
import views.midnight.SlotCard;
import views.midnight.SlotCard.SlotLook;
import views.midnight.Theme;
import views.midnight.UIButton;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * Main game. Each customer shows a recipe (sequence of ingredients) for a
 * short "peek", then hides it. The player recreates it from memory by
 * throwing ingredients into the cauldron, then serves before patience runs out.
 */
class MidnightPlayState extends FlxState
{
	static inline var MAX_LIVES = 3;
	static inline var GRAVITY = 1600.0; // px/s^2 for thrown ingredients
	static inline var FLIGHT_TIME = 0.55; // seconds for an ingredient to reach the cauldron

	// game state
	var phase:Phase = WAITING;
	var recipe:Array<Int> = [];
	var brew:Array<Int> = [];
	var timer:Float = 0;
	var timerMax:Float = 1;
	var score:Int = 0;
	var streak:Int = 0;
	var bestStreak:Int = 0;
	var lives:Int = MAX_LIVES;
	var served:Int = 0;
	var customer:CustomerData;
	var potion:String;
	var lastTick:Int = -1;
	var cursor:Int = 0;
	var clock:Float = 0;

	// HUD
	var scoreText:FlxText;
	var streakText:FlxText;
	var vials:Array<FlxSprite> = [];
	var musicBtn:UIButton;

	// customer panel
	var portrait:FlxSprite;
	var customerTitle:FlxText;
	var quoteText:FlxText;
	var recipeBox:FlxSprite;
	var recipeCards:FlxTypedGroup<SlotCard>;
	var barFill:FlxSprite;
	var hintText:FlxText;

	// cauldron panel
	var cauldron:FlxSprite;
	var liquid:FlxSprite;
	var bubbles:FlxEmitter;
	var splash:FlxEmitter;
	var mouth:FlxObject;
	var brewCards:FlxTypedGroup<SlotCard>;
	var undoBtn:UIButton;
	var serveBtn:UIButton;

	// shelf + physics
	var shelf:Array<IngredientButton> = [];
	var flying:FlxTypedGroup<FlxSprite>;

	static inline var BAR_X = 80;
	static inline var BAR_W = 550;
	static inline var BREW_CX = 940;

	override public function create():Void
	{
		super.create();
		bgColor = Theme.BG;
		Controls.strict = true;
		FlxG.mouse.visible = Settings.inputMode == Settings.INPUT_MOUSE_KEYS;
		Settings.startMusic();

		buildHud();
		buildCustomerPanel();
		buildCauldronPanel();
		buildShelf();

		flying = new FlxTypedGroup<FlxSprite>();
		add(flying);
		refreshHud();

		FlxG.camera.fade(FlxColor.BLACK, 0.4, true);
		nextCustomer();
	}

	// ================================================================ layout

	function buildHud():Void
	{
		add(Theme.title(60, 18, 560, "Midnight Apothecary", 40));
		scoreText = Theme.text(630, 34, 170, "", 22, Theme.TEXT, true);
		streakText = Theme.text(800, 34, 140, "", 22, Theme.TEXT, true);
		add(scoreText);
		add(streakText);
		for (i in 0...MAX_LIVES)
		{
			var v = new FlxSprite(940 + i * 28, 28, "assets/images/midnight-images/ui/vial_full.png");
			v.antialiasing = true;
			vials.push(v);
			add(v);
		}
		musicBtn = new UIButton(1036, 26, 92, 44, "", () -> toggleMusic(), false, 16);
		add(musicBtn);
		add(new UIButton(1138, 26, 72, 44, "II", openPause, false, 18));
		refreshHud();
	}

	function buildCustomerPanel():Void
	{
		add(Theme.panel(60, 96, 590, 340));
		var ring = new FlxSprite(80, 112);
		ring.makeGraphic(108, 108, FlxColor.TRANSPARENT, true);
		FlxSpriteUtil.drawCircle(ring, 54, 54, 52, 0xFF2A2348, {thickness: 2, color: Theme.PANEL_LINE});
		add(ring);
		portrait = new FlxSprite(86, 118);
		portrait.antialiasing = true;
		add(portrait);

		customerTitle = Theme.text(204, 122, 430, "", 20, Theme.TEXT, true);
		quoteText = Theme.text(204, 156, 430, "", 17, Theme.MUTED);
		add(customerTitle);
		add(quoteText);

		recipeBox = new FlxSprite(80, 228);
		recipeBox.makeGraphic(550, 116, FlxColor.TRANSPARENT, true);
		add(recipeBox);
		recipeCards = new FlxTypedGroup<SlotCard>();
		add(recipeCards);

		var barBg = new FlxSprite(BAR_X, 356);
		barBg.makeGraphic(BAR_W, 12, 0xFF2E2754);
		add(barBg);
		barFill = new FlxSprite(BAR_X, 356);
		barFill.makeGraphic(BAR_W, 12, FlxColor.WHITE);
		barFill.origin.set(0, 0);
		add(barFill);

		hintText = Theme.text(80, 378, 550, "", 16, Theme.MUTED);
		add(hintText);
	}

	function buildCauldronPanel():Void
	{
		add(Theme.panel(670, 96, 540, 340));

		bubbles = new FlxEmitter(BREW_CX - 70, 132, 50);
		bubbles.width = 140;
		bubbles.makeParticles(5, 5, FlxColor.WHITE, 50);
		bubbles.launchAngle.set(-100, -80);
		bubbles.speed.set(20, 55);
		bubbles.lifespan.set(0.6, 1.3);
		bubbles.alpha.set(0.8, 0.8, 0, 0);

		cauldron = new FlxSprite(BREW_CX - 120, 106, "assets/images/midnight-images/ui/cauldron.png");
		cauldron.antialiasing = true;
		add(cauldron);
		liquid = new FlxSprite(BREW_CX - 92, 126, "assets/images/midnight-images/ui/liquid.png");
		liquid.antialiasing = true;
		liquid.color = 0xFF6C7FB0;
		add(liquid);
		add(bubbles);
		bubbles.color.set(liquid.color, liquid.color);
		bubbles.start(false, 0.15);

		// the invisible "mouth" of the cauldron: thrown ingredients collide with it
		mouth = new FlxObject(BREW_CX - 85, 118, 170, 34);

		splash = new FlxEmitter(BREW_CX, 134, 40);
		splash.makeParticles(6, 6, FlxColor.WHITE, 40);
		splash.launchAngle.set(-160, -20);
		splash.speed.set(150, 320);
		splash.acceleration.set(0, 900);
		splash.lifespan.set(0.4, 0.8);
		splash.alpha.set(1, 1, 0, 0);
		add(splash);

		brewCards = new FlxTypedGroup<SlotCard>();
		add(brewCards);

		undoBtn = new UIButton(790, 364, 130, 50, "Undo", undo);
		serveBtn = new UIButton(936, 364, 190, 50, "Serve potion", serve, true);
		add(undoBtn);
		add(serveBtn);
	}

	function buildShelf():Void
	{
		for (i in 0...Ingredient.ALL.length)
		{
			var col = i % 4;
			var row = Std.int(i / 4);
			var b = new IngredientButton(60 + col * 290, 452 + row * 130, 280, 118, i, addIngredient);
			shelf.push(b);
			add(b);
		}
	}

	// ============================================================ difficulty

	function recipeLength():Int
		return Std.int(Math.min(7, 3 + Std.int(served / 3)));

	function peekTime(len:Int):Float
		return Math.max(1.5, 2.6 + len * 0.6 - served * 0.18);

	function patienceTime(len:Int):Float
		return Math.max(len * 1.4, 6 + len * 2.2 - served * 0.15);

	function makeRecipe(len:Int):Array<Int>
	{
		var allowRepeats = served >= 6;
		var r:Array<Int> = [];
		while (r.length < len)
		{
			var pick = FlxG.random.int(0, Ingredient.ALL.length - 1);
			if (!allowRepeats && r.contains(pick)) continue;
			if (r.length > 0 && r[r.length - 1] == pick) continue; // never the same twice in a row
			r.push(pick);
		}
		return r;
	}

	// ============================================================== flow

	function nextCustomer():Void
	{
		var len = recipeLength();
		recipe = makeRecipe(len);
		brew = [];
		customer = Customer.pick(customer);
		potion = FlxG.random.getObject(customer.potions);

		portrait.loadGraphic(Customer.portraitPath(customer));
		portrait.setGraphicSize(96, 96);
		portrait.updateHitbox();
		portrait.angle = 0;
		portrait.x = 40;
		portrait.alpha = 0;
		FlxTween.tween(portrait, {x: 86, alpha: 1}, 0.35, {ease: FlxEase.backOut});

		customerTitle.text = '${customer.name} wants $potion';
		quoteText.text = '"' + FlxG.random.getObject(customer.lines) + '"';
		quoteText.y = customerTitle.y + customerTitle.height + 4; // long names wrap to two lines

		buildCards(recipeCards, len, 66, 96, 74, 355, 238, true);
		buildCards(brewCards, len, 54, 62, 60, BREW_CX, 290, false);
		recipeCards.forEach(c -> c.setLook(SHOWN, recipe[recipeCards.members.indexOf(c)]));
		Theme.drawRounded(recipeBox, 0xFF3A2E1E, Theme.GOLD, 22, 3);

		liquidTo(0xFF6C7FB0);
		phase = PEEK;
		timerMax = peekTime(len);
		timer = timerMax;
		barFill.color = Theme.GOLD;
		hintText.text = "Memorize the recipe in order. Press " + (usingPad() ? "A" : "Space") + " when you've got it.";
		lastTick = -1;
		Settings.sfx("chime", 0.7);
		refreshButtons();
	}

	function buildCards(group:FlxTypedGroup<SlotCard>, count:Int, w:Int, h:Int, spacing:Int, centerX:Float, y:Float, showName:Bool):Void
	{
		group.forEach(c -> c.destroy());
		group.clear();
		var startX = centerX - (spacing * (count - 1) + w) / 2;
		for (i in 0...count)
			group.add(new SlotCard(startX + i * spacing, y, w, h, i + 1, showName));
	}

	function startBrew():Void
	{
		phase = BREW;
		recipeCards.forEach(c -> c.setLook(HIDDEN));
		Theme.drawRounded(recipeBox, 0x00000000, Theme.PANEL_LINE, 22, 2);
		timerMax = patienceTime(recipe.length);
		timer = timerMax;
		barFill.color = Theme.GOOD;
		hintText.text = usingPad() ? "D-pad picks, A adds, B undoes, Y serves." : (Controls.mouseEnabled() ? "Click ingredients or press 1-8 in order. Backspace undoes, Enter serves." : "Press 1-8 in order. Backspace undoes, Enter serves.");
		refreshButtons();
	}

	function addIngredient(i:Int):Void
	{
		if (phase != BREW) return;
		if (brew.length >= recipe.length)
		{
			Settings.sfx("nope");
			hintText.text = "The cauldron is full - serve it or undo.";
			return;
		}
		brew.push(i);
		brewCards.members[brew.length - 1].setLook(SHOWN, i);
		shelf[i].bump();
		throwIngredient(i);
		Settings.sfx("add");
		refreshButtons();
	}

	/** Launches an icon on a ballistic arc from the shelf into the cauldron. */
	function throwIngredient(i:Int):Void
	{
		var b = shelf[i];
		var f = flying.recycle(FlxSprite);
		f.loadGraphic(Ingredient.ALL[i].image);
		f.antialiasing = true;
		f.setGraphicSize(44, 44);
		f.updateHitbox();
		var sx = b.iconCenterX();
		var sy = b.iconCenterY();
		f.reset(sx - f.width / 2, sy - f.height / 2);
		var tx = mouth.x + mouth.width / 2;
		var ty = mouth.y + mouth.height / 2;
		f.acceleration.y = GRAVITY;
		f.velocity.x = (tx - sx) / FLIGHT_TIME;
		f.velocity.y = (ty - sy - 0.5 * GRAVITY * FLIGHT_TIME * FLIGHT_TIME) / FLIGHT_TIME;
		f.angularVelocity = FlxG.random.float(-360, 360);
		f.ID = i;
	}

	function onLand(f:FlxObject, m:FlxObject):Void
	{
		var s:FlxSprite = cast f;
		var ing = Ingredient.ALL[s.ID];
		s.kill();
		splash.x = s.x + s.width / 2;
		splash.color.set(ing.color, ing.color);
		splash.start(true, 0, 16);
		Settings.sfx("splash", 0.5);
		liquidTo(ing.color);
		FlxTween.cancelTweensOf(cauldron.scale);
		cauldron.scale.set(1.04, 0.97);
		FlxTween.tween(cauldron.scale, {x: 1, y: 1}, 0.3, {ease: FlxEase.elasticOut});
	}

	/** Only count the hit while the ingredient is falling into the pot, not on the way up. */
	function isFalling(f:FlxObject, m:FlxObject):Bool
		return f.velocity.y > 0;

	function liquidTo(c:FlxColor):Void
	{
		FlxTween.cancelTweensOf(liquid);
		var target = FlxColor.interpolate(liquid.color, c, 0.6);
		FlxTween.color(liquid, 0.4, liquid.color, target);
		bubbles.color.set(target, target);
	}

	function undo():Void
	{
		if (phase != BREW || brew.length == 0) return;
		brew.pop();
		brewCards.members[brew.length].setLook(EMPTY);
		Settings.sfx("undo");
		refreshButtons();
	}

	function serve():Void
	{
		if (phase != BREW) return;
		if (brew.length < recipe.length)
		{
			Settings.sfx("nope");
			FlxG.camera.shake(0.004, 0.15);
			hintText.text = 'This recipe needs ${recipe.length} ingredients - you have ${brew.length}.';
			return;
		}
		var correct = true;
		for (i in 0...recipe.length)
			if (recipe[i] != brew[i]) correct = false;

		if (correct) succeed();
		else fail("Wrong recipe", "The potion fizzled. That's a life gone.");
	}

	function succeed():Void
	{
		streak++;
		served++;
		if (streak > bestStreak) bestStreak = streak;
		var base = 50 * recipe.length;
		var speedBonus = Std.int(200 * (timer / timerMax));
		var mult = 1 + 0.1 * Math.min(streak - 1, 10);
		var points = Std.int(Math.round((base + speedBonus) * mult));
		score += points;

		var msg = 'The customer pays happily for $potion.';
		if (served % 5 == 0 && lives < MAX_LIVES)
		{
			lives++;
			msg += "\nThey leave a spare vial as a tip - life restored!";
		}
		Settings.sfx("success");
		FlxG.camera.flash(0x335FD08C, 0.25);
		refreshHud();
		showResult(true, "Perfect brew", msg, points, null, null);
	}

	function fail(title:String, msg:String):Void
	{
		streak = 0;
		lives--;
		Settings.sfx("fail");
		FlxG.camera.shake(0.01, 0.25);
		refreshHud();
		showResult(false, title, msg, 0, recipe.copy(), brew.copy());
	}

	function timeout():Void
	{
		fail("Out of patience", '${customer.name} storms out of the shop. That\'s a life gone.');
	}

	function showResult(good:Bool, title:String, msg:String, points:Int, wanted:Array<Int>, made:Array<Int>):Void
	{
		phase = WAITING;
		recipeCards.forEach(c -> c.setLook(SHOWN, recipe[recipeCards.members.indexOf(c)]));
		var last = lives <= 0;
		var sub = new ResultSubState(good, title, msg, points, wanted, made, last ? "Close up shop" : "Next customer");
		sub.closeCallback = () ->
		{
			Controls.strict = true;
			if (lives <= 0) gameOver();
			else nextCustomer();
		};
		openSubState(sub);
	}

	function gameOver():Void
	{
		RunStats.score = score;
		RunStats.served = served;
		RunStats.bestStreak = bestStreak;
		RunStats.newBest = score > Settings.highScore;
		if (RunStats.newBest)
		{
			Settings.highScore = score;
			Settings.persist();
		}
		FlxG.camera.fade(FlxColor.BLACK, 0.4, false, () -> FlxG.switchState(() -> new GameOverState()));
	}

	function openPause():Void
	{
		if (subState != null) return;
		var p = new PauseSubState();
		p.closeCallback = () ->
		{
			Controls.strict = true;
			FlxG.mouse.visible = Settings.inputMode == Settings.INPUT_MOUSE_KEYS;
			refreshHud();
			if (phase == BREW) startHintRefresh();
		};
		openSubState(p);
	}

	function startHintRefresh():Void
	{
		hintText.text = usingPad() ? "D-pad picks, A adds, B undoes, Y serves." : "Press 1-8 in order. Backspace undoes, Enter serves.";
	}

	function toggleMusic():Void
	{
		Settings.toggleMusic();
		refreshHud();
	}

	// ================================================================ HUD

	function usingPad():Bool
		return Settings.inputMode == Settings.INPUT_GAMEPAD;

	function refreshHud():Void
	{
		scoreText.text = 'Score $score';
		streakText.text = 'Streak $streak';
		for (i in 0...vials.length)
		{
			vials[i].loadGraphic(i < lives ? "assets/images/midnight-images/ui/vial_full.png" : "assets/images/midnight-images/ui/vial_empty.png");
			vials[i].alpha = i < lives ? 1 : 0.4;
		}
		musicBtn.setText(Settings.musicOn ? "Music on" : "Music off");
		for (b in shelf)
			b.focused = usingPad() && b.index == cursor;
	}

	function refreshButtons():Void
	{
		undoBtn.enabled = phase == BREW && brew.length > 0;
		serveBtn.enabled = phase == BREW && brew.length == recipe.length;
	}

	function updateBar():Void
	{
		var ratio = Math.max(0, timer / timerMax);
		barFill.scale.x = ratio;
		if (phase == BREW)
			barFill.color = ratio > 0.5 ? Theme.GOOD : (ratio > 0.25 ? 0xFFE8B84A : Theme.BAD);
	}

	// ============================================================= update

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		clock += elapsed;

		// physics: thrown ingredients collide with the cauldron mouth
		FlxG.overlap(flying, mouth, onLand, isFalling);
		flying.forEachAlive(f -> if (f.y > FlxG.height) f.kill());

		if (phase == WAITING) return;

		if (Controls.pause())
		{
			openPause();
			return;
		}
		if (Controls.music()) toggleMusic();

		timer -= elapsed;
		updateBar();

		switch (phase)
		{
			case PEEK:
				if (timer <= 0 || Controls.skipPeek()) startBrew();

			case BREW:
				var ratio = timer / timerMax;
				portrait.angle = ratio < 0.25 ? Math.sin(clock * 30) * 5 : 0;
				var secs = Math.ceil(timer);
				if (timer < 3 && secs != lastTick)
				{
					lastTick = secs;
					Settings.sfx("tick");
				}
				if (timer <= 0)
				{
					timeout();
					return;
				}
				handleBrewInput();

			case WAITING:
		}
	}

	function handleBrewInput():Void
	{
		var k = Controls.ingredientKey();
		if (k >= 0) addIngredient(k);
		if (Controls.undo()) undo();
		if (Controls.serve()) serve();

		var p = Controls.pad();
		if (p != null)
		{
			var moved = false;
			if (p.justPressed.DPAD_LEFT) { cursor = (cursor + 7) % 8; moved = true; }
			if (p.justPressed.DPAD_RIGHT) { cursor = (cursor + 1) % 8; moved = true; }
			if (p.justPressed.DPAD_UP || p.justPressed.DPAD_DOWN) { cursor = (cursor + 4) % 8; moved = true; }
			if (moved)
			{
				Settings.sfx("tick", 0.5);
				refreshHud();
			}
			if (Controls.padAdd()) addIngredient(cursor);
		}
	}
}
