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

    override function changeSelection(change:Int = 0) {
        super.changeSelection(change);

        switch (menu[curSelected].toLowerCase()) {
            case "ghost tap": changeMenuText("Play least miss with this");
            case "downscroll": changeMenuText("Change from upscroll to downscroll");
            case "count miss note as miss": changeMenuText("Will make note was missing count as a miss");
        }
    }
}