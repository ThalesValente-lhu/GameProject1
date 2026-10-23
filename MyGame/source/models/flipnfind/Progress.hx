package models.flipnfind;

import flixel.util.FlxSave;

// Best scores and unlocked levels. Flip n Find uses its own save file because
// FlxG.save is shared by every game in the hub.
class Progress
{
	static var save:FlxSave;

	static function data():Dynamic
	{
		if (save == null)
		{
			save = new FlxSave();
			save.bind("flipnfind");
			if (save.data.best == null)
			{
				save.data.best = [for (i in 0...Levels.all.length) 0];
				save.data.unlocked = 1;
			}
		}
		return save.data;
	}

	public static function best(level:Int):Int
	{
		// save data has no fixed type, so copy it into an Int before using it
		var best:Int = data().best[level];
		return best;
	}

	public static function bestScores():Array<Int>
	{
		return [for (i in 0...Levels.all.length) best(i)];
	}

	public static function unlocked():Int
	{
		var unlocked:Int = data().unlocked;
		return unlocked;
	}

	// saves the score if it is a new best, unlocks the next level and returns the best score
	public static function recordWin(level:Int, score:Int):Int
	{
		var best = best(level);
		if (score > best)
		{
			best = score;
			data().best[level] = score;
		}
		if (unlocked() < level + 2 && level < Levels.all.length - 1)
			data().unlocked = level + 2;
		save.flush();
		return best;
	}
}
