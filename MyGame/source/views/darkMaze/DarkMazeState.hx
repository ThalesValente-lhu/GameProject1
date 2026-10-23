package views.darkMaze;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import openfl.utils.Assets;
import flixel.util.FlxSpriteUtil;

import models.darkMaze.Tile;
import models.darkMaze.GameMap;
import models.darkMaze.Player;
import models.darkMaze.LevelData;

import controllers.games.darkMaze.DarkMazeProgress;

//Phases of the level
enum Phase{
    MEMORIZE;
    PLAY;
    RESULT;
    GAME_OVER;
}

class DarkMazeState extends FlxState{

	//Map variables
	private var TILE_SIZE:Int = 70;
	private var allTiles:Array<Tile>;
	private var exitTile:Tile;
	private var map:GameMap;
	private var startPlayerX:Float;
	private var startPlayerY:Float;

	//Player
	private var player:Player;
	private var playerWon:Bool = false;

	//Controle of phases
	private var phase:Phase;
	private var previewDuration:Float = 5.0;
	private var playDuration:Float = 10.0;
	private var darkness:FlxSprite;
 
	//Timer and texts
	private var timer:Float = 0.0;
	private var timerText:FlxText;
	private var livesText:FlxText;

	// Result screen duration
	private var resultDuration:Float = 3.0;

	//Buttons
	private var nextLevelButton:FlxButton;
	private var menuButton:FlxButton;


	override public function create(){
		super.create();

		var background = new FlxSprite(0,0);
		background.loadGraphic(AssetPaths.darkMazeBackground__png,true,FlxG.width, FlxG.height);
		add(background);

		allTiles = [];
		map = LevelData.getMap(DarkMazeProgress.currentLevel);

		var mapWidth = map.data[0].length * TILE_SIZE
	    	+ (map.data[0].length - 1) * 5;

		var mapHeight = map.data.length * TILE_SIZE
		    + (map.data.length - 1) * 5;

		startPlayerX = (FlxG.width - mapWidth) / 2;
		startPlayerY = (FlxG.height - mapHeight) / 2 + 20;

		var darknessBack = new FlxSprite((FlxG.width - mapWidth) / 2, (FlxG.height - mapHeight) / 2 + 20);
		darknessBack.makeGraphic(mapWidth, mapHeight, FlxColor.BLACK);
		add(darknessBack);

		createMapBorder();

		for (row in 0...map.data.length) {
			for (col in 0...map.data[row].length) {
				var startX = col*(TILE_SIZE+5) + startPlayerX;
				var startY = row*(TILE_SIZE+5) + startPlayerY;

				var tileType = map.data[row][col];
				var canWalk = tileType != 0;

				var tile = new Tile(startX,startY,row,col,TILE_SIZE,canWalk);

				if (tileType == 2) {
					tile.makeExit();
					exitTile = tile;
					allTiles.push(exitTile);
					add(exitTile);
				}
				else{
					allTiles.push(tile);
					add(tile);
				}
			}
		}

		darkness = new FlxSprite((FlxG.width - mapWidth) / 2, (FlxG.height - mapHeight) / 2 + 20);
		darkness.makeGraphic(mapWidth, mapHeight, FlxColor.BLACK);
		darkness.visible = false;
		add(darkness);

		timerText = new FlxText(10, 20, 400, "", 20);
		add(timerText);
		livesText = new FlxText(10, 40, 400, "", 20);
		add(livesText);
		updateLivesText();

		player = new Player(0,0,0,0);
		add(player);
		centerPlayer(0,0);

		nextLevelButton = new FlxButton(300, 10, "Next Level", goToNextLevel);
		nextLevelButton.visible = false;
		nextLevelButton.setGraphicSize(150,25);
        nextLevelButton.updateHitbox();
        nextLevelButton.label.size = 15;
        nextLevelButton.label.fieldWidth = 150;
		add(nextLevelButton);

		menuButton = new FlxButton(400, 10, "Level Select", returnToMenu);
		menuButton.visible = false;
		menuButton.setGraphicSize(150,25);
        menuButton.updateHitbox();
        menuButton.label.size = 15;
        menuButton.label.fieldWidth = 150;
		add(menuButton);

		timer = previewDuration;
		phase = MEMORIZE;
	}

