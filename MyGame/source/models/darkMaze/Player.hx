package models.darkMaze;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite{

	private var row:Int;
	private var column:Int;

	public function new(x:Float,y:Float,row:Int,column:Int){
		this.row = row;
		this.column = column;
		super(x,y);
		this.loadGraphic(AssetPaths.frontPlayer__png,true,32,36);
	}
	public function changeDirection(direction:String){
		switch (direction) {
			case "left":
				this.loadGraphic(AssetPaths.leftPlayerDark__png,true,32,36);
			case "right":
				this.loadGraphic(AssetPaths.rightPlayerDark__png,true,32,36);
			case "up":
				this.loadGraphic(AssetPaths.backPlayerDark__png,true,32,36);
			default:
				this.loadGraphic(AssetPaths.frontPlayerDark__png,true,32,36);
		}
	}

	public function getRow():Int{
		return this.row;
	}

	public function setRow(newRow:Int){
		this.row = newRow;
	}

	public function getCol():Int{
		return this.column;
	}

	public function setCol(newCol:Int){
		this.column = newCol;
	}

	public function lightsOut(check:Bool){
		if (check) {
			this.loadGraphic(AssetPaths.frontPlayerDark__png,true,32,36);
		}
		else{
			this.loadGraphic(AssetPaths.frontPlayer__png,true,32,36);
		}
	}
}