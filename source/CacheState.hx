package;

import haxe.io.Path;
import sys.FileSystem;

using StringTools;

class CacheState extends MusicBeatState {
    override function create() {
        super.create();

        cacheFolders("assets/images", ".png", function(scriptPath:String) {
            // should be cache in
            Paths.imagesFile.push(scriptPath);
            trace(Paths.imagesFile);
        });
    }

    function cacheFolders(nameFolder:String, whatExt:String = ".png", whatGonnaDo:String->Void) {
        var files = FileSystem.readDirectory(nameFolder);
        for (file in files) {
            if (file.endsWith(whatExt)) {
                var scriptPath = Path.join([nameFolder, file]);
                whatGonnaDo(scriptPath);
            }
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}