package views.flipnfind;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import models.flipnfind.GameAssets;

// title screen of Flip n Find with one card for every level
class LevelSelectUI extends FlxGroup
{
	public var levelCards(default, null):Array<FlxSprite> = [];
	public var infoButton(default, null):FlxSprite;

	var highlight:Highlight;

	public function new(bestScores:Array<Int>, unlocked:Int)
	{
		super();

		add(new FlxSprite(0, 0, GameAssets.BACKGROUND));

		var title = new FlxText(0, 40, Viewport.WIDTH, "FLIP N FIND", 64);
		title.alignment = CENTER;
		title.color = FlxColor.YELLOW;
		title.setBorderStyle(OUTLINE, FlxColor.BLACK, 4);
		add(title);

		var total = 0;

		for (i in 0...bestScores.length)
		{
			var x = 292 + (i % 5) * 150;
			var y = 200 + Std.int(i / 5) * 220;

			var card = new FlxSprite(x, y);
			card.loadGraphic(GameAssets.CARDS, true, Card.WIDTH, Card.HEIGHT);
			card.scale.set(0.75, 0.75);
			card.updateHitbox();
			if (i < unlocked)
				card.animation.frameIndex = i + 1;
			else
				card.alpha = 0.4;
			levelCards.push(card);
			add(card);

			total += bestScores[i];

			var label = new FlxText(x - 20, y + 128, 136, "Level " + (i + 1) + "\nBest: " + bestScores[i], 16);
			label.alignment = CENTER;
			label.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
			add(label);
		}

		highlight = new Highlight(112, 136);
		add(highlight);
		select(0);

		var info = new FlxText(0, 640, Viewport.WIDTH,
			"Total best score: " + total + "\n\nArrows / D-pad to choose, ENTER / A / click to play, ESC / B to go back to the hub", 18);
		info.alignment = CENTER;
		info.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(info);

		infoButton = new FlxSprite(Viewport.WIDTH - 76, 10, GameAssets.INFO);
		add(infoButton);
	}

	public function select(level:Int)
	{
		highlight.setPosition(levelCards[level].x - 8, levelCards[level].y - 8);
	}
}
