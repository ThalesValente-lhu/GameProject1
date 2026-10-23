package views.flipnfind;

import flixel.group.FlxGroup;

// the table with the cards of one level and the frame around the selected card
class BoardView extends FlxGroup
{
	public var cards(default, null):Array<Card> = [];

	var cols:Int;
	var cellWidth:Float;
	var cellHeight:Float;
	var startX:Float;
	var startY:Float;
	var highlight:Highlight;

	public function new(cols:Int, rows:Int, deck:Array<Int>)
	{
		super();
		this.cols = cols;

		add(Viewport.background());

		// bigger levels use smaller cards so everything fits on the screen
		var size = Math.min(1, 600 / (rows * 172));
		cellWidth = 140 * size;
		cellHeight = 172 * size;
		startX = (Viewport.WIDTH - cols * cellWidth) / 2;
		startY = 100 + (610 - rows * cellHeight) / 2;

		for (i in 0...deck.length)
		{
			var x = startX + (i % cols) * cellWidth + 6 * size;
			var y = startY + Std.int(i / cols) * cellHeight + 6 * size;
			var card = new Card(x, y, deck[i], size);
			cards.push(card);
			add(card);
		}

		highlight = new Highlight(cellWidth + 4, cellHeight + 4);
		add(highlight);
		select(0);
	}

	public function select(index:Int)
	{
		highlight.x = startX + (index % cols) * cellWidth - 2;
		highlight.y = startY + Std.int(index / cols) * cellHeight - 2;
	}

	public function hideHighlight()
	{
		highlight.visible = false;
	}

	public function flipAll()
	{
		for (card in cards)
			card.flip();
	}
}
