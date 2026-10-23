package views.midnight;



import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/** Shared colours, fonts and drawing helpers so every screen matches. */
class Theme
{
	public static inline var BG:FlxColor = 0xFF120F24;
	public static inline var PANEL:FlxColor = 0xFF1E1938;
	public static inline var PANEL_LINE:FlxColor = 0xFF3A3166;
	public static inline var GOLD:FlxColor = 0xFFDDBB66;
	public static inline var GOLD_LIGHT:FlxColor = 0xFFF0CF78;
	public static inline var TEXT:FlxColor = 0xFFE8DFF5;
	public static inline var MUTED:FlxColor = 0xFF9C92BC;
	public static inline var GOOD:FlxColor = 0xFF6FD08C;
	public static inline var BAD:FlxColor = 0xFFF06A7A;
	public static inline var DARK_TEXT:FlxColor = 0xFF1B1530;

	public static inline var FONT = "assets/fonts/DejaVuSans.ttf";
	public static inline var FONT_BOLD = "assets/fonts/DejaVuSans-Bold.ttf";
	public static inline var FONT_TITLE = "assets/fonts/DejaVuSerif-Bold.ttf";

	public static function text(x:Float, y:Float, width:Float, str:String, size:Int = 18, ?color:FlxColor, bold:Bool = false,
			?align:FlxTextAlign):FlxText
	{
		if (color == null) color = TEXT;
		if (align == null) align = FlxTextAlign.LEFT;
		var t = new FlxText(x, y, width, str, size);
		t.setFormat(bold ? FONT_BOLD : FONT, size, color, align);
		t.antialiasing = true;
		return t;
	}

	public static function title(x:Float, y:Float, width:Float, str:String, size:Int = 44, ?align:FlxTextAlign):FlxText
	{
		if (align == null) align = FlxTextAlign.LEFT;
		var t = new FlxText(x, y, width, str, size);
		t.setFormat(FONT_TITLE, size, GOLD, align, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
		t.borderSize = 2;
		t.antialiasing = true;
		return t;
	}

	/** A rounded panel sprite. */
	public static function panel(x:Float, y:Float, w:Int, h:Int, ?fill:FlxColor, ?line:FlxColor, radius:Float = 28):FlxSprite
	{
		if (fill == null) fill = PANEL;
		if (line == null) line = PANEL_LINE;
		var s = new FlxSprite(x, y);
		s.makeGraphic(w, h, FlxColor.TRANSPARENT, true);
		drawRounded(s, fill, line, radius);
		return s;
	}

	public static function drawRounded(s:FlxSprite, fill:FlxColor, line:FlxColor, radius:Float = 28, thickness:Float = 2):Void
	{
		FlxSpriteUtil.fill(s, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(s, thickness, thickness, s.width - thickness * 2, s.height - thickness * 2, radius, radius, fill,
			{thickness: thickness, color: line});
	}
}
