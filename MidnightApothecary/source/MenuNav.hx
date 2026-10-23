package;

/** Keyboard / gamepad focus cycling for a vertical list of buttons. */
class MenuNav
{
	public var buttons:Array<UIButton>;
	public var index:Int = 0;

	public function new(buttons:Array<UIButton>)
	{
		this.buttons = buttons;
		refresh();
	}

	public function update():Void
	{
		if (buttons.length == 0) return;
		if (Controls.up() || Controls.left()) move(-1);
		else if (Controls.down() || Controls.right()) move(1);
		else if (Controls.confirm()) buttons[index].press();
	}

	function move(dir:Int):Void
	{
		index = (index + dir + buttons.length) % buttons.length;
		Settings.sfx("tick", 0.6);
		refresh();
	}

	public function refresh():Void
	{
		for (i in 0...buttons.length)
			buttons[i].focused = i == index;
	}
}
