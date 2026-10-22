package controllers.games.flipnfind;

import flixel.FlxSubState;
import views.flipnfind.RulesUI;

class RulesSubState extends FlxSubState
{
	// flixel updates a substate in the same frame it opens, while the key or click
	// that opened it is still "just pressed", so skip the first frame
	var ready = false;

	public function new()
	{
		super(0xee000000);
	}

	override public function create()
	{
		super.create();
		add(new RulesUI());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (ready && (Input.rules() || Input.back() || Input.mousePressed()))
			close();
		ready = true;
	}
}
