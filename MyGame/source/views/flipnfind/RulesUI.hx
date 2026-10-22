package views.flipnfind;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class RulesUI extends FlxGroup
{
	public function new()
	{
		super();

		var title = new FlxText(0, 50, Viewport.WIDTH, "HOW TO PLAY", 40);
		title.alignment = CENTER;
		title.color = FlxColor.YELLOW;
		add(title);

		var rules = "- At the start, all the cards are shown for 2 seconds. Try to remember them!\n"
			+ "- Flip two cards at a time and try to find the matching animals.\n"
			+ "- A matching pair gives 100 points. A wrong pair takes away 10 points.\n"
			+ "- Clear all the cards before the time runs out.\n"
			+ "- Every second left over gives 10 bonus points.\n"
			+ "- Finish a level to unlock the next one. Your best scores are saved.\n\n"
			+ "CONTROLS\n"
			+ "Mouse: click a card to flip it, click the buttons at the top\n"
			+ "Keyboard: arrows / WASD to move, ENTER / SPACE to flip\n"
			+ "Gamepad: D-pad to move, A to flip\n\n"
			+ "Rules: I key, Y button or the i button\n"
			+ "Retry: R / X        Back to levels: ESC / B or the home button\n"
			+ "Back to the game hub: ESC / B on the levels screen";

		var text = new FlxText(150, 130, Viewport.WIDTH - 300, rules, 20);
		add(text);

		var close = new FlxText(0, 650, Viewport.WIDTH, "Press I, ESC or click anywhere to close", 18);
		close.alignment = CENTER;
		close.color = FlxColor.GRAY;
		add(close);
	}
}
