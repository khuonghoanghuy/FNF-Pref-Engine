package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

using StringTools;

class OptionsMenu extends MusicBeatState
{
	var titleTxt:FlxText;
	var descTxt:FlxText;

	var stillInOpt:Bool = false;

	var curSelected:Int = 0;

	var grpControls:FlxTypedGroup<Alphabet>;

	public var optionsList:Map<String, String> = [
		"ghost tap" => "Play least misses with this"
	];
	public var menu:Array<String> = [];
	var og:Array<String> = ["Gameplay"];
	var gameplay:Array<String> = ["Ghost tap", "Downscroll"];

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

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...menu.length) {
			var opti:Alphabet = new Alphabet(0, (70 * i) + 30, menu[i], true, false);
			opti.isMenuItem = true;
			opti.targetY = i;
			grpControls.add(opti);
		}

		changeMenu(og);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			if (stillInOpt) {
				changeMenu(og);
			} else {
				FlxG.switchState(new MainMenuState());
			}
		}

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}

		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.ACCEPT) {
			switch (menu[curSelected].toLowerCase()) {
				// menu
				case "gameplay":
					stillInOpt = true;
					changeMenu(gameplay);

				case "ghost tap":
					SaveData.set("ghost tap", !SaveData.get("ghost tap"));
					trace(SaveData.get("ghost tap"));

				// cool opt
				case "back":
					if (stillInOpt) {
						changeMenu(og);
					} else {
						FlxG.switchState(new MainMenuState());
					}
			}
		}

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		Paths.sound("scrollMenu");
		curSelected += change;

		if (curSelected < 0)
			curSelected = menu.length - 1;
		if (curSelected >= menu.length)
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
	
	private function regenMenu():Void
	{
		while (grpControls.members.length > 0)
		{
			grpControls.remove(grpControls.members[0], true);
		}

		for (i in 0...menu.length) {
			var opti:Alphabet = new Alphabet(0, (70 * i) + 30, menu[i], true, false);
			opti.isMenuItem = true;
			opti.targetY = i;
			grpControls.add(opti);
		}
		curSelected = 0;
		changeSelection();
	}

	function changeMenu(daArray:Array<String>) {
		menu = daArray;
		regenMenu();
	}
}