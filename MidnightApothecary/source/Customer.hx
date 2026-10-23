package;

import flixel.FlxG;

typedef CustomerData =
{
	var name:String;
	var portrait:String;
	var potions:Array<String>;
	var lines:Array<String>;
}


class Customer
{
	public static final ALL:Array<CustomerData> = [
		{
			name: "Grub",
			portrait: "troll",
			potions: ["a tooth-regrowing tonic", "a bridge-mending brew", "a goat-repellent draught"],
			lines: ["Same order as always - every step matters.", "Grub in hurry. Grub always in hurry.", "Last potion tasted like feet. Good feet."]
		},
		{
			name: "Count Varr",
			portrait: "vampire",
			potions: ["an invisibility tincture", "a sunscreen elixir", "a garlic antidote"],
			lines: ["I'll only say it once.", "Do try to keep up.", "Dawn waits for no one, apothecary."]
		},
		{
			name: "Old Mother Bramble",
			portrait: "witch",
			potions: ["a broom-polishing oil", "a wart-removal salve", "a cat-calming cordial"],
			lines: ["I used to brew this myself, dearie.", "Don't you dare skip a step.", "Quickly now, my soup is boiling."]
		},
		{
			name: "Whisper",
			portrait: "ghost",
			potions: ["a solidity serum", "a chain-silencing syrup", "a memory-restoring mist"],
			lines: ["Ooooh... the usual, please.", "I forget things. Don't you.", "Just... hurry... boo."]
		},
		{
			name: "Snitch",
			portrait: "goblin",
			potions: ["a luck-stealing potion", "a gold-shine lacquer", "a sneaky-step draught"],
			lines: ["No refunds if it explodes, yeah?", "Eyes on the recipe, not my pockets.", "Quick, before the guards notice."]
		},
		{
			name: "Prince Ribbit",
			portrait: "frog",
			potions: ["a curse-breaking kiss balm", "a royal-voice gargle", "a lily-pad levitation"],
			lines: ["Royalty does not wait.", "Make it exact. I was a prince, you know.", "Ribbit. Ahem. I mean - hurry."]
		}
	];

	public static function pick(?avoid:CustomerData):CustomerData
	{
		var c:CustomerData;
		do
			c = FlxG.random.getObject(ALL)
		while (c == avoid && ALL.length > 1);
		return c;
	}

	public static inline function portraitPath(c:CustomerData):String
		return 'assets/images/customers/${c.portrait}.png';
}
