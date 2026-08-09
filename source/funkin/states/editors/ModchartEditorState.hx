package funkin.states.editors;

import haxe.ui.backend.flixel.UIState;

import funkin.video.FunkinVideoSprite;

import openfl.Lib;

class ModchartEditorState extends UIState
{
    override function create()
    {
        super.create();

        Lib.application.window.onClose.removeAll();

        var joobi:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("editors/joobiLaugh"));
        joobi.screenCenter();
        add(joobi);

        var text:FlxText = new FlxText(0, 600, FlxG.width, "I am NOT adding that shit.", 24);
        text.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.borderSize = 1.25;
        add(text);

        new FlxTimer().start(2, (t:FlxTimer) -> {
            addPolyester();
        });

        new FlxTimer().start(600, (t:FlxTimer) -> {
            FlxG.switchState(new MainMenuState());
        });
    }

    function addPolyester()
    {
        new FlxTimer().start(3, (t:FlxTimer) -> {
            var polyester:FunkinVideoSprite = new FunkinVideoSprite(FlxG.random.int(10, 900), FlxG.random.int(10, 500));
            polyester.load(Paths.video('polyesterMan'));
            polyester.onFormat(() -> {
                polyester.setGraphicSize(0, FlxG.height / 3.5);
                polyester.updateHitbox();
            });
            polyester.play();
            polyester.onStart(() -> {
                addPolyester();
            });
            polyester.onEnd(() -> {
                polyester.stop();
                polyester.destroy();
                polyester = null;
            });
            polyester.zIndex = FlxG.random.int(1, 10);
            add(polyester);

            refreshZ();
        });
    }
}