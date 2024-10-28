package options.menu;

class GameplaySub extends BaseSub
{
    override function create() {
        super.create();

        menu = [
            "Ghost tap",
            "Downscroll",
            "Count miss note as misses"
        ];
        regenMenu();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}