package views;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class FloatingNode extends FlxSprite {
    public var velocityY:Float;

    public function new() {
        super();
        resetPosition();
    }

    private function resetPosition():Void {
        x = FlxG.random.float(20, FlxG.width - 20);
        y = FlxG.height + FlxG.random.float(10, 80);
        
        // Small glowing synapse dot
        var size = FlxG.random.int(4, 8);
        makeGraphic(size, size, FlxColor.fromRGB(0, 240, 255)); // Bright Cyan
        
        velocityY = FlxG.random.float(15, 45);
        alpha = FlxG.random.float(0.2, 0.6);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        y -= velocityY * elapsed;

        if (y < -20) {
            resetPosition();
        }
    }
}