package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'options', 'donate'];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var versionArray:Array<String> = [
		"Friday Night Funkin' v0.2.1", // og version
		"Pref Engine v0.1.0", // pref version
 	];

	override function create()
	{
		if (FlxG.save.data.lastSelected == null)
			FlxG.save.data.lastSelected = 0;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuBG"));
		bg.scrollFactor.set(0, 0);
		bg.antialiasing = true;
		camFollow = new FlxObject(0, 0, 1, 1);
		magenta = new FlxSprite(0).loadGraphic(Paths.image("menuBGMagenta"));
		magenta.scrollFactor.set(0, 0);
		magenta.color = 0xFFfd719b;
		magenta.visible = false;
		menuItems = new FlxTypedGroup<FlxSprite>();
		multi_added([bg, camFollow, magenta, menuItems]);

		var tex = Paths.getSparrowAtlas("FNF_main_menu_assets");

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.1);

		for (i in 0...versionArray.length)
		{
			var versionText:FlxText = new FlxText(10, FlxG.height - 18 - (i * 18), 0, versionArray[i], 16);
			versionText.scrollFactor.set();
			versionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			add(versionText);
		}

		// hmm
		changeItem(FlxG.save.data.lastSelected);

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play('assets/sounds/confirmMenu' + Paths.soundExt);

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
									case 'freeplay':
										FlxG.switchState(new FreeplayState());
									case 'options':
										FlxG.switchState(new OptionsMenu());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		Paths.sound("scrollMenu");

		curSelected += huh;
		FlxG.save.data.lastSelected = curSelected;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				FlxTween.tween(spr.scale, {x: 1.1, y: 1.1}, 0.1, {ease: FlxEase.sineInOut});
			}
			else
			{
				FlxTween.tween(spr.scale, {x: 1, y: 1}, 0.1, {ease: FlxEase.sineInOut});
			}

			spr.updateHitbox();
		});
	}
}
