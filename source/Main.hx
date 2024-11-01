package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState));
		addChild(new FPS(10, 3, 0xFFFFFF));
		FlxG.save.data.lastSelected = 0;
		FlxG.mouse.useSystemCursor = true;
	}
}
