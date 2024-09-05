package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;
import openfl.Assets;
import openfl.Lib;
import flixel.FlxBasic;
import hscript.*;

class Hscript extends FlxBasic
{
	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;

    public var interp:Interp = new Interp();
    public var parser:Parser = new Parser();

    public function new(file:String, ?execute:Bool = true) {
        super();
        parser.allowJSON = parser.allowTypes = parser.allowMetadata = true;
		setVariable('trace', function(value:Dynamic) {
			trace(value);
		});

		setVariable('Function_Stop', Function_Stop);
		setVariable('Function_Continue', Function_Continue);

		setVariable('Array', Array);
		setVariable('Bool', Bool);
		setVariable('Date', Date);
		setVariable('DateTools', DateTools);
		setVariable('Dynamic', Dynamic);
		setVariable('EReg', EReg);
		setVariable('Float', Float);
		setVariable('Int', Int);
		setVariable('Lambda', Lambda);
		setVariable('Math', Math);
		setVariable('Reflect', Reflect);
		setVariable('Std', Std);
		setVariable('StringBuf', StringBuf);
		setVariable('String', String);
		setVariable('StringTools', StringTools);
		setVariable('Sys', Sys);
		setVariable('Type', Type);
		setVariable('Xml', Xml);

        setVariable("FlxG", FlxG);
        setVariable("FlxSprite", FlxSprite);
        setVariable("PlayState", PlayState);
        setVariable('FlxText', FlxText);
        setVariable('FlxTween', FlxTween);
        setVariable('FlxEase', FlxEase);
		setVariable("FlxTypedGroup", FlxTypedGroup);

		setVariable("Alphabet", Alphabet);
		setVariable("Paths", Paths);
		setVariable("SaveData", SaveData);

        setVariable("game", PlayState.instance);
        setVariable("add", function (basic:FlxBasic) {
            return PlayState.instance.add(basic);
        });
        setVariable("remove", function (basic:FlxBasic) {
            return PlayState.instance.remove(basic);
        });

        if (execute)
			this.execute(file);
    }

    public function execute(file:String, ?executeCreate:Bool = true):Void {
		try {
			interp.execute(parser.parseString(Assets.getText(file)));
		} catch (e:Dynamic) {
			#if hl
			trace("execute error!\n" + e);
			#else
			Lib.application.window.alert(e, 'Hscript Error!');
			#end
		}

		trace('Script Loaded Succesfully: $file');

		if (executeCreate)
			executeFunc('create', []);
	}

	public function setVariable(name:String, val:Dynamic):Void {
		if (interp == null)
			return;

		try {
			interp.variables.set(name, val);
		} catch (e:Dynamic) {
			#if hl
			trace("set variable rror!\n" + e);
			#else
			Lib.application.window.alert(e, 'Hscript Error!');
			#end
		}
	}

	public function getVariable(name:String):Dynamic {
		if (interp == null)
			return null;

		try {
			return interp.variables.get(name);
		} catch (e:Dynamic) {
			#if hl
			trace("get variable error!\n" + e);
			#else
			Lib.application.window.alert(e, 'Hscript Error!');
			#end
		}

		return null;
	}

	public function removeVariable(name:String):Void {
		if (interp == null)
			return;

		try {
			interp.variables.remove(name);
		} catch (e:Dynamic) {
			#if hl
			trace("remove variable error!\n" + e);
			#else
			Lib.application.window.alert(e, 'Hscript Error!');
			#end
		}
	}

	public function existsVariable(name:String):Bool {
		if (interp == null)
			return false;

		try {
			return interp.variables.exists(name);
		} catch (e:Dynamic) {
			#if hl
			trace("exits variable error!\n" + e);
			#else
			Lib.application.window.alert(e, 'Hscript Error!');
			#end
		}

		return false;
	}

	public function executeFunc(funcName:String, ?args:Array<Dynamic>):Dynamic {
		if (interp == null)
			return null;

		if (existsVariable(funcName)) {
			try {
				return Reflect.callMethod(this, getVariable(funcName), args == null ? [] : args);
			} catch (e:Dynamic) {
				#if hl
				trace("execute function error!\n" + e);
				#else
				Lib.application.window.alert(e, 'Hscript Error!');
				#end
			}
		}

		return null;
	}

	override function destroy() {
		super.destroy();
		parser = null;
		interp = null;
	}
}