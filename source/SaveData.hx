package;

import flixel.util.FlxSave;

class SaveData {
    public static var settings:Map<String, Dynamic> = [
        "ghost tap" => true,
        "downscroll" => false,
		"count miss note as misses" => false
    ];

    public static function saveSettings() {
		var settingsSave:FlxSave = new FlxSave();
		settingsSave.bind('pref', 'huy1234th');
		settingsSave.data.settings = settings;
		settingsSave.close();

		trace("settings saved!");
	}

    public static function loadSettings() {
		var settingsSave:FlxSave = new FlxSave();
		settingsSave.bind('pref', 'huy1234th');

		if (settingsSave != null) {
			if (settingsSave.data.settings != null) {
				var savedMap:Map<String, Dynamic> = settingsSave.data.settings;
				for (name => value in savedMap) {
					settings.set(name, value);
				}
			}
		}
		settingsSave.destroy();
	}

	public static function get(string:String)
	{
		trace("Save Data get: " + string);
		return SaveData.settings.get(string);
	}
	
	public static function set(string:String, newValue:Dynamic)
	{
		trace("Save Data set with " + string + " as new value is: " + newValue);
		return SaveData.settings.set(string, newValue);
	}
}