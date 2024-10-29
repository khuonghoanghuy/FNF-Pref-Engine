package;

import sys.io.File;
import openfl.Lib;
import openfl.filters.ShaderFilter;
import flixel.system.FlxAssets.FlxShader;
import flixel.addons.display.FlxRuntimeShader;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxG;
import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig.RawIrisConfig;
import flixel.FlxBasic;

using StringTools;

class HscriptIris extends FlxBasic
{
    public var script:Iris;

    public function new(file:String, ?fileName:String = "Hscript Iris") {
        super();

        // Init
        script = new Iris(File.getContent(file));
        script.config.name = fileName;
        script.config.autoPreset = true;
        script.config.autoRun = false;

        // Present
		script.set("game", PlayState.instance);
		script.set("Paths", Paths);
        script.set("FlxG", FlxG);
        script.set("FlxSprite", FlxSprite);
        script.set("FlxCamera", FlxCamera);
        script.set("FlxText", FlxText);
        script.set("FlxRuntimeShader", FlxRuntimeShader);
        script.set("FlxShader", FlxShader);
        script.set("ShaderFilter", ShaderFilter);
        script.set('import', function(daClass:String, ?asDa:String) {
			final splitClassName:Array<String> = [for (e in daClass.split('.')) e.trim()];
			final className:String = splitClassName.join('.');
			final daClass:Class<Dynamic> = Type.resolveClass(className);
			final daEnum:Enum<Dynamic> = Type.resolveEnum(className);

			if (daClass == null && daEnum == null)
				Lib.application.window.alert('Class / Enum at $className does not exist.', 'Hscript Error!');
			else {
				if (daEnum != null) {
					var daEnumField = {};
					for (daConstructor in daEnum.getConstructors())
						Reflect.setField(daEnumField, daConstructor, daEnum.createByName(daConstructor));

					if (asDa != null && asDa != '')
						script.set(asDa, daEnumField);
					else
						script.set(splitClassName[splitClassName.length - 1], daEnumField);
				} else {
					if (asDa != null && asDa != '')
						script.set(asDa, daClass);
					else
						script.set(splitClassName[splitClassName.length - 1], daClass);
				}
			}
		});
		script.set("add", PlayState.instance.add);
		script.set("remove", PlayState.instance.remove);
        script.execute();
    }    
}