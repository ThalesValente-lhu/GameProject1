package views.flipnfind;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import models.flipnfind.GameAssets;

// top bar (level, score, time, buttons) and the message shown at the end of a level
class PlayHUD extends FlxGroup
{
	public var homeButton(default, null):FlxSprite;
	public var infoButton(default, null):FlxSprite;

	var scoreText:FlxText;
	var timeText:FlxText;
	var messageBox:FlxSprite;
	var messageText:FlxText;

	public function new(level:Int)
	{
		super();

		var bar = new FlxSprite().makeGraphic(Viewport.WIDTH, 80, 0x88000000);
		add(bar);

		var levelText = new FlxText(20, 25, 200, "Level " + (level + 1), 28);
		levelText.color = FlxColor.YELLOW;
		add(levelText);

		scoreText = new FlxText(260, 25, 300, "", 28);
		add(scoreText);

		timeText = new FlxText(600, 25, 300, "", 28);
		add(timeText);

		homeButton = new FlxSprite(Viewport.WIDTH - 150, 8, GameAssets.HOME);
		add(homeButton);
		infoButton = new FlxSprite(Viewport.WIDTH - 76, 8, GameAssets.INFO);
		add(infoButton);

		messageBox = new FlxSprite().makeGraphic(700, 300, 0xdd000000);
		messageBox.setPosition((Viewport.WIDTH - messageBox.width) / 2, (Viewport.HEIGHT - messageBox.height) / 2);
		messageBox.visible = false;
		add(messageBox);

		messageText = new FlxText(0, messageBox.y + 40, Viewport.WIDTH, "", 24);
		messageText.alignment = CENTER;
		add(messageText);
	}

	public function setScore(score:Int)
	{
		scoreText.text = "Score: " + score;
	}

	public function setTime(seconds:Int)
	{
		timeText.text = "Time: " + seconds;
		if (seconds < 10)
			timeText.color = FlxColor.RED;
	}

	public function showWin(bonus:Int, score:Int, best:Int)
	{
		showMessage("LEVEL COMPLETE!\n\nTime bonus: " + bonus + "\nScore: " + score + "\nBest: " + best);
	}

	public function showTimeUp(score:Int, best:Int)
	{
		showMessage("TIME'S UP!\n\nScore: " + score + "\nBest: " + best);
	}

	function showMessage(text:String)
	{
		messageBox.visible = true;
		messageText.text = text + "\n\nENTER / A / click: back to levels\nR / X: try again";
	}
}
