package views;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flash.system.System;
import models.GameData;

class MenuUI extends FlxGroup {
    public function new(games:Array<GameData>, onSelectGame:Class<flixel.FlxState>->Void) {
        super();

        // 1. Header Title
        var title = new FlxText(0, 80, FlxG.width, "Memory Game Hub", 32);
        title.alignment = CENTER;
        title.color = FlxColor.WHITE;
        add(title);

        // 2. Dynamic Menu Buttons
        var startY:Float = 200;
        var spacing:Float = 65;

        for (i in 0...games.length) {
            var game = games[i];

            // Instantiate button with custom width/height (240x40 px)
            var btn = new NavButton(0, startY + (i * spacing), game.title, function() {
                onSelectGame(game.stateClass);
            }, 240, 45);

            // Scale button graphic container
            btn.makeGraphic(240, 45, 0xFF333344); 

            // Style the text inside the button
            btn.label.setFormat(null, 18, FlxColor.WHITE, CENTER);
            btn.label.fieldWidth = 240;

            // Center button horizontally
            btn.screenCenter(X);
            add(btn);
        }

        var exitY:Float = startY + (games.length * spacing) + 20;
        var exitBtn = new NavButton(0, exitY, "Exit Game", function() {
            System.exit(0);
        }, 160, 40);

        exitBtn.screenCenter(X);
        add(exitBtn);
    }
}