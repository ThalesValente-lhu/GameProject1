package models;

import flixel.FlxState;

class GameData {
    public var title:String;
    public var stateClass:Class<FlxState>;

    public function new(title:String, stateClass:Class<FlxState>) {
        this.title = title;
        this.stateClass = stateClass;
    }
}