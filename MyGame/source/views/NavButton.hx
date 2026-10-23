package views;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class NavButton extends FlxButton {
    private var targetScale:Float = 1.0;
    private var isHovered:Bool = false;

    public function new(X:Float, Y:Float, Text:String, OnClick:Void->Void, Width:Int = 240, Height:Int = 45) {
        var wrappedClick = function() {
            FlxG.sound.play("assets/sounds/menu/Select.wav", 0.7);
            if (OnClick != null) {
                OnClick();
            }
        }
        super(X, Y, Text, wrappedClick);

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

        var currentlyHovered = overlapsPoint(FlxG.mouse.getWorldPosition());

        if (currentlyHovered && !isHovered) {
            FlxG.sound.play("assets/sounds/menu/Hover.wav", 0.4);
            isHovered = true;
        } else if (!currentlyHovered) {
            isHovered = false;
        }

        if (currentlyHovered) {
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