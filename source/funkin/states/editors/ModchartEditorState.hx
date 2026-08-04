package funkin.states.editors;

import haxe.ui.backend.flixel.UIState;

import funkin.video.FunkinVideoSprite;

class ModchartEditorState extends UIState
{
    override function create()
    {
        super.create();

        new FlxTimer().start(FlxG.random.int(2, 5), (t:FlxTimer) -> {
            var polyester:FunkinVideoSprite = new FunkinVideoSprite(0, 0);
            polyester.load(Paths.video('polyesterMan'));
            polyester.onFormat(() -> {
                polyester.setGraphicSize(0, FlxG.height);
                polyester.updateHitbox();
                polyester.screenCenter();
            });
            polyester.play();
            polyester.onEnd(() -> {
                FlxG.switchState(new MainMenuState());
            });
            add(polyester);
        });
    }
}