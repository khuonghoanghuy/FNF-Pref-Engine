package;

import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class FreeplayState extends MusicBeatState
{
	var songs:Array<String> = ["Tutorial"];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;

	override function create()
	{
		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
		}

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end
		songs = CoolUtil.coolTextFile("assets/data/freeplaySonglist.txt");

		var bg:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.menuBGBlue__png);
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		super.create();
	}

	var stopChange:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));
		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		var random = FlxG.keys.justPressed.R;

		if (random && !stopChange)
		{
			var randomSong:Int = FlxG.random.int(0, songs.length - 1);
			changeSelection(randomSong);
			var timer:FlxTimer = new FlxTimer();
			timer.cancel(); // should be cancel before starting play
			timer.start(1, function (timer:FlxTimer) {
				var poop:String = Highscore.formatSong(songs[randomSong].toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[randomSong].toLowerCase());
				PlayState.isStoryMode = false;
				FlxG.switchState(new PlayState());
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
			});
		}

		if (upP && !stopChange)
		{
			changeSelection(-1);
		}
		if (downP && !stopChange)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P && !stopChange)
			changeDiff(-1);
		if (controls.RIGHT_P && !stopChange)
			changeDiff(1);

		if (controls.BACK && !stopChange)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted && !stopChange)
		{
			stopChange = true;
			var poop:String = Highscore.formatSong(songs[curSelected].toLowerCase(), curDifficulty);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].toLowerCase());
			PlayState.isStoryMode = false;
			FlxG.switchState(new PlayState());
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
		}

		if (FlxG.keys.justPressed.F1 && !stopChange)
			openSubState(new FreeplayStateHelp());
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		// lerpScore = 0;

		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class FreeplayStateHelp extends MusicBeatSubstate {
	override function create() {
		super.create();
	
		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.screenCenter();
		add(bg);

		var wholeHintText:FlxText = new FlxText(0, 0, 0, CoolUtil.coolStringFile(Paths.file("data/freeplayhelp.txt")), 24);
		wholeHintText.screenCenter();
		wholeHintText.alignment = CENTER;
		add(wholeHintText);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	
		if (FlxG.keys.justPressed.F1)
			close();
	}
}