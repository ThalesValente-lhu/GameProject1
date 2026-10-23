package controllers.games.gemGameClasses;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import openfl.utils.Assets;
import flixel.util.FlxDirectionFlags;

class Level extends FlxGroup
{  
    public var walls:FlxTilemap;
    public var obstacles:FlxTilemap;
    public var objectives:FlxTilemap;
    public var decorations:FlxTilemap;
    public var ground:FlxTilemap;
    public var positions:Array<Array<Int>>;
    public var gems:Array<Int> = [1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8];

    public function new()
    {
        super();
        var tiles = FlxTileFrames.fromGraphic(
            FlxG.bitmap.add("assets/images/gemGame/Caves.png"),
            FlxPoint.get(16, 16),
            null,
            FlxPoint.get(1, 1)
        );

        positions = [
			[30, 110],
			[160, 330],
			[400, 440],
			[445, 85],
            [205, 540],
            [80, 890],
            [335, 890],
            [110, 1130],
            [350, 1130],
            [655, 795],
            [890, 875],
            [1245, 700],
            [1485, 1035],
            [1630, 760],
            [1790, 670],
            [1600, 425]
		];

        // Load layers
        ground = loadLayer("Map1ground.csv", tiles);
        walls = loadLayer("Map1walls.csv", tiles);
        obstacles = loadLayer("Map1obstacles.csv", tiles);
        objectives = loadLayer("Map1objectives.csv", tiles);
        decorations = loadLayer("Map1Deco.csv", tiles);

        // Position the entire level
        var mapX = 0;//FlxG.width / 2;
        var mapY = 0;//FlxG.height / 2;

        ground.setPosition(mapX, mapY);
        walls.setPosition(mapX, mapY);
        obstacles.setPosition(mapX, mapY);
        objectives.setPosition(mapX, mapY);
        decorations.setPosition(mapX, mapY);

        // Draw order
        add(ground);
        add(walls);
        add(obstacles);
        add(objectives);
       // add(decorations);
    }

    private function loadLayer(filename:String, tiles:FlxTileFrames):FlxTilemap
    {
        var map = new FlxTilemap();

        map.loadMapFromCSV(Assets.getText("assets/data/gemGame/" + filename), tiles, 16, 16);

        return map;
    }
}