
package views.darkMaze;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class DarkMazeInitialState extends FlxState
{
    override public function create():Void
    {
        super.create();

        var background = new FlxSprite(0, 0);
        background.makeGraphic(FlxG.width,FlxG.height,FlxColor.fromRGB(20, 24, 35));
        add(background);

        var panel = new FlxSprite(50, 35);
        panel.makeGraphic(FlxG.width - 100,FlxG.height - 70,FlxColor.fromRGB(40, 46, 62));
        add(panel);

        var title = new FlxText(70, 50, FlxG.width - 140,"DARK MAZE",16);
        title.alignment = "center";
        title.color = FlxColor.YELLOW;
        add(title);

        var premise = new FlxText(80, 85, FlxG.width - 160,
            "Can you escape the darkness?\n\n" +
            "Memorize the bridge before the lights go out. " +
            "Then find your way to the exit using your memory. " +
            "One wrong step can send you into a pit!",12
        );
        premise.alignment = "center";
        premise.color = FlxColor.WHITE;
        add(premise);

        var controlsTitle = new FlxText(90, 205, FlxG.width - 180,"CONTROLS",12);
        controlsTitle.alignment = "center";
        controlsTitle.color = FlxColor.YELLOW;
        add(controlsTitle);

        var controls = new FlxText(70, 225, FlxG.width - 100,
            "ARROW KEYS  -  Move up, down, left, and right\n\n" +
            "MEMORIZE    -  Study the safe path before darkness\n\n" +
            "OBJECTIVE   -  Reach the exit without falling\n\n" +
            "LIVES       -  You have 3 lives. Lose them all and\n" +
            "                   your progress resets to Level 1.",12);
        controls.color = FlxColor.WHITE;
        add(controls);

        var continueButton = new FlxButton(
            FlxG.width / 2 - 60,
            FlxG.height - 95,
            "Continue",
            function(){
                FlxG.switchState(() -> new DarkMazeSelectState());
            }
        );
        add(continueButton);
    }
}
