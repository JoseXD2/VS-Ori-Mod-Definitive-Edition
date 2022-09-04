package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class PURSelectSongState extends MusicBeatState
{
	public static var psychEngineVersion:String = '4.1.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public static var firstStart:Bool = true;
	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	public var songDiff:FlxSprite;
	public var selecticons:FlxSprite;
	public static var finishedFunnyMove:Bool = false;
	var optionShit:Array<String> = [
		'corrupurgation',
		'defeat'
	//	'think',
	//	'shriek-and-ori',
	//	'deformation'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('purgatoryMenu'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('purgatoryMenu'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
	//	magenta.color = 0xFFfd719b;
		add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

	/*
			for (i in 0...optionShit.length)
				{
					var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
					var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
					menuItem.scale.x = scale;
					menuItem.scale.y = scale;
					menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
					menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
					menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
					menuItem.animation.play('idle');
					menuItem.ID = i;
					menuItem.screenCenter(X);
					menuItems.add(menuItem);
					var scr:Float = (optionShit.length - 4) * 0.135;
					if(optionShit.length < 6) scr = 0;
					menuItem.scrollFactor.set(0, scr);
					menuItem.antialiasing = ClientPrefs.globalAntialiasing;
					//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
					menuItem.updateHitbox();
				}*/
		for (i in 0...optionShit.length)
			{
				var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
				var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			//	menuItem.frames = tex;
				menuItem.scale.x = scale;
				menuItem.scale.y = scale;
				menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.screenCenter(X);
				menuItems.add(menuItem);
				menuItem.scrollFactor.set(0, 1);
				menuItem.antialiasing = ClientPrefs.globalAntialiasing;
				if (firstStart)
					FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
						{
							finishedFunnyMove = true; 
							changeItem();
						}});
				else
					menuItem.y = 60 + (i * 160);
			}

		FlxG.camera.follow(camFollowPos, null, 1);

		songDiff = new FlxSprite();
		songDiff.frames = Paths.getSparrowAtlas('song_difficulties');
		songDiff.animation.addByPrefix('easy', 'easy0', 1, true);
		songDiff.animation.addByPrefix('normal', 'normal0', 1, true);
		songDiff.animation.addByPrefix('hard', 'hard0', 1, true);
		songDiff.animation.addByPrefix('extreme', 'extreme0', 1, true);
		songDiff.animation.addByPrefix('auto', 'auto0', 1, true);
		songDiff.x = 800;
		songDiff.y = 500;
		songDiff.scrollFactor.set();
	//	songDiff.y = 100;
		songDiff.antialiasing = ClientPrefs.globalAntialiasing;
		add(songDiff);

		selecticons = new FlxSprite();
		selecticons.frames = Paths.getSparrowAtlas('selectsong_icons');
		selecticons.animation.addByPrefix('arzo', 'arzo vs ori0', 1, true);
		selecticons.animation.addByPrefix('pastel', 'shriek old vs ori pastel0', 1, true);
		selecticons.animation.addByPrefix('think', 'finn vs ori0', 1, true);
		selecticons.animation.addByPrefix('raylo', 'something vs raylo0', 1, true);
		selecticons.x = 900;
		selecticons.y = 300;
		selecticons.scrollFactor.set();
		selecticons.antialiasing = ClientPrefs.globalAntialiasing;
		add(selecticons);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (curSelected == 0 || curSelected == 1) {
			songDiff.animation.play('extreme', true);
			selecticons.animation.play('arzo', true);
		}
		if (curSelected == 4) {
			songDiff.animation.play('extreme', true);
			selecticons.animation.play('raylo', true);
		}
		if (curSelected == 3) {
			songDiff.animation.play('hard', true);
			selecticons.animation.play('pastel', true);
		}
		if (curSelected == 2) {
			songDiff.animation.play('easy', true);
			selecticons.animation.play('think', true);
		}

		if (curSelected == 5) {
			songDiff.alpha = 0;
			selecticons.alpha = 0;
		} else {
			songDiff.alpha = 1;
			selecticons.alpha = 1;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new PURWeekState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if (curSelected != 4) {
						FlxG.sound.play(Paths.sound('storySelect'));
					//	PlayState.isStoryMode = true; // a
					}

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'corrupurgation':
										PlayState.SONG = Song.loadFromJson('corrupurgation', 'corrupurgation');
										LoadingState.loadAndSwitchState(new PlayState());
									case 'defeat':
										PlayState.SONG = Song.loadFromJson('defeat', 'defeat');
										LoadingState.loadAndSwitchState(new PlayState());
									case 'think':
										PlayState.SONG = Song.loadFromJson('think', 'think');
										LoadingState.loadAndSwitchState(new PlayState());
									case 'shriek-and-ori':
										PlayState.SONG = Song.loadFromJson('shriek-and-ori', 'shriek-and-ori');
										LoadingState.loadAndSwitchState(new PlayState());
									case 'deformation':
										PlayState.SONG = Song.loadFromJson('deformation', 'deformation');
										LoadingState.loadAndSwitchState(new PlayState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
