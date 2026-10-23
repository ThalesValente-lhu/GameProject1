package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.util.FlxColor;

/** Rounded button that works with mouse hover/click and keyboard/gamepad focus. */
class UIButton extends FlxSpriteGroup
{
	public var bg:FlxSprite;
	public var label:FlxText;
	public var onClick:Void->Void;
	public var enabled(default, set):Bool = true;
	public var focused(default, set):Bool = false;

	var primary:Bool;
	var hovered:Bool = false;
	var w:Int;
	var h:Int;

	public function new(x:Float, y:Float, w:Int, h:Int, text:String, onClick:Void->Void, primary:Bool = false, fontSize:Int = 20)
	{
		super(x, y);
		this.w = w;
		this.h = h;
		this.primary = primary;
		this.onClick = onClick;

		bg = new FlxSprite(0, 0);
		bg.makeGraphic(w, h, FlxColor.TRANSPARENT, true);
		add(bg);

		label = Theme.text(0, 0, w, text, fontSize, primary ? Theme.DARK_TEXT : Theme.TEXT, true, FlxTextAlign.CENTER);
		label.y = (h - label.height) / 2; // relative: add() offsets by the group position
		add(label);
		redraw();
	}

	public function setText(t:String):Void
	{
		label.text = t;
	}

	function redraw():Void
	{
		var lit = (hovered || focused) && enabled;
		var fill:FlxColor = primary ? (lit ? Theme.GOLD_LIGHT : Theme.GOLD) : (lit ? 0xFF3A3166 : 0xFF2A2348);
		var line:FlxColor = lit ? Theme.GOLD_LIGHT : (primary ? Theme.GOLD : Theme.PANEL_LINE);
		Theme.drawRounded(bg, fill, line, h * 0.6, lit ? 3 : 2);
		alpha = enabled ? 1 : 0.45;
	}

	function set_enabled(v:Bool):Bool
	{
		enabled = v;
		if (bg != null) redraw();
		return v;
	}

	function set_focused(v:Bool):Bool
	{
		if (focused != v)
		{
			focused = v;
			if (bg != null) redraw();
		}
		return v;
	}

	public function press():Void
	{
		if (!enabled || !visible) return;
		Settings.sfx("click");
		if (onClick != null) onClick();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (!visible) return;
		var over = Controls.mouseEnabled() && FlxG.mouse.visible && FlxG.mouse.overlaps(bg);
		if (over != hovered)
		{
			hovered = over;
			redraw();
		}
		if (over && FlxG.mouse.justPressed) press();
	}
}
