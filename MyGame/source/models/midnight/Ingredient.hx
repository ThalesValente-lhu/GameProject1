package models.midnight;



import flixel.util.FlxColor;


class Ingredient
{
	public static final ALL:Array<Ingredient> = [
		new Ingredient("Toadstool", "toadstool", 0xFFD94A4A),
		new Ingredient("Sage", "sage", 0xFF78BE64),
		new Ingredient("Dew", "dew", 0xFF5096EB),
		new Ingredient("Ember", "ember", 0xFFEB6A28),
		new Ingredient("Crystal", "crystal", 0xFF46AAE6),
		new Ingredient("Feather", "feather", 0xFFC8AA82),
		new Ingredient("Stardust", "stardust", 0xFFF5C846),
		new Ingredient("Newt eye", "newteye", 0xFF96703C)
	];

	public var name(default, null):String;
	public var id(default, null):String;
	public var color(default, null):FlxColor;
	public var image(get, never):String;

	function new(name:String, id:String, color:FlxColor)
	{
		this.name = name;
		this.id = id;
		this.color = color;
	}

	function get_image():String
		return 'assets/images/midnight-images/ingredients/$id.png';
}
