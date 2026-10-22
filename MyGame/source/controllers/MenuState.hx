package controllers;

import flixel.FlxG;
import flixel.FlxState;
import models.GameData;
import views.MenuUI;
import controllers.games.flipnfind.LevelSelectState;

class MenuState extends FlxState {
    private var gameList:Array<GameData>;

    override public function create():Void {
        super.create();

        // Model Initialization
        gameList = [
            new GameData("Flip n Find", LevelSelectState)
        ];

        // View Initialization
        var menuUI = new MenuUI(gameList, launchGame);
        add(menuUI);
    }

    // Controller Action: Handle State Transition
    private function launchGame(targetState:Class<FlxState>):Void {
        var nextState = Type.createInstance(targetState, []);
        FlxG.switchState(nextState);
    }
}