package;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.util.FlxTimer;

class MusicBeatState extends FlxUIState
{
	public var lastBeat:Float = 0;
	public var lastStep:Float = 0;

	public var totalBeats:Int = 0;
	public var totalSteps:Int = 0;

	public var curStep:Int = 0;
	public var curBeat:Int = 0;
	public var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		#if (!web)
		Paths.soundExt = '.ogg';
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		everyStep();

		updateCurStep();
		curBeat = Math.round(curStep / 4);

		super.update(elapsed);
	}

	/**
	 * CHECKS EVERY FRAME
	 */
	private function everyStep():Void
	{
		if (Conductor.songPosition > lastStep + Conductor.stepCrochet - Conductor.safeZoneOffset
			|| Conductor.songPosition < lastStep + Conductor.safeZoneOffset)
		{
			if (Conductor.songPosition > lastStep + Conductor.stepCrochet)
			{
				stepHit();
			}
		}
	}

	private function updateCurStep():Void
	{
		curStep = Math.floor(Conductor.songPosition / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		totalSteps += 1;
		lastStep += Conductor.stepCrochet;

		if (totalSteps % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		lastBeat += Conductor.crochet;
		totalBeats += 1;
	}
}
