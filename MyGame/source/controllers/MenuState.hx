package controllers;

import models.GameData;
import flixel.FlxG;
import flixel.FlxState;
import models.GameData;
import views.MenuUI;

import controllers.games.flipnfind.LevelSelectState;
import views.darkMaze.DarkMazeInitialState;
import controllers.games.gemGameClasses.GemGameInitial;


class MenuState extends FlxState {
    private var gameList:Array<GameData>;

    override public function create():Void {
        FlxG.cameras.bgColor = 0xFF0D0B18;

        super.create();

        // Model Initialization
        gameList = [
            new GameData("Flip n Find", LevelSelectState),
            new GameData("Dark Maze",DarkMazeInitialState)
            new GameData("Gem Game", GemGameInitial)

        ];

        // View Initialization
        var menuUI = new MenuUI(gameList, launchGame);
        add(menuUI);
    }

    // Controller Action: Handle State Transition
    private function launchGame(targetState:Class<FlxState>):Void {
        FlxG.switchState(() -> Type.createInstance(targetState, []));
    }
}