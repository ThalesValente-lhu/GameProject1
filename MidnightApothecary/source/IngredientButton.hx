package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/** One shelf tile: key number, icon and name. Click it, press its number, or select with a gamepad. */
class IngredientButton extends FlxSpriteGroup
{
	public var index(default, null):Int;
	public var bg:FlxSprite;
	public var icon:FlxSprite;
	public var focused(default, set):Bool = false;
	public var onPick:Int->Void;

	var hovered = false;
	var w:Int;
	var h:Int;

	public function new(x:Float, y:Float, w:Int, h:Int, index:Int, onPick:Int->Void)
	{
		super(x, y);
		this.index = index;
		this.w = w;
		this.h = h;
		this.onPick = onPick;
		var ing = Ingredient.ALL[index];

		bg = new FlxSprite(0, 0); // children use coordinates relative to the group
		bg.makeGraphic(w, h, FlxColor.TRANSPARENT, true);
		add(bg);

		add(Theme.text(16, 10, 40, Std.string(index + 1), 20, Theme.MUTED, true));

		icon = new FlxSprite(0, 0, ing.image);
		icon.setGraphicSize(56, 56);
		icon.updateHitbox();
		icon.antialiasing = true;
		icon.setPosition((w - icon.width) / 2, 14);
		add(icon);

		add(Theme.text(0, h - 34, w, ing.name, 18, Theme.TEXT, false, FlxTextAlign.CENTER));
		redraw();
	}

	/** Centre of the icon, used as the launch point for the flying ingredient. */
	public function iconCenterX():Float
		return icon.x + icon.width / 2;

	public function iconCenterY():Float
		return icon.y + icon.height / 2;

	function redraw():Void
	{
		var lit = hovered || focused;
		Theme.drawRounded(bg, lit ? 0xFF2C2552 : 0xFF1E1938, lit ? Theme.GOLD : Theme.PANEL_LINE, 24, lit ? 3 : 2);
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

	/** Little squash animation as feedback. */
	public function bump():Void
	{
		FlxTween.cancelTweensOf(icon.scale);
		var s = icon.scale.x;
		icon.scale.set(s * 1.25, s * 0.8);
		FlxTween.tween(icon.scale, {x: s, y: s}, 0.25, {ease: FlxEase.backOut});
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		var over = Controls.mouseEnabled() && FlxG.mouse.visible && FlxG.mouse.overlaps(bg);
		if (over != hovered)
		{
			hovered = over;
			redraw();
		}
		if (over && FlxG.mouse.justPressed && onPick != null) onPick(index);
	}
}
