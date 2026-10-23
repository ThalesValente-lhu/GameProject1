package controllers.games.gemGameClasses;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class GemGameInitial extends FlxState
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

        var title = new FlxText(70, 50, FlxG.width - 140,"Gem Game",20);
        title.alignment = "center";
        title.color = FlxColor.YELLOW;
        add(title);

        var premise = new FlxText(80, 85, FlxG.width - 160,
            "Can you find the matching pairs?\n\n" +
            "Pick up a gem, memorize it and find its match, " +
            "the gems are scattered throughout the cave. " +
            "One mistake and you will have to find them again!",18
        );
        premise.alignment = "center";
        premise.color = FlxColor.WHITE;
        add(premise);

        var controlsTitle = new FlxText(90, 215, FlxG.width - 180,"CONTROLS",20);
        controlsTitle.alignment = "center";
        controlsTitle.color = FlxColor.YELLOW;
        add(controlsTitle);

        var controls = new FlxText(70, 255, FlxG.width - 100,
            "ARROW KEYS  -  Move up, down, left, and right\n\n" +
            "INTERACT    -  Press E to interact with a gem\n" +
            "                        Press R to return to menu\n" +
            "                        Press T to toggle a tutorial text in game\n\n" +
            "MEMORIZE    -  Look carefully at the gem before picking it up\n\n" +
            "OBJECTIVE   -  Find all the gem pairs in the cave\n\n" ,18);
        controls.color = FlxColor.WHITE;
        add(controls);

        var continueButton = new FlxButton(
            FlxG.width / 2 - 80,
            FlxG.height - 95,
            "Continue",
            function(){
                FlxG.switchState(() -> new GemGame());
            }
        );
        continueButton.setGraphicSize(150,40);
        continueButton.updateHitbox();
        continueButton.label.size = 20;
        continueButton.label.fieldWidth = 150;
        add(continueButton);
    }
}