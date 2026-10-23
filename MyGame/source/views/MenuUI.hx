package views;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flash.system.System;
import models.GameData;

class MenuUI extends FlxGroup {
    private var titleText:FlxText;
    private var timer: Float = 0;
    
    public function new(games:Array<GameData>, onSelectGame:Class<FlxState>->Void) {
        super();

        for (i in 0...16) {
            add(new FloatingNode());
        }

        // 1. Header Title
        titleText = new FlxText(0, 65, FlxG.width, "M I N D S C A P E", 38);
        titleText.alignment = CENTER;
        titleText.color = FlxColor.fromRGB(0, 240, 255);
        titleText.setBorderStyle(OUTLINE, FlxColor.fromRGB(123, 44, 191), 4);
        add(titleText);

        var subtitle = new FlxText(0, 120, FlxG.width, "[ MEMORY ARCHITECTURE HUB ]", 12);
        subtitle.alignment = CENTER;
        subtitle.color = FlxColor.fromRGB(160, 160, 200);
        add(subtitle);

        // 2. Dynamic Menu Buttons
        var startY:Float = 190;
        var spacing:Float = 65;

        for (i in 0...games.length) {
            var game = games[i];

            // Instantiate button with custom width/height (240x40 px)
            var btn = new NavButton(0, startY + (i * spacing), game.title, function() {
                onSelectGame(game.stateClass);
            }, 260, 48);

            // Center button horizontally
            btn.screenCenter(X);
            add(btn);
        }

        var exitY:Float = startY + (games.length * spacing) + 20;
        var exitBtn = new NavButton(0, exitY, "Disconnect", function() {
            System.exit(0);
        }, 160, 38);

        exitBtn.screenCenter(X);
        add(exitBtn);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        timer += elapsed * 2.5;
        titleText.y = 65 + Math.sin(timer) * 3;
    }
}