package;

import hscript.Parser;
import hscript.Interp;
import sys.io.File;
import openfl.Lib;
import openfl.filters.ShaderFilter;
import flixel.system.FlxAssets.FlxShader;
import flixel.addons.display.FlxRuntimeShader;
import flixel.text.FlxText;
import flixel.*;
import flixel.FlxBasic;

using StringTools;

class Hscript extends FlxBasic
{
	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;

	public var interp:Interp = new Interp();
	public var parser:Parser = new Parser();

	var fileAsName:String = "hscript";

	public function new(file:String, ?fileName:String = "hscript") {
		super();
		
		fileAsName = fileName;
		
		// Classes
		setVariable("FlxG", FlxG);
		setVariable("FlxSprite", FlxSprite);
		setVariable("FlxCamera", FlxCamera);
		setVariable("FlxText", FlxText);
		setVariable("FlxRuntimeShader", FlxRuntimeShader);
		setVariable("FlxShader", FlxShader);
		setVariable("ShaderFilter", ShaderFilter);
		setVariable("Paths", Paths);
		setVariable("PlayState", PlayState);

		// Variable
		setVariable("game", PlayState.instance);
		setVariable('Function_Stop', Function_Stop);
		setVariable('Function_Continue', Function_Continue);

		// Function
		setVariable('import', function(daClass:String, ?asDa:String) {
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
						setVariable(asDa, daEnumField);
					else
						setVariable(splitClassName[splitClassName.length - 1], daEnumField);
				} else {
					if (asDa != null && asDa != '')
						setVariable(asDa, daClass);
					else
						setVariable(splitClassName[splitClassName.length - 1], daClass);
				}
			}
		});

		parser.allowJSON = parser.allowMetadata = parser.allowTypes = true;

		execute(file);
	}

	public function execute(file:String, ?executeCreate:Bool = true):Void {
		try {
			interp.execute(parser.parseString(File.getContent(file)));
		} catch (e)
			Lib.application.window.alert(e.message, fileAsName + " error dude!");

		trace('Script Loaded Succesfully: $file');

		if (executeCreate)
			executeFunc('create', []);
	}

	public function setVariable(name:String, val:Dynamic):Void {
		if (interp == null)
			return;

		try {
			interp.variables.set(name, val);
		} catch (e)
			Lib.application.window.alert(e.message, fileAsName + " error dude!");
	}

	public function executeFunc(funcName:String, ?args:Array<Dynamic>):Dynamic {
		if (interp == null)
			return null;

		if (interp.variables.exists(funcName)) {
			try {
				return Reflect.callMethod(this, interp.variables.get(funcName), args == null ? [] : args);
			} catch (e)
				Lib.application.window.alert(e.message, fileAsName + " error dude!");
		}

		return null;
	}
}