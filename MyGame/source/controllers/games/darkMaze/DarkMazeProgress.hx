
package controllers.games.darkMaze;

import models.darkMaze.LevelData;

class DarkMazeProgress{
    
    public static inline var MAX_LIVES:Int = 3;

    public static var lives:Int = MAX_LIVES;
    public static var currentLevel:Int = 1;
    public static var highestUnlockedLevel:Int = 1;

    public static function resetProgress():Void{
        lives = MAX_LIVES;
        currentLevel = 1;
        highestUnlockedLevel = 1;
    }

    public static function completeLevel():Void{
        if (currentLevel >= highestUnlockedLevel && currentLevel < LevelData.LEVEL_COUNT){
            highestUnlockedLevel = currentLevel + 1;
        }
    }
}
