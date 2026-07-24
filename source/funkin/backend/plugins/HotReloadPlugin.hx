package funkin.backend.plugins;

import flixel.addons.transition.FlxTransitionableState;

import funkin.input.Controls;

/**
 * Plugin that allows easy state reloading
 * 
 * 
 * press F5 to reload the state
 * 
 * press F6 to reload and refresh memory
 */
@:nullSafety
class HotReloadPlugin extends FlxBasic
{
	@:nullSafety(Off)
	static var instance:HotReloadPlugin;
	
	public static function init()
	{
		if (instance == null)
		{
			FlxG.plugins.addPlugin(instance = new HotReloadPlugin());
			#if debug
			FlxG.console.registerClass(HotReloadPlugin);
			#end
		}
	}
	
	public function new()
	{
		super();
		this.visible = false;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		#if !debug
		if (!ClientPrefs.inDevMode) return;
		#end

		if (Controls.instance.DISPLAY)
		{
			final fpsTypeArray:Array<String> = ['Simple', 'Advanced', 'Disabled'];
			ClientPrefs.fpsDisplayType = fpsTypeArray[FlxMath.wrap(fpsTypeArray.indexOf(ClientPrefs.fpsDisplayType) + 1, 0, fpsTypeArray.length - 1)];
		}
		
		if (Controls.instance.SOFTRELOAD)
		{
			FlxTransitionableState.skipNextTransIn = FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
			
			Mods.applyModConfig();
		}
		
		if (Controls.instance.HARDRELOAD)
		{
			FlxG.signals.preStateCreate.addOnce((state) -> {
				FunkinAssets.cache.clearStoredMemory();
				FunkinAssets.cache.clearUnusedMemory();
			});
			ModPlugin.instance.populate();
			
			FlxTransitionableState.skipNextTransIn = FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
			
			Mods.applyModConfig();
		}
	}
}
