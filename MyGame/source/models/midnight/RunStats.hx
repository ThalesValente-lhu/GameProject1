package models.midnight;

/** Results of the last run, passed from the play screen to the game over screen. */
class RunStats
{
	public static var score:Int = 0;
	public static var served:Int = 0;
	public static var bestStreak:Int = 0;
	public static var newBest:Bool = false;
}
