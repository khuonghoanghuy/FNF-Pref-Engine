package;

import flixel.FlxG;
import haxe.io.Path;
import flixel.graphics.frames.FlxAtlasFrames;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

class Paths {
	inline public static final DEFAULT_FOLDER:String = 'assets';
	public static var ALL_SCRIPT_EXTENSION:Array<String> = ['.hxs'];
	public static var GAME_EXTENSION:Array<String> = [".png"];
	static public var soundExt:String = #if web ".mp3" #else ".ogg" #end;

	public static var imagesFile:Array<String> = [];

	static public function getPath(folder:Null<String>, file:String) {
		if (folder == null)
			folder = DEFAULT_FOLDER;
		return folder + '/' + file;
	}

	static public function file(file:String, folder:String = DEFAULT_FOLDER) {
		if (#if sys FileSystem.exists(folder) && #end (folder != null && folder != DEFAULT_FOLDER))
			return getPath(folder, file);
		return getPath(null, file);
	}

    inline static public function script(key:String)
		return file('scripts/$key' + ALL_SCRIPT_EXTENSION[0]);

	inline static public function image(key:String)
	{
		return file('images/$key' + GAME_EXTENSION[0]);
	}

	inline static public function getCharacter(key:String)
		return FlxAtlasFrames.fromSparrow(image('characters/$key'), file('images/characters/$key.xml'));

	inline static public function getSparrowAtlas(key:String)
		return FlxAtlasFrames.fromSparrow(image('$key'), file('images/$key.xml'));

	inline static public function sound(key:String, ?playNow:Bool = true, ?loud:Float = 0.6) {
		if (playNow)
			FlxG.sound.play(file("sounds/" + key + soundExt), loud);
		else
			file("sounds/" + key + soundExt);
	}

	inline static public function getStageImage(path:String) {
		return file("stages/" + PlayState.curStage + "/images/" + path + ".png");
	}

	inline static public function getStageSparrow(path:String) {
		return FlxAtlasFrames.fromSparrow(getStageImage(path), file("stages/" + PlayState.curStage + "/images/" + path + ".xml"));
	}

    inline static public function formatToSongPath(path:String) {
		var invalidChars = ~/[~&\\;:<>#]/;
		var hideChars = ~/[.,'"%?!]/;

		var path = invalidChars.split(path.replace(' ', '-')).join("-");
		return hideChars.split(path).join("").toLowerCase();
	}
}