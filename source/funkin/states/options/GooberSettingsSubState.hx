package funkin.states.options;

import flixel.FlxG;

class GooberSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Gooober Settings';
		rpcTitle = 'Gooober Settings Menu'; // for Discord Rich Presence
		
		var option:Option = new Option('Fancy Preview', "If enabled, a preview will be shown after taking a screenshot.", 'fancyPreview', BOOL, true);
		addOption(option);
		
		var option:Option = new Option('Preview on save', "If enabled, the preview will be shown only after a screenshot is saved.", 'previewOnSave', BOOL, true);
		addOption(option);
		
		super();
	}
}
