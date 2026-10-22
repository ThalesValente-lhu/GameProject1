
package views.darkMaze;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import controllers.games.darkMaze.DarkMazeProgress;


class DarkMazeSelectState extends FlxState{

    override public function create():Void{
        super.create();

        var title = new FlxText(
            0, 30, FlxG.width,
            "Select a Level", 28
        );
        title.alignment = "center";
        add(title);

        var livesText = new FlxText(
            0, 70, FlxG.width,
            "Lives: " + DarkMazeProgress.lives, 18
        );
        livesText.alignment = "center";
        add(livesText);

        for (level in 1...(DarkMazeProgress.highestUnlockedLevel + 1)){
            var selectedLevel = level;

            var button = new FlxButton(
                FlxG.width / 2 - 45,
                120 + (level - 1) * 55,
                "Level " + level,
                function()
                {
                    DarkMazeProgress.currentLevel = selectedLevel;
                    FlxG.switchState(() -> new DarkMazeState());
                }
            );

            add(button);
        }
    }
}
