package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class OptionsMenu extends MusicBeatState
{
	var titleTxt:FlxText;
	var descTxt:FlxText;

	var engine:OptionsEngine;
	var stillInOpt:Bool = false;

	var curSelected:Int = 0;

	var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.menuDesat__png);
		menuBG.color = 0xFFea71fd;
		menuBG.scrollFactor.set(0, 0);
		menuBG.antialiasing = true;
		add(menuBG);

		titleTxt = new FlxText(10, 5, 0, "", 32);
		titleTxt.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);

		descTxt = new FlxText(titleTxt.x + 10, titleTxt.y + 30, 0, "", 24);
		descTxt.setFormat("assets/fonts/vcr.ttf", 24, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);

		var scoreBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width), Std.int(descTxt.y + 30), FlxColor.BLACK);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		add(titleTxt);
		add(descTxt);

		for (i in 0...engine.menu.length) {
			var opti:Alphabet = new Alphabet(0, (70 * i) + 30, engine.menu[i], true, false);
			opti.isMenuItem = true;
			opti.targetY = i;
			grpControls.add(opti);
		}

		super.create();

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
			FlxG.switchState(new MainMenuState());

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}

		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		Paths.sound("scrollMenu");
		curSelected += change;

		if (curSelected < 0)
			curSelected = engine.menu.length - 1;
		if (curSelected >= engine.menu.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}

class OptionsEngine {
	public var instance:Map<String, String> = [
		// desc and text
		"Menu Options" => "Select options",
		"Gameplay Options" => "Select please",

		// actual options
		"ghost tap" => "Play least misses with this"
	];

	public var menu:Array<String> = ["Gameplay"];
}
