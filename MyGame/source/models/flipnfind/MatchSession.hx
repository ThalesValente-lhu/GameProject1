package models.flipnfind;

import flixel.FlxG;

// the deck, timer and score of one level
class MatchSession
{
	public static inline var ANIMALS = 30;
	public static inline var MATCH_POINTS = 100;
	public static inline var MISS_POINTS = 10;
	public static inline var BONUS_PER_SECOND = 10;

	public var level(default, null):Int;
	public var cols(default, null):Int;
	public var rows(default, null):Int;
	public var deck(default, null):Array<Int> = [];
	public var pairsLeft(default, null):Int;
	public var score(default, null) = 0;
	public var timeLeft(default, null):Float;

	public function new(level:Int)
	{
		this.level = level;
		var config = Levels.all[level];
		cols = config.cols;
		rows = config.rows;
		timeLeft = config.seconds;
		pairsLeft = Std.int(cols * rows / 2);

		// pick random animals, put two of each in the deck and shuffle it
		var animals = [for (i in 0...ANIMALS) i];
		FlxG.random.shuffle(animals);

		for (i in 0...pairsLeft)
		{
			deck.push(animals[i]);
			deck.push(animals[i]);
		}
		FlxG.random.shuffle(deck);
	}

	// returns true when the time runs out
	public function tick(elapsed:Float):Bool
	{
		timeLeft -= elapsed;
		if (timeLeft <= 0)
		{
			timeLeft = 0;
			return true;
		}
		return false;
	}

	// updates the score and returns true if the two cards are a pair
	public function checkPair(face1:Int, face2:Int):Bool
	{
		if (face1 == face2)
		{
			score += MATCH_POINTS;
			pairsLeft--;
			return true;
		}

		score -= MISS_POINTS;
		if (score < 0)
			score = 0;
		return false;
	}

	public function secondsLeft():Int
	{
		return Math.ceil(timeLeft);
	}

	// adds the time bonus to the score and returns it
	public function addTimeBonus():Int
	{
		var bonus = secondsLeft() * BONUS_PER_SECOND;
		score += bonus;
		return bonus;
	}
}