	override public function update(elapsed:Float){
		super.update(elapsed);

		switch (phase) {
			case MEMORIZE:
				timer -= elapsed;
				timerText.text = "Memorize: " + Math.ceil(timer);
				if (timer <= 0){
	                phase = PLAY;
	                timer = playDuration;
	                darkness.visible = true;
	                player.lightsOut(true);
	            }
	        case PLAY:
				timer -= elapsed;
				timerText.text = "Time: " + Math.ceil(timer);

				if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A) {
					player.changeDirection("left");
					movePlayerTo(player.getRow(), player.getCol()-1);
				}
				else if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D) {
					player.changeDirection("right");
					movePlayerTo(player.getRow(), player.getCol()+1);
				}
				else if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W) {
					player.changeDirection("up");
					movePlayerTo(player.getRow()-1, player.getCol());
				}
				else if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S) {
					player.changeDirection("down");
					movePlayerTo(player.getRow()+1, player.getCol());
				}

				if (isExit()){
	                checkState(true);
	                player.lightsOut(false);
	            }
	            else if(isPit() || timer <= 0){
	            	checkState(false);
	            	player.lightsOut(false);
	            }

	            case RESULT:
		            if (timer > 0){
		                timer -= elapsed;
		            }

		            if (timer <= 0 && DarkMazeProgress.lives > 0 && !playerWon){
		                restart();
		            }

	            case GAME_OVER:
	            	timerText.text = "Game Over";
	            	timer -= elapsed;
				    if (timer <= 0){
				        FlxG.switchState(() -> new DarkMazeSelectState());
				    }

		}
	}


	private function movePlayerTo(newRow:Int, newCol:Int){
		//Checks the boundaries and if is walkable
	    if ((newRow < 0 || newRow >= map.data.length) || (newCol < 0 || newCol >= map.data[newRow].length)){
	        return;
	    }

	    player.setRow(newRow);
	    player.setCol(newCol);
	    FlxG.sound.play(AssetPaths.step__ogg, 0.5);
	    centerPlayer(newRow,newCol);
	}

	private function isExit():Bool{
		if (player.getRow()==exitTile.row && player.getCol() == exitTile.col) {
			FlxG.sound.play(AssetPaths.win__ogg, 0.5);
			return true;
		}
		return false;
	}

	private function isPit():Bool{
		if (map.data[player.getRow()][player.getCol()] == 0) {
			return true;
		}
		return false;
	}

	private function updateLivesText():Void{
	    livesText.text = "Lives: " + DarkMazeProgress.lives;
	}

	private function checkState(won:Bool):Void{

	    if (phase != PLAY){
	        return;
	    }

	    playerWon = won;
	    darkness.visible = false;
	    phase = RESULT;
	    timer = resultDuration;

	    nextLevelButton.visible = false;
    	menuButton.visible = false;

	    if (won){
	        timerText.text = "Level "+DarkMazeProgress.currentLevel+" complete!";
	        DarkMazeProgress.completeLevel();

	        if(DarkMazeProgress.currentLevel < LevelData.LEVEL_COUNT){
	        	nextLevelButton.visible = true;
	        }
	        else{
	        	timerText.text = "All levels completed!";
            	menuButton.visible = true;
	        }
	    }
	    else{
	        DarkMazeProgress.lives--;
	        updateLivesText();

	        if (DarkMazeProgress.lives <= 0){
	            phase = GAME_OVER;
	            timerText.text = "Game Over!";
	            DarkMazeProgress.resetProgress();
	            livesText.visible = false;
	            menuButton.visible = true;
	            timer = 5;
	        }
	        else{
	            timerText.text = "Failed! Lives remaining: " + DarkMazeProgress.lives;
	        }
	    }
	}

	private function restart():Void{
	    player.setRow(0);
	    player.setCol(0);
	    player.lightsOut(false);
	    centerPlayer(0,0);

	    darkness.visible = false;
	    nextLevelButton.visible = false;
	    menuButton.visible = false;
	    livesText.visible = true;
	    playerWon = false;

	    timer = previewDuration;
	    phase = MEMORIZE;

	    timerText.text = "";
	}

	private function goToNextLevel():Void{
	    if (DarkMazeProgress.currentLevel < LevelData.LEVEL_COUNT){
	        DarkMazeProgress.currentLevel++;
	        FlxG.switchState(() -> new DarkMazeState());
	    }
	    else{
	        returnToMenu();
	    }
	}

	private function returnToMenu():Void{
	    FlxG.switchState(() -> new DarkMazeSelectState());
	}

	private function centerPlayer(row:Int, col:Int):Void{
	    var tileX = startPlayerX + col * (TILE_SIZE + 5);
	    var tileY = startPlayerY + row * (TILE_SIZE + 5);

	    player.x = tileX + (TILE_SIZE - player.width) / 2;
	    player.y = tileY + (TILE_SIZE - player.height) / 2;
	}

	private function createMapBorder():Void{
	    var mapWidth = map.data[0].length * TILE_SIZE
	        + (map.data[0].length - 1) * 5;

	    var mapHeight = map.data.length * TILE_SIZE
	        + (map.data.length - 1) * 5;

	    var padding = 5;
	    var border = new FlxSprite(
	        startPlayerX - padding,
	        startPlayerY - padding
	    );

	    border.makeGraphic(
	        Std.int(mapWidth + padding * 2),
	        Std.int(mapHeight + padding * 2),
	        FlxColor.TRANSPARENT
	    );

	    FlxSpriteUtil.drawRoundRect(
	        border,
	        0,
	        0,
	        border.width,
	        border.height,
	        18,
	        18,
	        FlxColor.TRANSPARENT,
	        {
	            color: FlxColor.WHITE,
	            thickness: 3
	        }
	    );

	    add(border);
	}
}
