package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import openfl.Lib;

using StringTools;

class ModdedSpecificSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Modded Specific';
		rpcTitle = 'Modded Specific Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Disable Achievements',
		'If checked, Achievements will be disabled. This can be used to prevent crashes.\n(Reccomended)',
		'disabledachievements',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Skip Warnings',
		'If checked, Warnings for flashing lights and stuff will be ignored automatically\n(Reccomended)',
		'skipwarnings',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Health Type:',
		"Choose which health type it should use.\n(v3 Classic: No long note healing, v4: Normal health gain, Old: Low health gain)",
		'healthtype',
		'string',
		'v3 Classic',
		['v3 Classic', 'v4', 'Old']);
		addOption(option);
		
		var option:Option = new Option('Override Menu Music',
		'If checked, All music will be overrided with the one you selected.',
		'overridemusiclol',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Menu Music:',
		"What song do you prefer for the main menu? (May require a game restart to take effect. VERY UNFINISHED)",
		'menuMusic',
		'string',
		'Still',
		['Still', 'Blind-Forest-Prototype', 'Forest-Rhythms']);
		addOption(option);
		option.onChange = onChangeMenuMusic;

		var option:Option = new Option('Version:',
		"Choose which version of the designs and visuals\n(Very Unfinished!)",
		'legacyver',
		'string',
		'v4.5',
		['v4.5', 'DE Classic', 'OG VS Ori Mod']);
		addOption(option);

		var option:Option = new Option('Camera Movements',
		'If checked, the camera will move to the arrows.',
		'followarrow',
		'bool',
		true);
		addOption(option);

		var option:Option = new Option('Mechanics',
		'If unchecked, there will be no mechanics.\naka you\'re a pussy.\n(Very Unfinished!)',
		'mechanicslol',
		'bool',
		true);
		addOption(option);

		var option:Option = new Option('Modcharts',
		'If checked, notes will be able to move and stuff like that. Reccomended enabled for the best experience.\n(Very Unfinished!)',
		'modcharts',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Disable Vocals',
		'If checked, the vocals will not play during a song.\n(Note: some songs doesn\'t have a vocal track!)',
		'disablevocals',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Screen Shake',
		'If checked, the screen will shake in some songs.\n(Reccomended off for increased performance | Not to be confused with Reduced Movements)',
		'screenshakeenabled',
		'bool',
		true);
		addOption(option);

	/*	var option:Option = new Option('Animated Icons',
		'If checked, The icons will show animated',
		'animatedicons',
		'bool',
		true);
		addOption(option);*/

		var option:Option = new Option('Taunt',
		'If checked, pressing whatever the taunt key will make the player taunt.',
		'tauntability',
		'bool',
		true);
		addOption(option);

		var option:Option = new Option('Longer Health',
		'If checked, your healthbar will appear longer.\n(This does not give you more health!)',
		'longhealth',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Hide FC Rank',
		'If checked, the fc rank on the bottom right will hide itself.\n(reccomended for downscroll).',
		'hideFCRank',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Display Mechanic Tutorials',
		'If checked, it will show ingame mechanic tutorials.',
		'displayTut',
		'bool',
		true);
		addOption(option);

		var option:Option = new Option('Animated Icons',
		'If checked, the icons will be animated, not reccomended with icon bop.\n(THIS IS DISCONTINUED AND MAY BREAK!)',
		'animatedicons',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Icon Bop',
		'If checked, the icon bop will always play, not reccomended with animated icons.',
		'iconbop',
		'bool',
		true);
		addOption(option);

		#if debug
		var option:Option = new Option('Ori HUD',
		'If checked, The hud will mostly appear as the ori hud (WIP)',
		'orihpbar',
		'bool',
		false);
		addOption(option);
		#end

		super();
	}

	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:Dynamic = sprite; //Make it check for FlxSprite instead of FlxBasic
			var sprite:FlxSprite = sprite; //Don't judge me ok
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.globalAntialiasing;
			}
		}
	}

	var changedMusic:Bool = false;
	function onChangeMenuMusic()
	{
		if(ClientPrefs.menuMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.menuMusic)));

		changedMusic = true;
	}

	function onChangeFramerate()
	{
		if(ClientPrefs.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.framerate;
			FlxG.drawFramerate = ClientPrefs.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.framerate;
			FlxG.updateFramerate = ClientPrefs.framerate;
		}
	}
}