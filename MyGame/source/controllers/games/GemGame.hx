package controllers.games;

import flixel.FlxState;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.util.FlxTimer;

import controllers.games.gemGameClasses.GameUI;
import controllers.games.gemGameClasses.Level;
import controllers.games.gemGameClasses.Objective;
import controllers.games.gemGameClasses.Player;
import controllers.MenuState;

class GemGame extends FlxState
{	
	var level:Level;
	var player:Player;
	var ui:GameUI;
	var lastObjectiveInteracted:Int = -1;
	var objectives:Array<Objective> = [];
	var usedNumbers:Array<Int> = [];
	var currentObjectiveCount:Int = 0;
	var totalObjectivesPair:Float;
	
    override public function create()
    {
        super.create();
		FlxG.sound.playMusic("assets/sounds/gemGame/music.ogg", 0.25);
		FlxG.camera.pixelPerfectRender = true;

        level = new Level();
        add(level);
		FlxG.worldBounds.set(
			level.ground.x,
			level.ground.y,
			level.ground.width,
			level.ground.height
		);
		player = new Player(75, 75);
        add(player);
		add(level.decorations);
		player.scale.set(1, 1);
		for (i in 0...level.positions.length)
		{
			var positionIndex = getRandomNumber(level.positions.length);
			var gemType = level.gems[i];
			objectives.push(new Objective(level.positions[positionIndex][0], level.positions[positionIndex][1], gemType));
		}

		for (objective in objectives)
		{
			add(objective);
		}


		FlxG.camera.follow(player);
        FlxG.camera.zoom = 2;

		ui = new GameUI();
    	add(ui);
		totalObjectivesPair = objectives.length/2;
		ui.setObjectiveCount(currentObjectiveCount, totalObjectivesPair);
		ui.tutorialText.alpha = 0;

		var uiCamera = FlxG.cameras.add(new FlxCamera(), false);
		uiCamera.bgColor = 0x00000000;
		ui.camera = uiCamera;
		
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
		FlxG.collide(level.walls, player);
		FlxG.collide(level.obstacles, player);
		if (FlxG.keys.justPressed.E)
			{
				for (i in 0...objectives.length)
				{
					var objective = objectives[i];
					if (FlxMath.distanceBetween(player, objective) < 85)
					{	
						var result:Int = 0;
						if (lastObjectiveInteracted == -1)
						{	

							result = objective.interact(-1);
							lastObjectiveInteracted = i;
						}
						else if (lastObjectiveInteracted != -1 && lastObjectiveInteracted != i)
						{
							result = objective.interact(objectives[lastObjectiveInteracted].gemNum);
							resultsEval(result);
							if (lastObjectiveInteracted != -1)
							{
								lastObjectiveInteracted = i;
							}
						}
					}
				}
				if (allPairsFound())
				{
					trace("All pairs found!");
					ui.winText.alpha = 1;
					new FlxTimer().start(3.0, function(timer:FlxTimer):Void {
						FlxG.sound.music.stop();
						FlxG.switchState(new MenuState());

					});
				}
			}

		if (FlxG.keys.justPressed.R)
			{
				FlxG.sound.music.stop();
				FlxG.switchState(new MenuState());
			}
		
		if(FlxG.keys.justPressed.T)
		{
			if (ui.tutorialText.alpha == 1){
				ui.tutorialText.alpha = 0;
			}
			else
			{
				ui.tutorialText.alpha = 1;
			}
		}
		
    }

	function resultsEval(result:Int):Void
	{
		switch (result)
		{
			case 2: //Pair found
				lastObjectiveInteracted = -1;
				currentObjectiveCount++;
				ui.setObjectiveCount(currentObjectiveCount, totalObjectivesPair);
			case 3: //Wron pair
				objectives[lastObjectiveInteracted].resetObjective();
				lastObjectiveInteracted = -1;
		}
	}

	function allPairsFound():Bool
	{
		for (objective in objectives)
		{
			if (!objective.interacted)
			{
				return false;
			}
		}

		return true;
	}

	function getRandomNumber(max:Int):Int
	{
		if (usedNumbers.length >= max) //8
		{
			return -1;
		}

		var number:Int;

		do
		{
			number = FlxG.random.int(0, max - 1); //7
		}
		while (usedNumbers.contains(number));

		usedNumbers.push(number);

		return number;
	}
}