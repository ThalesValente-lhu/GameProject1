package models.flipnfind;

typedef LevelConfig =
{
	cols:Int,
	rows:Int,
	seconds:Int
}

class Levels
{
	public static final all:Array<LevelConfig> = [
		{cols: 3, rows: 2, seconds: 30},
		{cols: 4, rows: 2, seconds: 35},
		{cols: 4, rows: 3, seconds: 50},
		{cols: 4, rows: 4, seconds: 65},
		{cols: 5, rows: 4, seconds: 80},
		{cols: 6, rows: 4, seconds: 95},
		{cols: 7, rows: 4, seconds: 110},
		{cols: 6, rows: 5, seconds: 115},
		{cols: 8, rows: 4, seconds: 120},
		{cols: 8, rows: 5, seconds: 150}
	];
}
