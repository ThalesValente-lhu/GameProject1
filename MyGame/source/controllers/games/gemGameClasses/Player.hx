package controllers.games.gemGameClasses;

import flixel.FlxSprite;
import flixel.FlxG;

class Player extends FlxSprite
{   
    var speed:Float = 100;
    var isMoving:Bool = false;
    public function new(x:Float, y:Float)
    {
        super(x, y);

        loadGraphic("assets/images/gemGame/player.png",true, 100, 100); //0 bis 5 idle, 6 bis 14 walk
        setSize(15, 25);
        offset.set(40, 40);
        animation.add("idle", [0, 1, 2, 3, 4, 5], 5, true);
        animation.add("walk", [6, 7, 8, 9, 10, 11, 12, 13, 14], 10, true);
        animation.play("idle");
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        isMoving = false;
        if (FlxG.keys.pressed.LEFT)
        {
            x -= speed * elapsed;
            flipX = true;
            isMoving = true;
        }
        if (FlxG.keys.pressed.RIGHT)
        {
            x += speed * elapsed;
            flipX = false;
            isMoving = true;
        }
        if (FlxG.keys.pressed.UP)
        {
            y -= speed * elapsed;
            isMoving = true;
        }
        if (FlxG.keys.pressed.DOWN)
        {
            y += speed * elapsed;
            isMoving = true;
        }
        if (!isMoving)
        {
            animation.play("idle");
        }
        else 
        {
            animation.play("walk");
        }
    }

}