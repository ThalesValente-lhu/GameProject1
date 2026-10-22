package controllers.games;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import controllers.MenuState;
import views.NavButton;

class CardMemoryGame extends FlxState {
    override public function create():Void {
        super.create();

        var label = new FlxText(0, 180, FlxG.width, "Card Memory Game Placeholder", 24);
        label.alignment = CENTER;
        add(label);

        // Reusable Back Button
        var backBtn = new NavButton(0, 320, "Back to Menu", function() {
            FlxG.switchState(MenuState.new);
        }, 160, 40);

        backBtn.screenCenter(X);
        add(backBtn);
    }
}