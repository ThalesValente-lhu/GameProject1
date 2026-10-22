
package views.darkMaze;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import controllers.games.darkMaze.DarkMazeProgress;


class DarkMazeSelectState extends FlxState{

    override public function create():Void{
        super.create();

        FlxG.sound.playMusic("assets/music/darkMaze/background.ogg",0.3,true);

        var background = new FlxSprite(0,0);
        background.loadGraphic(AssetPaths.darkMazeBackground__png,true,FlxG.width, FlxG.height);
        add(background);

        var title = new FlxText(
            0, 30, FlxG.width,
            "Select a Level", 40
        );
        title.alignment = "center";
        add(title);

        var livesText = new FlxText(
            0, 70, FlxG.width,
            "Lives: " + DarkMazeProgress.lives, 30
        );
        livesText.alignment = "center";
        add(livesText);

        var backButton = new FlxButton(
            20,
            30,
            "Back to other games",
            function(){
                FlxG.sound.music.stop();
                FlxG.switchState(()-> new controllers.MenuState());
            }
            );
        backButton.setGraphicSize(150,55);
        backButton.updateHitbox();
        backButton.label.size = 15;
        backButton.label.fieldWidth = 150;
        add(backButton);

        for (level in 1...(DarkMazeProgress.highestUnlockedLevel + 1)){
            var selectedLevel = level;

            var button = new FlxButton(
                FlxG.width / 2 - 55,
                120 + (level - 1) * 55,
                "Level " + level,
                function()
                {
                    DarkMazeProgress.currentLevel = selectedLevel;
                    FlxG.switchState(() -> new DarkMazeState());
                }
            );
            button.setGraphicSize(100,40);
            button.updateHitbox();
            button.label.size = 20;
            button.label.fieldWidth = 100;
            add(button);
        }
    }
}
