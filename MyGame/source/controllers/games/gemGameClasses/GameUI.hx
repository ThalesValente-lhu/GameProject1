package controllers.games.gemGameClasses;

import haxe.rtti.CType.Abstractdef;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxG;

class GameUI extends FlxGroup
{
    var objectiveText:FlxText;
    public var winText:FlxText;
    public var tutorialText:FlxText;

    public function new()
    {
        super();

        objectiveText = new FlxText(20, 30, 0, "Objectives: 0/4", 16);
        //objectiveText.scrollFactor.set(0, 0);
        add(objectiveText);

        winText = new FlxText(200, 150, 0, "You WIN!!!", 45);
        winText.alpha = 0;
        add(winText);
        tutorialText = new FlxText(10, 50, 0, "1.Use Arrow Keys to Move\n2.Press E to pick up a nearby gem \n3.Find the same kind of gem in the world and \ninteract with it to collect a pair\n4.If you interact with the wrong gem \nyou will have to pick up a gem again\n5.Press R to return to the menu\n6.Press T to toggle the tutorial text", 16);
        add(tutorialText);
    }

    public function setObjectiveCount(current:Int, total:Float)
    {
        objectiveText.text = "Objectives: " + current + "/" + total;
    }
}