package views;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class NavButton extends FlxButton {
    private var targetScale:Float = 1.0;

    public function new(X:Float, Y:Float, Text:String, OnClick:Void->Void, Width:Int = 240, Height:Int = 45) {
        super(X, Y, Text, OnClick);

        // Standardize graphic size and background color
        makeGraphic(Width, Height, 0xDD1B162E);

        // Format button text
        label.setFormat(null, 18, FlxColor.fromRGB(220, 240, 255), CENTER);
        label.fieldWidth = Width;

        var border = new flixel.FlxSprite(X, Y);
        border.makeGraphic(Width, Height, FlxColor.TRANSPARENT);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (overlapsPoint(FlxG.mouse.getWorldPosition())) {
            targetScale = 1.05;
            label.color = FlxColor.fromRGB(0, 240, 255);
        } else {
            targetScale = 1.0;
            label.color = FlxColor.fromRGB(220, 240, 255);
        }

        scale.x += (targetScale - scale.x) * elapsed * 12;
        scale.y += (targetScale - scale.y) * elapsed * 12;
    }
}