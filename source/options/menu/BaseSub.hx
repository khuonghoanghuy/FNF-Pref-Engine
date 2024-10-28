package options.menu;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class BaseSub extends MusicBeatSubstate
{
	var curSelected:Int = 0;
	var grpControls:FlxTypedGroup<Alphabet>;
	public var menu:Array<String> = [];

    override function create() {
        super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

        grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

        changeSelection();
    }    

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK)
            close(); // fix pls

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

    function regenMenu() {
        for (i in 0...menu.length) {
			var opti:Alphabet = new Alphabet(0, (70 * i) + 30, menu[i], true, false);
			opti.isMenuItem = true;
			opti.targetY = i;
			grpControls.add(opti);
		}
    }
}