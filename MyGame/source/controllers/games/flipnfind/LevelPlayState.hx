package controllers.games.flipnfind;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxTimer;
import models.flipnfind.GameAssets;
import models.flipnfind.MatchSession;
import models.flipnfind.Progress;
import views.flipnfind.BoardView;
import views.flipnfind.Card;
import views.flipnfind.PlayHUD;
import views.flipnfind.Viewport;

class LevelPlayState extends FlxState
{
	// how long all the cards are shown at the start, and how long a pair stays open
	static inline var PEEK_SECONDS = 2;
	static inline var PAIR_SECONDS = 0.6;

	var level:Int;
	var session:MatchSession;
	var board:BoardView;
	var hud:PlayHUD;

	var selected = 0;
	var firstCard:Card = null;
	var secondCard:Card = null;
	var gameOver = false;
	var peeking = true;

	public function new(level:Int)
	{
		super();
		this.level = level;
	}

	override public function create()
	{
		super.create();

		Viewport.setup();

		session = new MatchSession(level);

		board = new BoardView(session.cols, session.rows, session.deck);
		add(board);

		hud = new PlayHUD(level);
		hud.setScore(session.score);
		hud.setTime(session.secondsLeft());
		add(hud);

		// show all the cards at the start so the player can memorize them
		board.flipAll();
		new FlxTimer().start(PEEK_SECONDS, hideCards);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Input.rules() || Input.clicked(hud.infoButton))
		{
			openSubState(new RulesSubState());
			return;
		}
		if (Input.clicked(hud.homeButton) || Input.back())
		{
			backToLevels();
			return;
		}

		if (gameOver)
		{
			if (Input.select() || Input.mousePressed())
				backToLevels();
			else if (Input.retry())
				FlxG.resetState();
			return;
		}

		if (peeking)
			return;

		if (session.tick(elapsed))
			endLevel(false);

		moveCursor();

		// wait until the last two cards are checked before flipping more
		if (secondCard == null)
		{
			if (Input.select())
				flipCard(board.cards[selected]);

			if (Input.mousePressed())
			{
				for (i in 0...board.cards.length)
				{
					if (Input.hovered(board.cards[i]) && !board.cards[i].matched)
					{
						selected = i;
						flipCard(board.cards[i]);
					}
				}
			}
		}

		hud.setScore(session.score);
		hud.setTime(session.secondsLeft());
	}

	function moveCursor()
	{
		var col = selected % session.cols;
		var row = Std.int(selected / session.cols);

		if (Input.left() && col > 0)
			col--;
		if (Input.right() && col < session.cols - 1)
			col++;
		if (Input.up() && row > 0)
			row--;
		if (Input.down() && row < session.rows - 1)
			row++;
		selected = row * session.cols + col;

		if (Input.mouseMoved())
		{
			for (i in 0...board.cards.length)
			{
				if (Input.hovered(board.cards[i]) && !board.cards[i].matched)
					selected = i;
			}
		}

		board.select(selected);
	}

	function hideCards(timer:FlxTimer)
	{
		board.flipAll();
		FlxG.sound.play(GameAssets.FLIP);
		peeking = false;
	}

	function flipCard(card:Card)
	{
		if (card.isOpen)
			return;

		card.flip();
		FlxG.sound.play(GameAssets.FLIP);

		if (firstCard == null)
		{
			firstCard = card;
		}
		else
		{
			secondCard = card;
			new FlxTimer().start(PAIR_SECONDS, checkPair);
		}
	}

	function checkPair(timer:FlxTimer)
	{
		if (gameOver)
			return;

		if (session.checkPair(firstCard.face, secondCard.face))
		{
			firstCard.fall();
			secondCard.fall();
			FlxG.sound.play(GameAssets.MATCH);
		}
		else
		{
			firstCard.flip();
			secondCard.flip();
			FlxG.sound.play(GameAssets.MISS);
			FlxG.camera.shake(0.005, 0.2);
		}

		firstCard = null;
		secondCard = null;

		if (session.pairsLeft == 0)
			endLevel(true);
	}

	function endLevel(win:Bool)
	{
		gameOver = true;
		board.hideHighlight();

		if (win)
		{
			var bonus = session.addTimeBonus();
			var best = Progress.recordWin(level, session.score);
			FlxG.sound.play(GameAssets.WIN);
			hud.showWin(bonus, session.score, best);
		}
		else
		{
			FlxG.sound.play(GameAssets.LOSE);
			hud.showTimeUp(session.score, Progress.best(level));
		}

		hud.setScore(session.score);
		hud.setTime(session.secondsLeft());
	}

	function backToLevels()
	{
		FlxG.switchState(LevelSelectState.new);
	}
}
