package views;

import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class NavButton extends FlxButton {
    /**
     * @param X Horizontal position
     * @param Y Vertical position
     * @param Text Label displayed on the button
     * @param OnClick Action performed when clicked
     * @param Width Custom width (default 160px)
     * @param Height Custom height (default 40px)
     */
    public function new(X:Float, Y:Float, Text:String, OnClick:Void->Void, Width:Int = 160, Height:Int = 40) {
        super(X, Y, Text, OnClick);

        // Standardize graphic size and background color
        makeGraphic(Width, Height, 0xFF444455);

        // Format button text
        label.setFormat(null, 12, FlxColor.WHITE, CENTER);
        label.fieldWidth = Width;
    }
}