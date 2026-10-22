package models.darkMaze;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Tile extends FlxSprite{

    public var size:Int;
    public var row:Int;
    public var col:Int;
    public var canWalk:Bool;

    public function new(x:Float, y:Float,row:Int,col:Int, size:Int, canWalk:Bool){
        super(x, y);
        this.size = size;
        this.row = row;
        this.col = col;

        this.canWalk = canWalk;

        if (canWalk){
            this.loadGraphic(AssetPaths.tile2__png);
            setGraphicSize(size, size);
            updateHitbox();
        }
        else{
            this.makeGraphic(size,size,FlxColor.BLACK);
            this.visible = false;
        }
    }

    public function isWalkable():Bool{
        return canWalk;
    }

    public function makeExit(){
        this.loadGraphic(AssetPaths.exit__png);
        setGraphicSize(size, size);
        updateHitbox();
    }
}