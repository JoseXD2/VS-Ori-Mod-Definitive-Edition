package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);
		bg.screenCenter();
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length)
			{
				if(leMods.length > 1 && leMods[0].length > 0) {
					var modSplit:Array<String> = leMods[i].split('|');
					if(!Paths.ignoreModFolders.contains(modSplit[0].toLowerCase()) && !modsAdded.contains(modSplit[0]))
					{
						if(modSplit[1] == '1')
							pushModCreditsToList(modSplit[0]);
						else
							modsAdded.push(modSplit[0]);
					}
				}
			}
		}

		var arrayOfFolders:Array<String> = Paths.getModDirectories();
		arrayOfFolders.push('');
		for (folder in arrayOfFolders)
		{
			pushModCreditsToList(folder);
		}
		#end

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			['Mod Credits'],
			['FinnYoung (Classic1926)',			'classic',						"Main Coder, Designer, and Creator of VS Ori Mod: Defintive Edition.",		'https://www.youtube.com/channel/UCKcqlPIGcsoiGl9qsasAJhw',	'F73838'],
			['Alucardseibie',				'AlucardSeibie_Icon',			"Charter, Composer (vocals), and Coder",							'https://www.youtube.com/channel/UCYzf5-SBHHSZE49MeWbhfig',	'FF4800'],
			['Doger',				'doge',							"Coder (lua), Designer, Charter, and Animator\n(I'm so sorry)",										'',	'07FF00'],
			['Voltex',					'voltex',					"Composer",										'https://gamebanana.com/mods/377146',	'FF29DC'],
			['OuroborosFinis',					'finis',			"Tester, Charter, and Composer (vocals)",						'https://gamebanana.com/members/2140151',	'FFFFFF'],
			['James Jamestar',					'james',			"Composer (vocals)",										'https://www.youtube.com/channel/UC-AOVV2VvyfW9pK4YtHoZTg',	'FFFFFF'],
			['TheZoeGamer12',					'placeholder',		"Artist",										'',	'FFFFFF'],
			['SkyBlueRed',						'placeholder',		"Artist",										'',	'FFFFFF'],
			['AndyBrawler',						'placeholder',		"Charter and Supporter",						'https://twitter.com/andybrawler',	'FFFFFF'],
			[''],
			['Previous Contributers'],
			['Rae the Spirit',					'epic-rae',						"Artist and Composer",										'https://www.youtube.com/channel/UCX69-OvH93IDsP7fHAYfRBA',	'B53300'],
			[''],
			['Psych Forever Credits'],
			['FinnYoung (Classic1926)',			'classic',						"Creator of Psych Forever Engine",		'https://www.youtube.com/channel/UCKcqlPIGcsoiGl9qsasAJhw',	'F73838'],
			[''],
			['Special Thanks'],
			['Doger',					'doge',								"Inspired me to work on this mod",							'',	'FF4800'],
			['CommunityGame',			'placeholder',						"Played OG Modpack release (v4.5)",		'https://www.youtube.com/c/CommunityGame',	'FFFFFF'],
			['BrandonThaGod',			'placeholder',						"Played v4.5.4",		'https://www.youtube.com/c/BrandonThaGod',	'FFFFFF'],
			['JLGaming',			'placeholder',							"Played v4.5.6",		'https://www.youtube.com/c/JLGamings',	'FFFFFF'],
			['Forever Nenaa',			'placeholder',						"Played v4.5.7",		'https://www.youtube.com/c/ForeverNenaa',	'FFFFFF'],
			['MarlonxAssassin',			'placeholder',						"Played v4.5.7",		'https://www.youtube.com/channel/UCfnfgQIxcGXpgTEz9qGEIdA',	'FFFFFF'],
			['izyaizya',				'placeholder',						"Played v4 Pre-release",		'https://www.youtube.com/channel/UCNQjLU36P_kHZxTqt_iUK1w',	'FFFFFF'],
			['Orseofkorse',				'placeholder',						"Explained the lore for the mod(-ish). Played OG Modpack Release (v4.5)",		'https://www.youtube.com/c/Orseofkorse',	'FFFFFF'],
			['Everyone who cheated',	'placeholder',						"fuck you",		'https://www.youtube.com/watch?v=iik25wqIuFo',	'FFFFFF'],
			[''],
			['Original Creators'],
			['Alucardseibie',					'AlucardSeibie_Icon',						"Original Creator of the VS Ori Mod",										'https://www.youtube.com/channel/UCX69-OvH93IDsP7fHAYfRBA',	'FF4800'],
			['Moon Studios',					'ori',			"Creator of the Ori Series, and the original track (Ya know, the instrumental)",										'',	'FFFFFF'],
			['Shadow Mario',		'shadowmario',		'Psych Engine',							'https://twitter.com/Shadow_Mario_',	'FFFFFF'],
			['shubs',				'shubs',			'Forever Engine',					'https://twitter.com/yoshubs',			'FFFFFF'],
			['Kade Dev',			'kadedev',			'Kade Engine',					'https://gamebanana.com/mods/44291',			'FFFFFF'],
			['Aflac',				'aflac',			'Project FNF Engine (the original)',					'https://github.com/aflacc/ProjectFNF',			'FFFFFF'],
			['Verwex',				'placeholder',					'Mic\'d Up',								'https://gamebanana.com/mods/44236',			'FFFFFF'],
			['SalnTheReclaimer',					'saln',						"Creator of Saln",										'',	'F73838'],
			['JellyFish!',		'jelly',						"Creator of FNF Neo",						'',	'FF0000'],
			['arzo, spirit warrior of niwen',		'arzo',						"Creator of Arzo // Yeah that's his entire username",						'',	'FF0000'],
		//	['OuroborosFinis',					'finis',			"Creator of Fin",										'',	'FFFFFF'],
			['FrozenLolbitYT',		'kuch',			"Creator of Kuch",						'https://www.youtube.com/channel/UCQ4vty3zHSXA5Kg3j7Dh6hw',	'FF0000'],
			['Pastel',					'ori1',			"Creator of Ori in Friday night funkin!",										'https://gamebanana.com/mods/294469',	'FFFFFF'],
			['Pustolovina',					'ori2',			"Creator of Ori and the Friday Night?",										'https://gamebanana.com/mods/313077',	'FFFFFF'],
			[''],
			['Psych Engine Team'],
			['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',							'https://twitter.com/Shadow_Mario_',	'444444'],
			['RiverOaken',			'riveroaken',		'Main Artist/Animator of Psych Engine',						'https://twitter.com/RiverOaken',		'C30085'],
			['shubs',				'shubs',			'Additional Programmer of Psych Engine',					'https://twitter.com/yoshubs',			'279ADC'],
			[''],
			['Former Engine Members'],
			['bb-panzu',			'bb-panzu',			'Ex-Programmer of Psych Engine',							'https://twitter.com/bbsub3',			'389A58'],
			[''],
			['Engine Contributors'],
			['iFlicky',				'iflicky',			'Composer of Psync and Tea Time\nMade the Dialogue Sounds',	'https://twitter.com/flicky_i',			'AA32FE'],
			['SqirraRNG',			'gedehari',			'Chart Editor\'s Sound Waveform base',						'https://twitter.com/gedehari',			'FF9300'],
			['PolybiusProxy',		'polybiusproxy',	'.MP4 Video Loader Extension',								'https://twitter.com/polybiusproxy',	'FFEAA6'],
			['Keoiki',				'keoiki',			'Note Splash Animations',									'https://twitter.com/Keoiki_',			'FFFFFF'],
			['Smokey',				'smokey',			'Spritemap Texture Support',								'https://twitter.com/Smokey_5_',		'4D5DBD'],
			[''],
			["Funkin' Crew"],
			['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",						'https://twitter.com/ninja_muffin99',	'F73838'],
			['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",							'https://twitter.com/PhantomArcade3K',	'FFBB1B'],
			['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",							'https://twitter.com/evilsk8r',			'53E52C'],
			['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",							'https://twitter.com/kawaisprite',		'6475F3']
		];
		
		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			optionText.yAdd -= 70;
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Paths.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
		}
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		bg.color = getCurrentBGColor();
		intendedColor = bg.color;
		changeSelection();
		#if android
		addVirtualPad(UP_DOWN, A_B);
		#end
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-1 * shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(1 * shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT) {
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new ExtrasMenuState());
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			if(!item.isBold)
			{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if(item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
					item.forceX = item.x;
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
					item.forceX = item.x;
				}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int =  getCurrentBGColor();
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];
	function pushModCreditsToList(folder:String)
	{
		if(modsAdded.contains(folder)) return;

		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
		modsAdded.push(folder);
	}
	#end

	function getCurrentBGColor() {
		var bgColor:String = creditsStuff[curSelected][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
