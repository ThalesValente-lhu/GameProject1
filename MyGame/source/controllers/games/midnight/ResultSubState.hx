package controllers.games.midnight;

import views.midnight.SlotCard;
import views.midnight.SlotCard.SlotLook;
import views.midnight.Theme;
import views.midnight.UIButton;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText.FlxTextAlign;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/** Popup after each customer: perfect brew, wrong recipe, or out of patience. */
class ResultSubState extends FlxSubState
{
	var good:Bool;
	var titleStr:String;
	var message:String;
	var points:Int;
	var wanted:Array<Int>;
	var made:Array<Int>;
	var buttonText:String;
	var button:UIButton;
	var inputDelay:Float = 0.35; // stops the Enter that served the potion from also closing this

	public function new(good:Bool, title:String, message:String, points:Int, wanted:Array<Int>, made:Array<Int>, buttonText:String)
	{
		super();
		this.good = good;
		this.titleStr = title;
		this.message = message;
		this.points = points;
		this.wanted = wanted;
		this.made = made;
		this.buttonText = buttonText;
	}

	override public function create():Void
	{
		super.create();
		Controls.strict = false;

		var dim = new FlxSprite(0, 0);
		dim.makeGraphic(FlxG.width, FlxG.height, 0xB00A0816);
		add(dim);

		var hasRows = wanted != null;
		var w = 680;
		var h = hasRows ? 420 : 300;
		var px = (FlxG.width - w) / 2;
		var py = (FlxG.height - h) / 2;
		var all:Array<FlxSprite> = [];

		var panel = Theme.panel(px, py, w, h, 0xFF221C40, Theme.PANEL_LINE, 32);
		all.push(panel);
		all.push(Theme.title(px + 40, py + 28, w - 80, titleStr, 40));
		var msg = Theme.text(px + 40, py + 96, w - 80, message, 20, good ? Theme.TEXT : Theme.BAD, !good);
		all.push(msg);

		var y = py + 96 + msg.height + 16;
		if (good)
		{
			all.push(Theme.text(px + 40, y, w - 80, '+$points points', 26, Theme.GOOD, true));
		}
		else if (hasRows)
		{
			all.push(Theme.text(px + 40, y + 20, 130, "Wanted", 19));
			for (i in 0...wanted.length)
			{
				var c = new SlotCard(px + 180 + i * 62, y, 54, 62, i + 1, false);
				c.setLook(SHOWN, wanted[i]);
				all.push(c);
			}
			y += 80;
			all.push(Theme.text(px + 40, y + 20, 130, "You made", 19));
			for (i in 0...made.length)
			{
				var c = new SlotCard(px + 180 + i * 62, y, 54, 62, i + 1, false);
				c.setLook(SHOWN, made[i], made[i] == wanted[i] ? Theme.GOOD : Theme.BAD);
				all.push(c);
			}
			if (made.length == 0) all.push(Theme.text(px + 180, y + 20, 300, "(nothing)", 19, Theme.MUTED));
		}

		button = new UIButton(px + 40, py + h - 90, w - 80, 60, buttonText, finish, true, 22);
		button.focused = true;
		all.push(button);

		for (s in all)
		{
			add(s);
			var targetY = s.y;
			s.y += 30;
			s.alpha = 0;
			FlxTween.tween(s, {y: targetY, alpha: 1}, 0.25, {ease: FlxEase.quadOut});
		}
	}

	function finish():Void
	{
		close();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (inputDelay > 0)
		{
			inputDelay -= elapsed;
			return;
		}
		if (Controls.confirm()) button.press();
	}
}
