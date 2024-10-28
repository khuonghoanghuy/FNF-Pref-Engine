package options;

import options.menu.*;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;

class OptionsState extends MusicBeatState
{
	var curSelected:Int = 0;
	var grpControls:FlxTypedGroup<Alphabet>;
	public var menu:Array<String> = [
        "Gameplay",
        "Quality",
        "Misc"
    ];

    override function create() {
        super.create();

        var menuBG:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.menuDesat__png);
		menuBG.color = 0xFFea71fd;
		menuBG.scrollFactor.set(0, 0);
		menuBG.antialiasing = true;
		add(menuBG);

        grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...menu.length) {
			var opti:Alphabet = new Alphabet(0, (70 * i) + 30, menu[i], true, false);
			opti.isMenuItem = true;
			opti.targetY = i;
			grpControls.add(opti);
		}

        changeSelection();
    }    

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK) {
            FlxG.save.flush();
            FlxG.switchState(new MainMenuState());
        }

        if (controls.ACCEPT) {
            switch (menu[curSelected]) {
                case "Gameplay":
                    openSubState(new GameplaySub());
            }
        }

        if (controls.UI_UP_P) {
            changeSelection(-1);
        }

        if (controls.UI_DOWN_P) {
            changeSelection(1);
        }
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
}