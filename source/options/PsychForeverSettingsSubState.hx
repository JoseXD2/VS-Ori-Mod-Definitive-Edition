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

class PsychForeverSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Psych Forever Setings';
		rpcTitle = 'Psych Forever Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Botplay',
		'If checked, The bot will play the game for you. However you can\'t get any score.',
		'botplay',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Memory',
		'If checked, The game will display the memory (FPS Counter must be enabled)',
		'memorylevel',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Anti-Mash',
		'If checked, mashing will make you miss\n(Not reccomended in some songs)',
		'antimash',
		'bool',
		true);
		addOption(option);

		var option:Option = new Option('Late Damage',
		'If checked, Getting bads and shits will hurt you\nAs well shits making you miss\n(Not reccomended in some songs)',
		'lateDamage',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Grade Rank',
		'If checked, Your rank will show as Kade Engine\'s (and Mic\'d Up) grading system. Otherwise it shows Psych Engine\'s rating',
		'newrank',
		'bool',
		true);
		addOption(option);

		var option:Option = new Option('Reduced Movements',
		'If checked, The screen will have less movements (example: the cam shake in RTL). This can reduce motion sickness or increase performance.',
		'reducedmovements',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Opponent Note Splash',
		'If checked, opponents will have note splashes when they hit a note.\n(Note splashes must be enabled for this to work!)',
		'opponentnotesplashes',
		'bool',
		true);
		addOption(option);

		var option:Option = new Option('Song Watermarks',
		'If checked, It will show the song info on the bottom right, as well with credits.',
		'watermarks',
		'bool',
		true);
		addOption(option);

		#if debug
		var option:Option = new Option('Menu Music:',
		"What song do you prefer for the main menu?",
		'menuMusic',
		'string',
		'Getting Freaky',
		['Getting Freaky', 'Still', 'Will of the Wisps', 'B-Sides', 'Funky', 'Tea Time']);
		addOption(option);
		option.onChange = onChangeMenuMusic;

		var option:Option = new Option('Debug Mode',
		'If checked, You are able to use chart editor and stuff like that. Not Reccomended for Normal Gameplay',
		'debugmode',
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