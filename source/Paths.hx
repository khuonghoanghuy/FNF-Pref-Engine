package;

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
		return file('scripts/$key.hxs');

	inline static public function image(key:String)
		return file('images/$key.png');

	inline static public function getCharacter(key:String)
		return FlxAtlasFrames.fromSparrow(image('characters/$key'), file('images/characters/$key.xml'));

	inline static public function getSparrowAtlas(key:String)
		return FlxAtlasFrames.fromSparrow(image('$key'), file('images/$key.xml'));

    inline static public function formatToSongPath(path:String) {
		var invalidChars = ~/[~&\\;:<>#]/;
		var hideChars = ~/[.,'"%?!]/;

		var path = invalidChars.split(path.replace(' ', '-')).join("-");
		return hideChars.split(path).join("").toLowerCase();
	}
}