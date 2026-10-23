package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.util.FlxColor;

enum SlotLook
{
	EMPTY; // dashed placeholder waiting for an ingredient
	HIDDEN; // "?" - recipe step the player must remember
	SHOWN; // ingredient visible
}

/** A numbered card that shows one step of a recipe (or of the brew in the cauldron). */
class SlotCard extends FlxSpriteGroup
{
	public var bg:FlxSprite;

	var icon:FlxSprite;
	var num:FlxText;
	var nameText:FlxText;
	var question:FlxText;
	var w:Int;
	var h:Int;
	var showName:Bool;

	public function new(x:Float, y:Float, w:Int, h:Int, number:Int, showName:Bool)
	{
		super(x, y);
		this.w = w;
		this.h = h;
		this.showName = showName;

		bg = new FlxSprite(0, 0); // relative to group until added
		bg.makeGraphic(w, h, FlxColor.TRANSPARENT, true);
		add(bg);

		num = Theme.text(0, 4, w, Std.string(number), 13, Theme.GOLD, true, FlxTextAlign.CENTER);
		add(num);

		icon = new FlxSprite(0, 0);
		icon.antialiasing = true;
		icon.visible = false;
		add(icon);

		nameText = Theme.text(-6, h - 20, w + 12, "", 11, Theme.TEXT, false, FlxTextAlign.CENTER);
		add(nameText);

		question = Theme.text(0, h / 2 - 18, w, "?", 30, Theme.MUTED, true, FlxTextAlign.CENTER);
		add(question);

		setLook(EMPTY);
	}

	public function setLook(look:SlotLook, ingredientIndex:Int = -1, ?highlight:FlxColor):Void
	{
		icon.visible = false;
		nameText.text = "";
		question.visible = false;
		switch (look)
		{
			case EMPTY:
				Theme.drawRounded(bg, 0x00000000, Theme.PANEL_LINE, 14, 2);
			case HIDDEN:
				Theme.drawRounded(bg, 0xFF241E44, Theme.PANEL_LINE, 14, 2);
				question.visible = true;
			case SHOWN:
				var ing = Ingredient.ALL[ingredientIndex];
				Theme.drawRounded(bg, 0xFF2A2348, highlight != null ? highlight : Theme.GOLD, 14, highlight != null ? 3 : 2);
				icon.loadGraphic(ing.image);
				var size = Std.int(Math.min(w - 14, h - (showName ? 40 : 26)));
				icon.setGraphicSize(size, size);
				icon.updateHitbox();
				icon.setPosition(x + (w - icon.width) / 2, y + 20);
				icon.visible = true;
				if (showName) nameText.text = ing.name;
		}
	}
}
