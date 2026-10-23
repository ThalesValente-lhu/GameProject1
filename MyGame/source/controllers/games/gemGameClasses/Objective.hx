package controllers.games.gemGameClasses;

import flixel.FlxSprite;
import flixel.FlxG;

class Objective extends FlxSprite
{
    public var interacted:Bool = false;
    var pointX:Float;
    var pointY:Float;
    var widthGem:Array<Int>=[18, 23, 28, 20, 19, 24, 21, 26];
    var heightGem:Array<Int>=[30, 27, 28, 30, 22, 26, 25, 23];
    public var gemNum:Int;

    public function new(x:Float, y:Float, gemType:Int = 1)
    {
        pointX = x;
        pointY = y;
        gemNum = gemType - 1; // Adjust for index
        super(pointX, pointY);

        loadGraphic("assets/images/gemGame/gems/gem" + (gemNum + 1) + ".png", true, widthGem[gemNum], heightGem[gemNum]);
        switch (gemNum){
            case 0,1,5,7: //10 frames
                animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
            case 2,3,4: //11 frames
                animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 11, true);
            case 6: //16 frames
                animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 16, true);
        }
        scale.set(0.5, 0.5);
        animation.play("idle");
    }

    public function interact(last:Int):Int
    {   

        if(last == -1)
        { //pick up
            if (interacted) //already solved
                return 1;

            interacted = true;
            alpha = 0;
            FlxG.sound.play("assets/sounds/gemGame/pickup.ogg", 0.5);

            return 0;
        }
        else if (last == gemNum)
        { //right
            if (interacted)
                return 1;

            interacted = true;
            alpha = 0;
            FlxG.sound.play("assets/sounds/gemGame/success.ogg", 0.75);

            return 2;
        }
        else
        { //wrong
            FlxG.sound.play("assets/sounds/gemGame/failure.ogg", 1);
            return 3;
        }
    }

    public function resetObjective()
    {
        interacted = false;
        setPosition(pointX, pointY);
        alpha = 1;
    }
}
