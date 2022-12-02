package;

import flixel.graphics.FlxGraphic;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import Shaders;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import openfl.filters.ShaderFilter;
import Note.EventNote;
import openfl.events.KeyboardEvent;
import flixel.util.FlxSave;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;
import flash.system.System;
#if sys
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;

	public static var ratingStuff:Array<Dynamic> = [
		['Z- (You Suck!)', 0.05],
		['Z (You Suck!)', 0.2],
		['F (Shit)', 0.4],
		['E (Bad)', 0.5],
		['D (Meh)', 0.6],
		['C (Okay)', 0.7],
		['B (Good)', 0.8],
		['A- (Great)', 0.85],
		['A (Sick!)', 0.9],
		['A+ (Sick!)', 0.93],
		['S- (Sick!)', 0.965],
		['S (Sick!)', 0.99],
		['S+ (Sick!)', 0.997],
		['SS- (Sick!)', 0.998],
		['SS (Sick!)', 0.999],
		['SS+ (Sick!)', 0.9995],
		['X- (Sick!)', 0.9997],
		['X (Sick!)', 0.9998],
		['X+ (Sick!)', 1],
		['PER (Perfect!!)', 1]
	];
	
	public static var ratingStuffOLD:Array<Dynamic> = [
		['Z- (You Suck!)', 0.05],
		['Z (You Suck!)', 0.2],
		['F (Shit)', 0.4],
		['E (Bad)', 0.5],
		['D (Meh)', 0.6],
		['C (Okay)', 0.7],
		['B (Good)', 0.8],
		['A- (Great)', 0.85],
		['A (Sick!)', 0.9],
		['A+ (Sick!)', 0.93],
		['S- (Sick!)', 0.965],
		['S (Sick!)', 0.99],
		['S+ (Sick!)', 0.997],
		['SS- (Sick!)', 0.998],
		['SS (Sick!)', 0.999],
		['SS+ (Sick!)', 0.9995],
		['X- (Sick!)', 0.9997],
		['X (Sick!)', 0.9998],
		['X+ (Sick!)', 1],
		['PER (Perfect!!)', 1]
	];

	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, ModchartText> = new Map<String, ModchartText>();
	public var modchartSaves:Map<String, FlxSave> = new Map<String, FlxSave>();
	//event variables
	private var isCameraOnForcedPos:Bool = false;
	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	#else
	public var boyfriendMap:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	#end
	var notesHitArray:Array<Date> = [];
	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;

	public var bopslol:Int = 4;

	public var songSpeedTween:FlxTween;
	public var songSpeed(default, set):Float = 1;
	public var songSpeedType:String = "multiplicative";
	public var noteKillOffset:Float = 350;
	
	public var boyfriendGroup:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;
	public static var curStage:String = '';
	public static var isPixelStage:Bool = false;
	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var characteroverride:String = "none";
	public static var formoverride:String = "none";
	public static var curmult:Array<Float> = [1, 1, 1, 1];
	public var vocals:FlxSound;
//	public var shaderUpdates:Array<Float->Void> = [];
	public var dad:Character = null;
	public var gf:Character = null;
	public var boyfriend:Boyfriend = null;
	public var healyou:Bool = true;
	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<EventNote> = [];
	#if android
	public var screenshader:Shaders.PulseEffect = new PulseEffect();
	#end
	private var strumLine:FlxSprite;
	private var shakeCam:Bool = false;
	//Handles the new epic mega sexy cam code that i've done
	private var camFollow:FlxPoint;
	private var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;
	public var fuckyoumodchart:Bool = false;
	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	public var emergencyheallmao:FlxText;
	public var challengeshitlol:FlxText;
	public var camZooming:Bool = false;
	private var curSong:String = "";
	public var elapsedtime:Float = 0;
	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;
	private var allSicks:Bool = true;
	private var hadbeenrescued:Bool = false;
	private var healthBarBG:AttachedSprite;
	private var mechtut:AttachedSprite;
	private var oriHPBG:AttachedSprite;
	public var healthBar:FlxBar;
	var songPercent:Float = 0;

	private var pushrankdownlmao:Int = 0;

	private var shakeCamALT:Bool = false;


	private var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;
	public var oriTIMEBG:FlxSprite;
	public var sickrows:Int = 0;
	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;
	public var shaderUpdates:Array<Float->Void> = [];
	public var camGameShaders:Array<ShaderEffect> = [];
	public var camHUDShaders:Array<ShaderEffect> = [];
	public var camOtherShaders:Array<ShaderEffect> = [];
	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	public var startingSong:Bool = false;
	private var updateTime:Bool = true;
	public static var changedDifficulty:Bool = false;
	public static var chartingMode:Bool = false;

	//Gameplay settings
	public var healthGain:Float = 1;
	public var healthLoss:Float = 1;
	public var instakillOnMiss:Bool = false;
	public var cpuControlled:Bool = false;
	public var mechanicslolingame:Bool = true;
	public var modchartslol:Bool = true;
	public var practiceMode:Bool = false;
	public var ghostTapping:Bool = ClientPrefs.ghostTapping;

//	public var modifierlevel:Float = 1;

	public var botplaySine:Float = 0;
	public var botplayTxt:FlxText;
//	var fcrank:String;
	var fcLevel:FlxSprite;
	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	public var cameraSpeed:Float = 1;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialogueJson:DialogueFile = null;

	var bfa:Int;
	var bfaa:Int;
	var bfaaa:Int;
	var dada:Int;
	var dadaa:Int;
	var dadaaa:Int;

	//Fucking Mechanic Shit lolololloollol
	public static var poisonstacks:Int = 0;

	var halloweenBG:BGSprite;
	var halloweenWhite:BGSprite;
//	var songWatermark:FlxText;
	var phillyCityLights:FlxTypedGroup<BGSprite>;
	var phillyTrain:BGSprite;
	var blammedLightsBlack:ModchartSprite;
	var blammedLightsBlackTween:FlxTween;
	var phillyCityLightsEvent:FlxTypedGroup<BGSprite>;
	var phillyCityLightsEventTween:FlxTween;
	var trainSound:FlxSound;
	var judgementCounter:FlxText;
	var limoKillingState:Int = 0;
	var limo:BGSprite;
	var limoMetalPole:BGSprite;
	var limoLight:BGSprite;
	var limoCorpse:BGSprite;
	var limoCorpseTwo:BGSprite;
	var bgLimo:BGSprite;
	var grpLimoParticles:FlxTypedGroup<BGSprite>;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:BGSprite;
	var songinfo:FlxSprite;
//	var fcLevel:FlxSprite;
	var rankLevel:FlxSprite;
	var upperBoppers:BGSprite;
	var bottomBoppers:BGSprite;
	var santa:BGSprite;
	var heyTimer:Float;
	var arrowJunks:Array<Array<Float>> = [];
	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	var bgGhouls:BGSprite;
	public var curbg:FlxSprite;
	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;
	public var scoreTxt:FlxText;
	public var songWatermark:FlxText;
	public var credits:String;
	public var songinfonew:FlxText;
	public var composerslol:String;
	public var engineVerwatermark:FlxText;
	public var creditsWatermark:FlxText;
	public var leTxt:FlxText;
	public var flipcamlol:Bool = false;
	public var fuckingangle:Int = 0;
	var timeTxt:FlxText;
	var timeTxtTween:FlxTween;
	var fclevelTween:FlxTween;
	var scoreTxtTween:FlxTween;
	var isDadGlobal:Bool = true;
	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;
	public var enablepoisonlol:Bool = false;

	public var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;
	private var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var inCutscene:Bool = false;
	public var skipCountdown:Bool = false;
	var songLength:Float = 0;
	var healticks:Int = 0;
	public var boyfriendCameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	//Achievement shit
	var keysPressed:Array<Bool> = [];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	// Lua shit
	public static var instance:PlayState;
	public var luaArray:Array<FunkinLua> = [];
	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	public var introSoundsSuffix:String = '';

	// Debug buttons
	private var debugKeysChart:Array<FlxKey>;
	private var debugKeysCharacter:Array<FlxKey>;
	private var tauntlol:Array<FlxKey>;
	private var heallmao:Array<FlxKey>;
	// Less laggy controls
	private var keysArray:Array<Dynamic>;

	override public function create()
	{
		Paths.clearStoredMemory();

		// for lua
		instance = this;

		debugKeysChart = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		debugKeysCharacter = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));
		tauntlol = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('tauntkey'));
		heallmao = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('heallmao'));
		PauseSubState.songName = null; //Reset to default

		keysArray = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
		];

		CoolUtil.precacheSound('heal1');
		CoolUtil.precacheSound('heal2');
		CoolUtil.precacheSound('heal3');

		// For the "Just the Two of Us" achievement
		for (i in 0...keysArray.length)
		{
			keysPressed.push(false);
		}

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// Gameplay settings
		healthGain = ClientPrefs.healthgain;
		ghostTapping = ClientPrefs.ghostTapping;
		healthLoss = ClientPrefs.healthloss;
		instakillOnMiss = ClientPrefs.instakill;
		practiceMode = ClientPrefs.practice;
		cpuControlled = ClientPrefs.botplay;
		mechanicslolingame = ClientPrefs.mechanicslol;
		modchartslol = ClientPrefs.modcharts;

	/*	if (ClientPrefs.bigball)
			modifierlevel += 0.2;

		if (ClientPrefs.instakill)
			modifierlevel += 2.0;

		if (ClientPrefs.fcmode)
			modifierlevel += 4.0;

		if (ClientPrefs.gfcmode)
			modifierlevel += 6.0;

		if (ClientPrefs.sickmode)
			modifierlevel += 8.0;*/

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camOther);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		FlxCamera.defaultCameras = [camGame];
		CustomFadeTransition.nextCamera = camOther;
		//FlxG.cameras.setDefaultDrawTarget(camGame, true);

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		#if desktop
		storyDifficultyText = CoolUtil.difficulties[storyDifficulty];

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: " + WeekData.getCurrentWeek().weekName;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		#end

		GameOverSubstate.resetVariables();
		var songName:String = Paths.formatToSongPath(SONG.song);

		curStage = PlayState.SONG.stage;
		//trace('stage is: ' + curStage);
		if(PlayState.SONG.stage == null || PlayState.SONG.stage.length < 1) {
			switch (songName)
			{
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly' | 'philly-nice':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'limo';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				default:
					curStage = 'stage';
			}
		}

		var stageData:StageFile = StageData.getStageFile(curStage);
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,
			
				boyfriend: [770, 100],
				girlfriend: [400, 130],
				opponent: [100, 100],
				hide_girlfriend: false,
			
				camera_boyfriend: [0, 0],
				camera_opponent: [0, 0],
				camera_girlfriend: [0, 0],
				camera_speed: 1
			};
		}

		defaultCamZoom = stageData.defaultZoom;
		isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		if(stageData.camera_speed != null)
			cameraSpeed = stageData.camera_speed;

		boyfriendCameraOffset = stageData.camera_boyfriend;
		if(boyfriendCameraOffset == null) //Fucks sake should have done it since the start :rolling_eyes:
			boyfriendCameraOffset = [0, 0];

		opponentCameraOffset = stageData.camera_opponent;
		if(opponentCameraOffset == null)
			opponentCameraOffset = [0, 0];
		
		girlfriendCameraOffset = stageData.camera_girlfriend;
		if(girlfriendCameraOffset == null)
			girlfriendCameraOffset = [0, 0];

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);

		switch (curStage)
		{
			case 'stage': //Week 1
				var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
				add(bg);

				var stageFront:BGSprite = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				add(stageFront);
				if(!ClientPrefs.lowQuality) {
					var stageLight:BGSprite = new BGSprite('stage_light', -125, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					add(stageLight);
					var stageLight:BGSprite = new BGSprite('stage_light', 1225, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					stageLight.flipX = true;
					add(stageLight);

					var stageCurtains:BGSprite = new BGSprite('stagecurtains', -500, -300, 1.3, 1.3);
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					add(stageCurtains);
				}

			case 'spooky': //Week 2
				if(!ClientPrefs.lowQuality) {
					halloweenBG = new BGSprite('halloween_bg', -200, -100, ['halloweem bg0', 'halloweem bg lightning strike']);
				} else {
					halloweenBG = new BGSprite('halloween_bg_low', -200, -100);
				}
				add(halloweenBG);

				halloweenWhite = new BGSprite(null, -FlxG.width, -FlxG.height, 0, 0);
				halloweenWhite.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.WHITE);
				halloweenWhite.alpha = 0;
				halloweenWhite.blend = ADD;

				//PRECACHE SOUNDS
				CoolUtil.precacheSound('thunder_1');
				CoolUtil.precacheSound('thunder_2');

			case 'philly': //Week 3
				if(!ClientPrefs.lowQuality) {
					var bg:BGSprite = new BGSprite('philly/sky', -100, 0, 0.1, 0.1);
					add(bg);
				}
				
				var city:BGSprite = new BGSprite('philly/city', -10, 0, 0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<BGSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:BGSprite = new BGSprite('philly/win' + i, city.x, city.y, 0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					phillyCityLights.add(light);
				}

				if(!ClientPrefs.lowQuality) {
					var streetBehind:BGSprite = new BGSprite('philly/behindTrain', -40, 50);
					add(streetBehind);
				}

				phillyTrain = new BGSprite('philly/train', 2000, 360);
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				CoolUtil.precacheSound('train_passes');
				FlxG.sound.list.add(trainSound);

				var street:BGSprite = new BGSprite('philly/street', -40, 50);
				add(street);

			case 'limo': //Week 4
				var skyBG:BGSprite = new BGSprite('limo/limoSunset', -120, -50, 0.1, 0.1);
				add(skyBG);

				if(!ClientPrefs.lowQuality) {
					limoMetalPole = new BGSprite('gore/metalPole', -500, 220, 0.4, 0.4);
					add(limoMetalPole);

					bgLimo = new BGSprite('limo/bgLimo', -150, 480, 0.4, 0.4, ['background limo pink'], true);
					add(bgLimo);

					limoCorpse = new BGSprite('gore/noooooo', -500, limoMetalPole.y - 130, 0.4, 0.4, ['Henchmen on rail'], true);
					add(limoCorpse);

					limoCorpseTwo = new BGSprite('gore/noooooo', -500, limoMetalPole.y, 0.4, 0.4, ['henchmen death'], true);
					add(limoCorpseTwo);

					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}

					limoLight = new BGSprite('gore/coldHeartKiller', limoMetalPole.x - 180, limoMetalPole.y - 80, 0.4, 0.4);
					add(limoLight);

					grpLimoParticles = new FlxTypedGroup<BGSprite>();
					add(grpLimoParticles);

					//PRECACHE BLOOD
					var particle:BGSprite = new BGSprite('gore/stupidBlood', -400, -400, 0.4, 0.4, ['blood'], false);
					particle.alpha = 0.01;
					grpLimoParticles.add(particle);
					resetLimoKill();

					//PRECACHE SOUND
					CoolUtil.precacheSound('dancerdeath');
				}

				limo = new BGSprite('limo/limoDrive', -120, 550, 1, 1, ['Limo stage'], true);

				fastCar = new BGSprite('limo/fastCarLol', -300, 160);
				fastCar.active = true;
				limoKillingState = 0;

			case 'mall': //Week 5 - Cocoa, Eggnog
				var bg:BGSprite = new BGSprite('christmas/bgWalls', -1000, -500, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				if(!ClientPrefs.lowQuality) {
					upperBoppers = new BGSprite('christmas/upperBop', -240, -90, 0.33, 0.33, ['Upper Crowd Bob']);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);

					var bgEscalator:BGSprite = new BGSprite('christmas/bgEscalator', -1100, -600, 0.3, 0.3);
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);
				}

				var tree:BGSprite = new BGSprite('christmas/christmasTree', 370, -250, 0.40, 0.40);
				add(tree);

				bottomBoppers = new BGSprite('christmas/bottomBop', -300, 140, 0.9, 0.9, ['Bottom Level Boppers Idle']);
				bottomBoppers.animation.addByPrefix('hey', 'Bottom Level Boppers HEY', 24, false);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:BGSprite = new BGSprite('christmas/fgSnow', -600, 700);
				add(fgSnow);

				santa = new BGSprite('christmas/santa', -840, 150, 1, 1, ['santa idle in fear']);
				add(santa);
				CoolUtil.precacheSound('Lights_Shut_off');

			case 'mallEvil': //Week 5 - Winter Horrorland
				var bg:BGSprite = new BGSprite('christmas/evilBG', -400, -500, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:BGSprite = new BGSprite('christmas/evilTree', 300, -300, 0.2, 0.2);
				add(evilTree);

				var evilSnow:BGSprite = new BGSprite('christmas/evilSnow', -200, 700);
				add(evilSnow);

			case 'school': //Week 6 - Senpai, Roses
				GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
				GameOverSubstate.loopSoundName = 'gameOver-pixel';
				GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
				GameOverSubstate.characterName = 'bf-pixel-dead';

				var bgSky:BGSprite = new BGSprite('weeb/weebSky', 0, 0, 0.1, 0.1);
				add(bgSky);
				bgSky.antialiasing = false;

				var repositionShit = -200;

				var bgSchool:BGSprite = new BGSprite('weeb/weebSchool', repositionShit, 0, 0.6, 0.90);
				add(bgSchool);
				bgSchool.antialiasing = false;

				var bgStreet:BGSprite = new BGSprite('weeb/weebStreet', repositionShit, 0, 0.95, 0.95);
				add(bgStreet);
				bgStreet.antialiasing = false;

				var widShit = Std.int(bgSky.width * 6);
				if(!ClientPrefs.lowQuality) {
					var fgTrees:BGSprite = new BGSprite('weeb/weebTreesBack', repositionShit + 170, 130, 0.9, 0.9);
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					fgTrees.updateHitbox();
					add(fgTrees);
					fgTrees.antialiasing = false;
				}

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				bgTrees.frames = Paths.getPackerAtlas('weeb/weebTrees');
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);
				bgTrees.antialiasing = false;

				if(!ClientPrefs.lowQuality) {
					var treeLeaves:BGSprite = new BGSprite('weeb/petals', repositionShit, -40, 0.85, 0.85, ['PETALS ALL'], true);
					treeLeaves.setGraphicSize(widShit);
					treeLeaves.updateHitbox();
					add(treeLeaves);
					treeLeaves.antialiasing = false;
				}

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));

				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();

				if(!ClientPrefs.lowQuality) {
					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
				}
			case 'Nevada2':
				GameOverSubstate.deathSoundName = 'finn-faints-because-saln-sliced-him-lmao';
				GameOverSubstate.characterName = 'ori';
				GameOverSubstate.loopSoundName = '';
			case 'oriforestrain':
				GameOverSubstate.deathSoundName = 'fucking_double_kill';
			case 'ginsotree':
				GameOverSubstate.deathSoundName = 'fucking_double_kill';
			case 'tape':
				GameOverSubstate.deathSoundName = 'finn-faints-because-saln-sliced-him-lmao';
				GameOverSubstate.characterName = 'ori';
				GameOverSubstate.loopSoundName = '';
			case 'ring-blue':
				GameOverSubstate.deathSoundName = 'finn-faints-because-saln-sliced-him-lmao';
				GameOverSubstate.characterName = 'ori';
				GameOverSubstate.loopSoundName = '';
			case 'forsetSALN' | 'wireframe' | 'blue' | 'forestSALNONE':
				GameOverSubstate.deathSoundName = 'finn-faints';
				GameOverSubstate.characterName = 'finn-player';
				GameOverSubstate.loopSoundName = '';
			case 'shrek':
				GameOverSubstate.deathSoundName = 'owe';
				GameOverSubstate.characterName = 'bf-fainting-or-rockedlol';
				GameOverSubstate.loopSoundName = '';
			case 'cliff':
				GameOverSubstate.deathSoundName = 'rayloFaint';
				GameOverSubstate.characterName = 'gone3';
				GameOverSubstate.loopSoundName = '';
			case 'schoolEvil': //Week 6 - Thorns
				GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
				GameOverSubstate.loopSoundName = 'gameOver-pixel';
				GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
				GameOverSubstate.characterName = 'bf-pixel-dead';

				/*if(!ClientPrefs.lowQuality) { //Does this even do something?
					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);
				}*/
				var posX = 400;
				var posY = 200;
				if(!ClientPrefs.lowQuality) {
					var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool', posX, posY, 0.8, 0.9, ['background 2'], true);
					bg.scale.set(6, 6);
					bg.antialiasing = false;
					add(bg);

					bgGhouls = new BGSprite('weeb/bgGhouls', -100, 190, 0.9, 0.9, ['BG freaks glitch instance'], false);
					bgGhouls.setGraphicSize(Std.int(bgGhouls.width * daPixelZoom));
					bgGhouls.updateHitbox();
					bgGhouls.visible = false;
					bgGhouls.antialiasing = false;
					add(bgGhouls);
				} else {
					var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool_low', posX, posY, 0.8, 0.9);
					bg.scale.set(6, 6);
					bg.antialiasing = false;
					add(bg);
				}

		}

		if(isPixelStage) {
			introSoundsSuffix = '-pixel';
		}

		add(gfGroup); //Needed for blammed lights

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dadGroup);
		add(boyfriendGroup);
		
		if(curStage == 'spooky') {
			add(halloweenWhite);
		}

		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

		if(curStage == 'philly') {
			phillyCityLightsEvent = new FlxTypedGroup<BGSprite>();
			for (i in 0...5)
			{
				var light:BGSprite = new BGSprite('philly/win' + i, -10, 0, 0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				phillyCityLightsEvent.add(light);
			}
		}


		// "GLOBAL" SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('scripts/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('scripts/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/scripts/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end
		

		// STAGE SCRIPTS
		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'stages/' + curStage + '.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}

		if(doPush) 
			luaArray.push(new FunkinLua(luaFile));
		#end

		if(!modchartSprites.exists('blammedLightsBlack')) { //Creates blammed light black fade in case you didn't make your own
			blammedLightsBlack = new ModchartSprite(FlxG.width * -0.5, FlxG.height * -0.5);
			blammedLightsBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
			var position:Int = members.indexOf(gfGroup);
			if(members.indexOf(boyfriendGroup) < position) {
				position = members.indexOf(boyfriendGroup);
			} else if(members.indexOf(dadGroup) < position) {
				position = members.indexOf(dadGroup);
			}
			insert(position, blammedLightsBlack);

			blammedLightsBlack.wasAdded = true;
			modchartSprites.set('blammedLightsBlack', blammedLightsBlack);
		}
		if(curStage == 'philly') insert(members.indexOf(blammedLightsBlack) + 1, phillyCityLightsEvent);
		blammedLightsBlack = modchartSprites.get('blammedLightsBlack');
		blammedLightsBlack.alpha = 0.0;

		#if android
		screenshader.waveAmplitude = 1;
                screenshader.waveFrequency = 2;
                screenshader.waveSpeed = 1;
                screenshader.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000, 100000);
		#end

		var gfVersion:String = SONG.gfVersion;
		if(gfVersion == null || gfVersion.length < 1) {
			switch (curStage)
			{
				case 'limo':
					gfVersion = 'gf-car';
				case 'mall' | 'mallEvil':
					gfVersion = 'gf-christmas';
				case 'school' | 'schoolEvil':
					gfVersion = 'gf-pixel';
				default:
					gfVersion = 'gf';
			}
			SONG.gfVersion = gfVersion; //Fix for the Chart Editor
		}

		if (!stageData.hide_girlfriend)
		{
			gf = new Character(0, 0, gfVersion);
			startCharacterPos(gf);
			gf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(gf);
			startCharacterLua(gf.curCharacter);
		}

		dad = new Character(0, 0, SONG.player2);
		startCharacterPos(dad, true);
		dadGroup.add(dad);
		startCharacterLua(dad.curCharacter);

		if (formoverride == "none" || formoverride == "default")
			{
				boyfriend = new Boyfriend(0, 0, SONG.player1);
			}
			else
			{
				boyfriend = new Boyfriend(0, 0, formoverride);
			}
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);
		startCharacterLua(boyfriend.curCharacter);
		
		var camPos:FlxPoint = new FlxPoint(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
		if(gf != null)
		{
			camPos.x += gf.getGraphicMidpoint().x + gf.cameraPosition[0];
			camPos.y += gf.getGraphicMidpoint().y + gf.cameraPosition[1];
		}

		if(dad.curCharacter.startsWith('gf')) {
			dad.setPosition(GF_X, GF_Y);
			if(gf != null)
				gf.visible = false;
		}

		switch(curStage)
		{
			case 'limo':
				resetFastCar();
				insert(members.indexOf(gfGroup) - 1, fastCar);
			
			case 'schoolEvil':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069); //nice
				insert(members.indexOf(dadGroup) - 1, evilTrail);

			case 'forsetSALN':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069); //nice
				insert(members.indexOf(dadGroup) - 1, evilTrail);
		}

		var file:String = Paths.json(songName + '/dialogue'); //Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file)) {
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
		}

		var file:String = Paths.txt(songName + '/' + songName + 'Dialogue'); //Checks for vanilla/Senpai dialogue
		if (OpenFlAssets.exists(file)) {
			dialogue = CoolUtil.coolTextFile(file);
		}
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = startNextDialogue;
		doof.skipDialogueThing = skipDialogue;

		Conductor.songPosition = -5000;

		poisonstacks = 0; // so your hp doesn't die instantly aaaa
		bopslol = 4;
		flipcamlol = false;
		fuckingangle = 0;
		enablepoisonlol = false;
		fuckyoumodchart = false;
		pushrankdownlmao = 0;

		var showTime:Bool = (ClientPrefs.timeBarType != 'Disabled');

		if (Paths.formatToSongPath(SONG.song) == 'deformation' || dad.curCharacter == 'nightmare-ori' || dad.curCharacter == 'saln-rage' || dad.curCharacter == 'nightmare-kuro' || dad.curCharacter == 'nightmare-shriek' || dad.curCharacter == 'evilori' || dad.curCharacter == 'shriek' || dad.curCharacter == 'kuro')
		oriTIMEBG = new AttachedSprite('orishit/evilTimeBar');
		else if (dad.curCharacter == 'saln-god' || dad.curCharacter == 'arzo' || dad.curCharacter == 'saln-god')
		oriTIMEBG = new AttachedSprite('orishit/HELLTimeBar');
		else
		oriTIMEBG = new AttachedSprite('orishit/oriTimeBar');
		oriTIMEBG.screenCenter(X);
		oriTIMEBG.scrollFactor.set();
		oriTIMEBG.visible = showTime;
		oriTIMEBG.alpha = 0;
		oriTIMEBG.x = 210;
		if (ClientPrefs.downScroll)
		oriTIMEBG.y = 564;	
		else
		oriTIMEBG.y = -45;
		oriTIMEBG.alpha = 0;
		add(oriTIMEBG);

		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("alex.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = showTime;
		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 44;

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.text = SONG.song;
		}
		updateTime = showTime;

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = showTime;
		timeBarBG.screenCenter(X);
	//	timeBarBG.color = FlxColor.WHITE;
		timeBarBG.color = dad.healthColorArray[0];
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;
		add(timeBarBG);

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();
	//	timeBar.createFilledBar(0xFF000000, dad.healthColorArray[0]);
		if (Paths.formatToSongPath(SONG.song) == 'lacuna')
		timeBar.createFilledBar(0xFF000000, 0xFF000000);
		else
		timeBar.createFilledBar(0xFF000000, FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]));
		// so basically the time bar color will choose from the opponent health bar color. Making them have different colors instead of white.
		timeBar.numDivisions = 1600;
		timeBar.alpha = 0;
		timeBar.visible = showTime;
		add(timeBar);
		add(timeTxt);
		timeBarBG.sprTracker = timeBar;

		// This is really complicated and shit, idfk how to explain how any of these works. Even though I made them lmao
		if (ClientPrefs.longhealth) {
		if (Paths.formatToSongPath(SONG.song) == 'deformation' || dad.curCharacter == 'nightmare-ori' || dad.curCharacter == 'saln-rage' || dad.curCharacter == 'nightmare-kuro' || dad.curCharacter == 'nightmare-shriek' || dad.curCharacter == 'evilori' || dad.curCharacter == 'shriek' || dad.curCharacter == 'kuro')
		oriHPBG = new AttachedSprite('orishit/evilHealthBar');
		else if (dad.curCharacter == 'saln-god' || dad.curCharacter == 'arzo' || dad.curCharacter == 'saln-god')
		oriHPBG = new AttachedSprite('orishit/HELLHealthBar');
		else
		oriHPBG = new AttachedSprite('orishit/oriHealthBar');
		}
		else {
		if (Paths.formatToSongPath(SONG.song) == 'deformation' || dad.curCharacter == 'nightmare-ori' || dad.curCharacter == 'saln-rage' || dad.curCharacter == 'nightmare-kuro' || dad.curCharacter == 'nightmare-shriek' || dad.curCharacter == 'evilori' || dad.curCharacter == 'shriek' || dad.curCharacter == 'kuro')
		oriTIMEBG = new AttachedSprite('orishit/evilTimeBar');
		else if (dad.curCharacter == 'saln-god' || dad.curCharacter == 'arzo' || dad.curCharacter == 'saln-god')
		oriTIMEBG = new AttachedSprite('orishit/HELLTimeBar');
		else
		oriTIMEBG = new AttachedSprite('orishit/oriTimeBar');	
		}
		oriHPBG.screenCenter(X);
		oriHPBG.scrollFactor.set();
		oriHPBG.visible = !ClientPrefs.hideHud;
		if (!ClientPrefs.longhealth)
		oriHPBG.x = 210
		else 
		oriHPBG.x = -10;


		if (ClientPrefs.longhealth) {
		if (ClientPrefs.downScroll)
			oriHPBG.y = 3;
		else
		oriHPBG.y = 564;
		}
		else {
		if (ClientPrefs.downScroll)
			oriHPBG.y = 9; // goodbye my penis	
		else
		oriHPBG.y = 555;
		}

		oriHPBG.alpha = 0;
		add(oriHPBG);

		if (CoolUtil.difficultyString() == 'ONELIFE' || CoolUtil.difficultyString() == 'EASIER')
			health += 2;

		if (ClientPrefs.orihpbar || CoolUtil.difficultyString() == 'ONELIFE' || CoolUtil.difficultyString() == 'EASIER') {
		healthBarBG = new AttachedSprite('SHORThealthBar');
		}
		else {
		if (ClientPrefs.longhealth)
		healthBarBG = new AttachedSprite('healthBarLONG')
		else
		healthBarBG = new AttachedSprite('healthBar');	
		}
		healthBarBG.y = FlxG.height * 0.89;
		healthBarBG.screenCenter(X);
		if (ClientPrefs.orihpbar || CoolUtil.difficultyString() == 'ONELIFE' || CoolUtil.difficultyString() == 'EASIER') {
		healthBarBG.x += 100;
	//	healthBar.createFilledBar(0xF00FF2AB, 0xF003508);
		}
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = !ClientPrefs.hideHud;
		healthBarBG.xAdd = -4;
		healthBarBG.yAdd = -4;
		healthBarBG.alpha = 0;
		add(healthBarBG);
		if(ClientPrefs.downScroll) healthBarBG.y = 0.11 * FlxG.height;

		if (ClientPrefs.orihpbar || CoolUtil.difficultyString() == 'ONELIFE' || CoolUtil.difficultyString() == 'EASIER') {
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, LEFT_TO_RIGHT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'health', 0, 2);
		}
		else {
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'health', 0, 2);
		}
		healthBar.scrollFactor.set();
		// healthBar
		healthBar.visible = !ClientPrefs.hideHud;
		healthBar.alpha = 0;
		add(healthBar);
		healthBarBG.sprTracker = healthBar;

		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - 75;
		iconP1.visible = !ClientPrefs.hideHud;
		iconP1.alpha = 0;
		if (ClientPrefs.orihpbar || CoolUtil.difficultyString() == 'ONELIFE' || CoolUtil.difficultyString() == 'EASIER')
		reloadHealthBarColors();
		else
		add(iconP1);

		iconP2 = new HealthIcon(dad.healthIcon, false);
		iconP2.y = healthBar.y - 75;
		iconP2.visible = !ClientPrefs.hideHud;
		iconP2.alpha = 0;
		if (ClientPrefs.orihpbar || CoolUtil.difficultyString() == 'ONELIFE' || CoolUtil.difficultyString() == 'EASIER')
		reloadHealthBarColors();
		else
		add(iconP2);
	//	if (!ClientPrefs.orihpbar)
		reloadHealthBarColors();

		leTxt = new FlxText(0, healthBarBG.y - 10, FlxG.width, "", 20);
		leTxt.setFormat(Paths.font("alex.ttf"), 30, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		leTxt.scrollFactor.set();
		leTxt.x -= 750;
		leTxt.borderSize = 1.25;
		leTxt.visible = !ClientPrefs.hideHud;
		leTxt.alpha = 0;
		if (ClientPrefs.orihpbar || CoolUtil.difficultyString() == 'ONELIFE' || CoolUtil.difficultyString() == 'EASIER')
		add(leTxt);

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("alex.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		scoreTxt.alpha = 0;
		add(scoreTxt);

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.size = 24;
			timeTxt.y += 3;
		}

		// startCountdown();

		generateSong(SONG.song);
		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys())
		{
			var luaToLoad:String = Paths.modFolders('custom_notetypes/' + notetype + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
		}
		for (event in eventPushedMap.keys())
		{
			var luaToLoad:String = Paths.modFolders('custom_events/' + event + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_events/' + event + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
		}
		#end
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		if (CoolUtil.difficultyString() == 'ONELIFE' || CoolUtil.difficultyString() == 'EASIER') {
			GameOverSubstate.loopSoundName = 'ONELIFEgameover';
			GameOverSubstate.endSoundName = '';
		}

		// After all characters being loaded, it makes then invisible 0.01s later so that the player won't freeze when you change characters
		// add(strumLine);

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		moveCameraSection(0);

		botplayTxt = new FlxText(400, timeBarBG.y + 55, FlxG.width - 800, "Skill Issue Mode", 25);
		botplayTxt.setFormat(Paths.font("alex.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.25;
		botplayTxt.visible = cpuControlled;
		add(botplayTxt);
		if(ClientPrefs.downScroll) {
			botplayTxt.y = timeBarBG.y - 78;
		}

		judgementCounter = new FlxText(20, 0, 0, "", 20);
		judgementCounter.setFormat(Paths.font("alex.ttf"), 26, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		judgementCounter.borderSize = 2;
		judgementCounter.borderQuality = 2;
		judgementCounter.scrollFactor.set();
		judgementCounter.cameras = [camHUD];
		judgementCounter.screenCenter(Y);
		if (!ClientPrefs.hideHud && ClientPrefs.legacyver != 'OG VS Ori Mod')
			{
				add(judgementCounter);
			}

		// These are tutorials on how the note types and shit works. Pretty Self-Explanatory
		if (Paths.formatToSongPath(SONG.song) == 'trirotation')
			mechtut = new AttachedSprite('mechanics/dark');
		if (Paths.formatToSongPath(SONG.song) == 'decay')
			mechtut = new AttachedSprite('mechanics/decay');
		if (Paths.formatToSongPath(SONG.song) == 'restoring-the-light')
			mechtut = new AttachedSprite('mechanics/rtl');
		else if (Paths.formatToSongPath(SONG.song) != 'trirotation' && Paths.formatToSongPath(SONG.song) != 'decay' && Paths.formatToSongPath(SONG.song) != 'restoring-the-light')
			mechtut = new AttachedSprite('mechanics/nonelmao');
		mechtut.scrollFactor.set();
		mechtut.screenCenter(X);
		mechtut.visible = ClientPrefs.displayTut;
		mechtut.alpha = 0;
		if (Paths.formatToSongPath(SONG.song) == 'trirotation' || Paths.formatToSongPath(SONG.song) == 'decay' || Paths.formatToSongPath(SONG.song) == 'restoring-the-light')
		add(mechtut);

		songinfo = new AttachedSprite('song/song-' + curSong);
		songinfo.scrollFactor.set();
		songinfo.visible = !ClientPrefs.hideHud;
		songinfo.x -= 500;
		songinfo.alpha = 0;
	//	add(songinfo);

		// This is kinda useless since the FC rating has been readded. Oh well
		fcLevel = new AttachedSprite('fclevel/Clear');
		fcLevel.scrollFactor.set();
		fcLevel.visible = !ClientPrefs.hideFCRank;
		fcLevel.x += 1000;
		fcLevel.y += 500;
	//	fcLevel.screenCenter();
		fcLevel.scale.set(0.4, 0.4);
	//	fcLevel.setGraphicSize(175, 125);
		if (ClientPrefs.downScroll)
		fcLevel.alpha = 0.4;
		else
		fcLevel.alpha = 1;
		add(fcLevel);

		if (Paths.formatToSongPath(SONG.song) == 'trirotation')
			healyou = false;

		emergencyheallmao = new FlxText(0, 0, FlxG.width, "", 20);
		emergencyheallmao.setFormat(Paths.font("alex.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		emergencyheallmao.scrollFactor.set();
		if (ClientPrefs.downScroll)
		emergencyheallmao.y = healthBarBG.y + 80;
		else
		emergencyheallmao.y = healthBarBG.y - 50;
		emergencyheallmao.borderSize = 1.25;
		emergencyheallmao.visible = !ClientPrefs.hideHud;
		add(emergencyheallmao);

		challengeshitlol = new FlxText(0, 0, FlxG.width, "", 20);
		challengeshitlol.setFormat(Paths.font("alex.ttf"), 26, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		challengeshitlol.scrollFactor.set();
		challengeshitlol.y = healthBarBG.y - 50;
		challengeshitlol.borderSize = 1.25;
		challengeshitlol.x = 300;
		challengeshitlol.visible = !ClientPrefs.hideHud;
		challengeshitlol.text = '';
		if (ClientPrefs.bigball)
			challengeshitlol.text += 'Big Balls Mode';
		add(challengeshitlol);

		strumLine = new FlxSprite(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();

		switch (Paths.formatToSongPath(SONG.song))
		{
			case 'spirit-tree' | 'restoring-the-light':
				composerslol = 'Composer(s): Rae, James Jamestar';
			case 'decay' | 'expurgation':
				composerslol = 'Composer(s): Rae, James Jamestar';
			case 'trirotation':
				composerslol = 'Composer(s): Voltex, James Jamestar';
			case 'volt' | 'vector' | 'upheaval':
				composerslol = 'Composer(s): Voltex';
			case 'corrupurgation' | 'defeat':
				composerslol = 'Cover by Albert (Legacy) and James Jamestar (New)';
			case 'fatality' | 'challenge-ori-end' | 'accelerant' | 'think':
				composerslol = 'Cover by Albert';
			case 'cheating':
				composerslol = 'Cover by Pure Mops.';
			case 'practice':
				composerslol = 'AndyBrawler';
			default:
				composerslol = 'Composer(s):'; // placeholder
		}
		songinfonew = new FlxText(0, 0, SONG.song + '\n' + composerslol + '\n', 12);
		songinfonew.setFormat(Paths.font("alex.ttf"), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songinfonew.scrollFactor.set();
	//	songinfonew.y = -100;
	//	songinfonew.x = -300;

		if (Paths.formatToSongPath(SONG.song) != 'trirotation')
		songinfonew.alpha = 1;
		else
		songinfonew.alpha = 0;

		songinfonew.visible = true;
		songinfonew.cameras = [camHUD];
		add(songinfonew);

		switch (Paths.formatToSongPath(SONG.song))
		{
			case 'light-(unused)':
				credits = '???';
		//	case 'og-restoring-the-light':
		//		credits = 'Holy shit they be runnin. (Created by Doger, Rae, and FinnYoung)';
		//	case 'fleeing' | 'shrieker' | 'light' | 'think' | 'corrupurgation' | 'shriek-and-ori' | 'starbucks' | 'fatality' | 'rtl-piano' | 'main-theme' | 'haqualaku' | 'light-legacy' | 'fleeing-legacy':
		//		credits = 'Note: This song is VERY unfinished.';
			case 'well':
				credits = 'wtf? (This song is not stable because this mod runs on PE 0.5.2h)';
			case 'firestarter':
				credits = 'Song by Tanger! From BeatSaber.';
			case 'final-boss-chan':
				credits = 'Song by Camellia! From BeatSaber.';
			case 'decay-b-sides':
				credits = 'It\'s not overcharted, you\'re just bad (Song from VS Stev mod)';
			case 'CBT': // It means Competitive Balance Tax, I don't know what you're talking about.
				credits = 'What the fuck!';
			case 'corrupurgation':
				credits = 'Screw You! OC by Arzo.';
			case 'defeat':
				credits = 'Screw You! Ghost Tapping is forced off! OC by Arzo.';
			case 'fatality':
				credits = 'OCs by Albert';
			case 'cheating':
				credits = 'Screw You! Cheating by MoldyGH // Cover by Pure Mops.';
			default:
				credits = '';
		}
		var creditsText:Bool = credits != '';
		var textYPos:Float = healthBarBG.y + 50;
		if (creditsText)
		{
			textYPos = healthBarBG.y + 30;
		}
		// totally didnt took this from KE (sorry)
		songWatermark = new FlxText(4, textYPos, 0, SONG.song, 12);
		songWatermark.setFormat(Paths.font("alex.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songWatermark.scrollFactor.set();
		songWatermark.visible = ClientPrefs.watermarks;
		//	songWatermark.alpha = 0;
			add(songWatermark);
			if (creditsText)
			{
				creditsWatermark = new FlxText(4, healthBarBG.y + 50, 0, credits, 16);
				creditsWatermark.setFormat(Paths.font("alex.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				creditsWatermark.scrollFactor.set();
				creditsWatermark.visible = ClientPrefs.watermarks;
				add(creditsWatermark);
				creditsWatermark.cameras = [camHUD];
			}
		
		var engineshitYPos:Float = healthBarBG.y + 50;
		if (CoolUtil.difficultyString() == 'OLDCHART' || CoolUtil.difficultyString() == 'LEGACY')
		engineVerwatermark = new FlxText(4, engineshitYPos, 0, "Psych Forever v2 (PE 0.4.2)", 12);
		else
		engineVerwatermark = new FlxText(4, engineshitYPos, 0, "Psych Forever v" + MainMenuState.psychForeverVersion + " (PE " + MainMenuState.psychEngineVersion + ")", 12);
		engineVerwatermark.setFormat(Paths.font("alex.ttf"), 16, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		engineVerwatermark.scrollFactor.set();
		engineVerwatermark.x = 1050;
		engineVerwatermark.visible = ClientPrefs.watermarks;
		add(engineVerwatermark);

		if (Paths.formatToSongPath(SONG.song) == 'trirotation') {
			songWatermark.alpha = 0; // hides when starting trirotation
		}

		if (Paths.formatToSongPath(SONG.song) == 'defeat')
			ghostTapping = false;

		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		oriHPBG.cameras = [camHUD];
		songWatermark.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		fcLevel.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		songinfo.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		engineVerwatermark.cameras = [camHUD];
		leTxt.cameras = [camHUD];
		emergencyheallmao.cameras = [camHUD];
		challengeshitlol.cameras = [camHUD];
		mechtut.cameras = [camHUD];
		botplayTxt.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		oriTIMEBG.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		#if android
		addAndroidControls();
		#end
			
		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		// SONG SPECIFIC SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('data/' + Paths.formatToSongPath(SONG.song) + '/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('data/' + Paths.formatToSongPath(SONG.song) + '/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/data/' + Paths.formatToSongPath(SONG.song) + '/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end
		
		var daSong:String = Paths.formatToSongPath(curSong);
		if (isStoryMode && !seenCutscene)
		{
			switch (daSong)
			{
				case "monster":
					var whiteScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
					add(whiteScreen);
					whiteScreen.scrollFactor.set();
					whiteScreen.blend = ADD;
					camHUD.visible = false;
					snapCamFollowToPos(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					inCutscene = true;

					FlxTween.tween(whiteScreen, {alpha: 0}, 1, {
						startDelay: 0.1,
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							camHUD.visible = true;
							remove(whiteScreen);
							startCountdown();
						}
					});
					FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
					if(gf != null) gf.playAnim('scared', true);
					boyfriend.playAnim('scared', true);

				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;
					inCutscene = true;

					FlxTween.tween(blackScreen, {alpha: 0}, 0.7, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween) {
							remove(blackScreen);
						}
					});
					FlxG.sound.play(Paths.sound('Lights_Turn_On'));
					snapCamFollowToPos(400, -2050);
					FlxG.camera.focusOn(camFollow);
					FlxG.camera.zoom = 1.5;

					new FlxTimer().start(0.8, function(tmr:FlxTimer)
					{
						camHUD.visible = true;
						remove(blackScreen);
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
							ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								startCountdown();
							}
						});
					});
				case 'senpai' | 'roses' | 'thorns':
					if(daSong == 'roses') FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);

				default:
					startCountdown();
			}
			seenCutscene = true;
		}
		else
		{
			startCountdown();
		}
		RecalculateRating();

		//PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND FUCK THEM UP IDK HOW HAXE WORKS
		if(ClientPrefs.hitsoundVolume > 0) CoolUtil.precacheSound('hitsound');
		CoolUtil.precacheSound('missnote1');
		CoolUtil.precacheSound('missnote2');
		CoolUtil.precacheSound('missnote3');

		if (PauseSubState.songName != null) {
			CoolUtil.precacheMusic(PauseSubState.songName);
		} else if(ClientPrefs.pauseMusic != 'None') {
			CoolUtil.precacheMusic(Paths.formatToSongPath(ClientPrefs.pauseMusic));
		}

		#if desktop
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		#end

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}

		Conductor.safeZoneOffset = (ClientPrefs.safeFrames / 60) * 1000;
		callOnLuas('onCreatePost', []);
		
		super.create();

		if(Paths.formatToSongPath(SONG.song) == "reality-breaking" && curStep >= 511){
			addShaderToCamera('camHUD', new ChromaticAberrationEffect(0.01));
		}

		if(curSong.toLowerCase() == "think" && ClientPrefs.flashing){
			addShaderToCamera('camGame', new VCRDistortionEffect(0.1, true, true, true));
			addShaderToCamera('camHUD', new VCRDistortionEffect(0.1, true, true, true));
		}

		Paths.clearUnusedMemory();
		CustomFadeTransition.nextCamera = camOther;
	}

	function set_songSpeed(value:Float):Float
	{
		if(generatedMusic)
		{
			var ratio:Float = value / songSpeed; //funny word huh
			for (note in notes)
			{
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
				{
					note.scale.y *= ratio;
					note.updateHitbox();
				}
			}
			for (note in unspawnNotes)
			{
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
				{
					note.scale.y *= ratio;
					note.updateHitbox();
				}
			}
		}
		songSpeed = value;
		noteKillOffset = 350 / songSpeed;
		return value;
	}

	public function addTextToDebug(text:String) {
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText) {
			spr.y += 20;
		});

		if(luaDebugGroup.members.length > 34) {
			var blah = luaDebugGroup.members[34];
			blah.destroy();
			luaDebugGroup.remove(blah);
		}
		luaDebugGroup.insert(0, new DebugLuaText(text, luaDebugGroup));
		#end
	}

	public function reloadHealthBarColors() {
		if (ClientPrefs.orihpbar  || CoolUtil.difficultyString() == 'ONELIFE' || CoolUtil.difficultyString() == 'EASIER') {
			healthBar.createFilledBar(FlxColor.fromRGB((boyfriend.healthColorArray[0] * 0), (boyfriend.healthColorArray[1] * 0), (boyfriend.healthColorArray[2] * 0)),
			FlxColor.fromRGB((dad.healthColorArray[0] * 0), (dad.healthColorArray[1] + 255), (dad.healthColorArray[2]) * 0));
			bfa = boyfriend.healthColorArray[0];
			bfaa = boyfriend.healthColorArray[1];
			bfaaa = boyfriend.healthColorArray[2];
			dada = dad.healthColorArray[0];
			dadaa = dad.healthColorArray[1];
			dadaaa = dad.healthColorArray[2];	
		}
		else {
			healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));	
			bfa = boyfriend.healthColorArray[0];
			bfaa = boyfriend.healthColorArray[1];
			bfaaa = boyfriend.healthColorArray[2];
			dada = dad.healthColorArray[0];
			dadaa = dad.healthColorArray[1];
			dadaaa = dad.healthColorArray[2];
		}
		healthBar.updateBar();
	}

	public function remakebar(a:Int,aa:Int,aaa:Int,aaaa:Int,aaaaa:Int,aaaaaa:Int) {
		healthBar.createFilledBar(FlxColor.fromRGB(a, aa, aaa),
			FlxColor.fromRGB(aaaa,aaaaa, aaaaaa));
		healthBar.updateBar();
		bfa = aaaa;
		bfaa = aaaaa;
		bfaaa = aaaaaa;
		dada = a;
		dadaa = aa;
		dadaaa = aaa;
	}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Boyfriend = new Boyfriend(0, 0, newCharacter);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					startCharacterLua(newBoyfriend.curCharacter);
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					startCharacterLua(newDad.curCharacter);
				}

			case 2:
				if(gf != null && !gfMap.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					startCharacterLua(newGf.curCharacter);
				}
		}
	}

	function startCharacterLua(name:String)
	{
		#if LUA_ALLOWED
		var doPush:Bool = false;
		var luaFile:String = 'characters/' + name + '.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}
		
		if(doPush)
		{
			for (lua in luaArray)
			{
				if(lua.scriptName == luaFile) return;
			}
			luaArray.push(new FunkinLua(luaFile));
		}
		#end
	}
	
	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
			char.danceEveryNumBeats = 2;
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public function addShaderToCamera(cam:String,effect:ShaderEffect){//STOLE FROM ANDROMEDA AND PSYCH ENGINE 0.5.1 WITH SHADERS
	  
	  
	  
		switch(cam.toLowerCase()) {
			case 'camhud' | 'hud':
					camHUDShaders.push(effect);
					var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
					for(i in camHUDShaders){
	                	        newCamEffects.push(new ShaderFilter(i.shader));
					}
					camHUD.setFilters(newCamEffects);
			case 'camother' | 'other':
					camOtherShaders.push(effect);
					var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
					for(i in camOtherShaders){
		           		newCamEffects.push(new ShaderFilter(i.shader));
					}
					camOther.setFilters(newCamEffects);
			case 'camgame' | 'game':
					camGameShaders.push(effect);
					var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
					for(i in camGameShaders){
					newCamEffects.push(new ShaderFilter(i.shader));
					}
					camGame.setFilters(newCamEffects);
			default:
				if(modchartSprites.exists(cam)) {
					Reflect.setProperty(modchartSprites.get(cam),"shader",effect.shader);
				} else if(modchartTexts.exists(cam)) {
					Reflect.setProperty(modchartTexts.get(cam),"shader",effect.shader);
				} else {
					var OBJ = Reflect.getProperty(PlayState.instance,cam);
					Reflect.setProperty(OBJ,"shader", effect.shader);
				}
			
			
				
				
		}
	  
	  
	  
	  
  }

  public function removeShaderFromCamera(cam:String,effect:ShaderEffect){
	  
	  
		switch(cam.toLowerCase()) {
			case 'camhud' | 'hud': 
    camHUDShaders.remove(effect);
    var newCamEffects:Array<BitmapFilter>=[];
    for(i in camHUDShaders){
      newCamEffects.push(new ShaderFilter(i.shader));
    }
    camHUD.setFilters(newCamEffects);
			case 'camother' | 'other': 
					camOtherShaders.remove(effect);
					var newCamEffects:Array<BitmapFilter>=[];
					for(i in camOtherShaders){
					  newCamEffects.push(new ShaderFilter(i.shader));
					}
					camOther.setFilters(newCamEffects);
			default: 
				camGameShaders.remove(effect);
				var newCamEffects:Array<BitmapFilter>=[];
				for(i in camGameShaders){
				  newCamEffects.push(new ShaderFilter(i.shader));
				}
				camGame.setFilters(newCamEffects);
		}
		
	  
  }
	
	
	
  public function clearShaderFromCamera(cam:String){
	  
	  
		switch(cam.toLowerCase()) {
			case 'camhud' | 'hud': 
				camHUDShaders = [];
				var newCamEffects:Array<BitmapFilter>=[];
				camHUD.setFilters(newCamEffects);
			case 'camother' | 'other': 
				camOtherShaders = [];
				var newCamEffects:Array<BitmapFilter>=[];
				camOther.setFilters(newCamEffects);
			default: 
				camGameShaders = [];
				var newCamEffects:Array<BitmapFilter>=[];
				camGame.setFilters(newCamEffects);
		}
		
	  
  }

	public function startVideo(name:String):Void 
	{
		#if VIDEOS_ALLOWED
		var foundFile:Bool = false;
		var fileName:String = #if MODS_ALLOWED Paths.modFolders('videos/' + name + '.' + Paths.VIDEO_EXT); #else ''; #end
		#if desktop
		if(FileSystem.exists(fileName)) {
			foundFile = true;
		}
		#end

		if(!foundFile) {
			fileName = Paths.video(name);
			#if desktop
			if(FileSystem.exists(fileName)) {
			#else
			if(OpenFlAssets.exists(fileName)) {
			#end
				foundFile = true;
			}
		}

		if(foundFile) {
			inCutscene = true;
			var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			bg.scrollFactor.set();
			bg.cameras = [camHUD];
			add(bg);

			(new FlxVideo(fileName)).finishCallback = function() {
				remove(bg);
				startAndEnd();
			}
			return;
		}
		else
		{
			FlxG.log.warn('Couldnt find video file: ' + fileName);
			startAndEnd();
		}
		#end
		startAndEnd();
	}

	function startAndEnd()
	{
		if(endingSong) {
			if (SONG.song.toLowerCase() == 'cheating') {
				PlayState.SONG = Song.loadFromJson('cheating', 'cheating'); // Screw You!
				LoadingState.loadAndSwitchState(new PlayState());
				}
			else {
			endSong();
			}
		}
		else
			startCountdown();
	}
	
	var dialogueCount:Int = 0;
	public var psychDialogue:DialogueBoxPsych;
	//You don't have to add a song, just saying. You can just do "startDialogue(dialogueJson);" and it should work
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{
		// TO DO: Make this more flexible, maybe?
		if(psychDialogue != null) return;

		if(dialogueFile.dialogue.length > 0) {
			inCutscene = true;
			CoolUtil.precacheSound('dialogue');
			CoolUtil.precacheSound('dialogueClose');
			psychDialogue = new DialogueBoxPsych(dialogueFile, song);
			psychDialogue.scrollFactor.set();
			if(endingSong) {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					endSong();
				}
			} else {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					startCountdown();
				}
			}
			psychDialogue.nextDialogueThing = startNextDialogue;
			psychDialogue.skipDialogueThing = skipDialogue;
			psychDialogue.cameras = [camHUD];
			add(psychDialogue);
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			if(endingSong) {
				if (SONG.song.toLowerCase() == 'cheating') {
				PlayState.SONG = Song.loadFromJson('cheating', 'cheating'); // Screw You!
				LoadingState.loadAndSwitchState(new PlayState());
				}
				else
				endSong();
			} else {
				startCountdown();
			}
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += 300;

		var songName:String = Paths.formatToSongPath(SONG.song);
		if (songName == 'roses' || songName == 'thorns')
		{
			remove(black);

			if (songName == 'thorns')
			{
				add(red);
				camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (Paths.formatToSongPath(SONG.song) == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var countdownReady:FlxSprite;
	public var countdownSet:FlxSprite;
	public var countdownGo:FlxSprite;
	public static var startOnTime:Float = 0;
	var warningStart:Bool = false;
	var warnTimer:FlxTimer;
	function noteWarning():Void
		{
			var warnCounter:Int = 0;
			warningStart = true;
			
			var warnMark:FlxSprite = new FlxSprite(830, 50).loadGraphic(Paths.image('noteWarning', 'shared'));
			add(warnMark);
			warnMark.alpha = 0;
			warnMark.scrollFactor.set();
			warnMark.setGraphicSize(200);
			warnMark.cameras = [camHUD];
			warnMark.antialiasing = true;
			
			warnTimer = new FlxTimer().start((Conductor.crochet / 1000) / 2, function(tmr:FlxTimer)
				{
					switch (warnCounter)
	
					{
						case 0:
						case 1:
							FlxG.sound.play(Paths.sound('alert'), 0.6);
							warnMark.alpha = 100;
						case 2:
							warnMark.alpha = 0;
						case 3:
							FlxG.sound.play(Paths.sound('alert'), 0.6);
							warnMark.alpha = 100;
						case 4:
							warnMark.alpha = 0;
						case 5:
							FlxG.sound.play(Paths.sound('alert'), 0.6);
							warnMark.alpha = 100;
						case 6:
							warnMark.alpha = 0;
					}
					
					warnCounter += 1;
				}, 9);
		}
	public function startCountdown():Void
	{
		if(startedCountdown) {
			callOnLuas('onStartCountdown', []);
			return;
		}

		inCutscene = false;
		var ret:Dynamic = callOnLuas('onStartCountdown', []);
		if(ret != FunkinLua.Function_Stop) {
			if (skipCountdown || startOnTime > 0) skipArrowStartTween = true;

			#if android
			androidControls.visible = true;
			#end
				
			generateStaticArrows(0);
			generateStaticArrows(1);
			for (i in 0...playerStrums.length) {
				setOnLuas('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defaultPlayerStrumY' + i, playerStrums.members[i].y);
			}
			for (i in 0...opponentStrums.length) {
				setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				//if(ClientPrefs.middleScroll) opponentStrums.members[i].visible = false;
			}

			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;
			setOnLuas('startedCountdown', true);
			callOnLuas('onCountdownStarted', []);

			var swagCounter:Int = 0;

			if (skipCountdown || startOnTime > 0) {
				clearNotesBefore(startOnTime);
				setSongTime(startOnTime - 500);
				return;
			}

			startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				if (gf != null && tmr.loopsLeft % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && !gf.stunned && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
				{
					gf.dance();
				}
				if (tmr.loopsLeft % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
				{
					if (health <= 0.8 && Paths.formatToSongPath(SONG.song) != 'restoring-the-light')
					boyfriend.playAnim('scared', true);
					else
					boyfriend.dance();
				}
				if (tmr.loopsLeft % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
				{
					dad.dance();
				}

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', 'set', 'go']);
				introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

				var introAlts:Array<String> = introAssets.get('default');
				var antialias:Bool = ClientPrefs.globalAntialiasing;
				if(isPixelStage) {
					introAlts = introAssets.get('pixel');
					antialias = false;
				}

				// head bopping for bg characters on Mall
				if(curStage == 'mall') {
					if(!ClientPrefs.lowQuality)
						upperBoppers.dance(true);
	
					bottomBoppers.dance(true);
					santa.dance(true);
				}

				switch (swagCounter)
				{
					case 0:
						if (Paths.formatToSongPath(SONG.song) == 'corn' || Paths.formatToSongPath(SONG.song) == 'starbucks' || Paths.formatToSongPath(SONG.song) == 'shriek-and-ori' || Paths.formatToSongPath(SONG.song) == 'firestarter' || Paths.formatToSongPath(SONG.song) == 'vector' || Paths.formatToSongPath(SONG.song) == 'volt')
							{
								noteWarning();
							}
						FlxTween.tween(songWatermark, {alpha: 1}, 1, {ease: FlxEase.linear});
						if (Paths.formatToSongPath(SONG.song) != 'restoring-the-light')
						FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
						if(!ClientPrefs.reducedmovements) isDadGlobal = false;
						if(!ClientPrefs.reducedmovements) moveCamera(false);
					case 1:
						countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						countdownReady.scrollFactor.set();
						countdownReady.updateHitbox();

						if (PlayState.isPixelStage)
							countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));

						countdownReady.screenCenter();
						countdownReady.antialiasing = antialias;
						add(countdownReady);
						FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownReady);
								countdownReady.destroy();
							}
						});
						if (Paths.formatToSongPath(SONG.song) != 'restoring-the-light')
						FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
						if(!ClientPrefs.reducedmovements) isDadGlobal = true;
						if(!ClientPrefs.reducedmovements) moveCamera(true);
					case 2:
						countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						countdownSet.scrollFactor.set();

						if (PlayState.isPixelStage)
							countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));

						countdownSet.screenCenter();
						countdownSet.antialiasing = antialias;
						add(countdownSet);
						FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownSet);
								countdownSet.destroy();
							}
						});
						if (Paths.formatToSongPath(SONG.song) != 'restoring-the-light')
						FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
						if(!ClientPrefs.reducedmovements) isDadGlobal = false;
						if(!ClientPrefs.reducedmovements) moveCamera(false);
					case 3:
						countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						countdownGo.scrollFactor.set();

						if (PlayState.isPixelStage)
							countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));

						countdownGo.updateHitbox();

						countdownGo.screenCenter();
						countdownGo.antialiasing = antialias;
						add(countdownGo);
					/*	countdownGo.push(countdownGo);
						FlxTween.tween(countdownGo, {y: countdownGo.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
							//	countdownGo.remove(countdownGo);
								remove(countdownGo);
								countdownGo.destroy();
							}
						});*/
						FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownGo);
								countdownGo.destroy();
							}
						});
						if (Paths.formatToSongPath(SONG.song) != 'firestarter') {
						FlxTween.tween(healthBar, {alpha: 1}, 0.25, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 1}, 0.25, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 1}, 0.25, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 1}, 0.25, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 1}, 0.25, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 1}, 0.25, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 1}, 0.25, {ease: FlxEase.linear});
						}
						if (Paths.formatToSongPath(SONG.song) != 'restoring-the-light')
						FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
						if(!ClientPrefs.reducedmovements) isDadGlobal = true;
						if(!ClientPrefs.reducedmovements) moveCamera(true);
						strumLineNotes.forEach(function(note)
							{
								quickSpin(note);
							});
						if (Paths.formatToSongPath(SONG.song) != 'restoring-the-light') {
						FlxTween.tween(songinfonew, {y: -500}, 1, {ease: FlxEase.linear});
						var heyAnimation:Bool = boyfriend.animation.getByName("hey") != null; 
						boyfriend.playAnim(heyAnimation ? 'hey' : 'singUP', true);
						}
					case 4:
				}

				notes.forEachAlive(function(note:Note) {
					note.copyAlpha = false;
					note.alpha = note.multAlpha;
					if(ClientPrefs.middleScroll && !note.mustPress) {
						note.alpha *= 0.5;
					}
				});
				callOnLuas('onCountdownTick', [swagCounter]);

				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	}

	public function clearNotesBefore(time:Float)
	{
		var i:Int = unspawnNotes.length - 1;
		while (i >= 0) {
			var daNote:Note = unspawnNotes[i];
			if(daNote.strumTime - 500 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				unspawnNotes.remove(daNote);
				daNote.destroy();
			}
			--i;
		}

		i = notes.length - 1;
		while (i >= 0) {
			var daNote:Note = notes.members[i];
			if(daNote.strumTime - 500 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			--i;
		}
	}

	public function setSongTime(time:Float)
	{
		if(time < 0) time = 0;

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.time = time;
		FlxG.sound.music.play();

		vocals.time = time;
		if (!ClientPrefs.disablevocals)
		vocals.play();
		Conductor.songPosition = time;
	}

	function startNextDialogue() {
		dialogueCount++;
		callOnLuas('onNextDialogue', [dialogueCount]);
	}

	function skipDialogue() {
		callOnLuas('onSkipDialogue', [dialogueCount]);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = onSongComplete;
		if (!ClientPrefs.disablevocals)
		vocals.play();

		if(startOnTime > 0)
		{
			setSongTime(startOnTime - 500);
		}
		startOnTime = 0;

		if(paused) {
			//trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			vocals.pause();
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(oriTIMEBG, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		
		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength);
		#end
		setOnLuas('songLength', songLength);
		callOnLuas('onSongStart', []);
	}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();
	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());
	//	songSpeedType = ClientPrefs.getGameplaySetting('scrolltype','multiplicative');

	//	switch(songSpeedType)
	//	{
	//		case "multiplicative":
	//			songSpeed = SONG.speed * ClientPrefs.scrollspeed;
	//		case "constant":
	//			songSpeed = ClientPrefs.scrollspeed;;
	//	}

		songSpeed = SONG.speed * ClientPrefs.scrollspeed;
		
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);
		
		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var songName:String = Paths.formatToSongPath(SONG.song);
		var file:String = Paths.json(songName + '/events');
		#if desktop
		if (FileSystem.exists(Paths.modsJson(songName + '/events')) || FileSystem.exists(file)) {
		#else
		if (OpenFlAssets.exists(file)) {
		#end
			var eventsData:Array<Dynamic> = Song.loadFromJson('events', songName).events;
			for (event in eventsData) //Event Notes
			{
				for (i in 0...event[1].length)
				{
					var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
					var subEvent:EventNote = {
						strumTime: newEventNote[0] + ClientPrefs.noteOffset,
						event: newEventNote[1],
						value1: newEventNote[2],
						value2: newEventNote[3]
					};
					subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
					eventNotes.push(subEvent);
					eventPushed(subEvent);
				}
			}
		}

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.mustPress = gottaHitNote;
				swagNote.sustainLength = songNotes[2];
				swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
				swagNote.noteType = songNotes[3];
				if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts
				
				swagNote.scrollFactor.set();

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				var floorSus:Int = Math.floor(susLength);
				if(floorSus > 0) {
					for (susNote in 0...floorSus+1)
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2)), daNoteData, oldNote, true);
						sustainNote.mustPress = gottaHitNote;
						sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
						sustainNote.noteType = swagNote.noteType;
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);

						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
						else if(ClientPrefs.middleScroll)
						{
							sustainNote.x += 310;
							if(daNoteData > 1) //Up and Right
							{
								sustainNote.x += FlxG.width / 2 + 25;
							}
						}
					}
				}

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else if(ClientPrefs.middleScroll)
				{
					swagNote.x += 310;
					if(daNoteData > 1) //Up and Right
					{
						swagNote.x += FlxG.width / 2 + 25;
					}
				}

				if(!noteTypeMap.exists(swagNote.noteType)) {
					noteTypeMap.set(swagNote.noteType, true);
				}
			}
			daBeats += 1;
		}
		for (event in songData.events) //Event Notes
		{
			for (i in 0...event[1].length)
			{
				var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
				var subEvent:EventNote = {
					strumTime: newEventNote[0] + ClientPrefs.noteOffset,
					event: newEventNote[1],
					value1: newEventNote[2],
					value2: newEventNote[3]
				};
				subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
				eventNotes.push(subEvent);
				eventPushed(subEvent);
			}
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		if(eventNotes.length > 1) { //No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}
		checkEventNote();
		generatedMusic = true;
	}
	static public function quickSpin(sprite)
		{
			FlxTween.angle(sprite, 0, 360, 0.5, {
				type: FlxTween.ONESHOT,
				ease: FlxEase.quadInOut,
				startDelay: 0,
				loopDelay: 0
			});
		}
	function eventPushed(event:EventNote) {
		switch(event.event) {
			case 'Change Character':
				var charType:Int = 0;
				switch(event.value1.toLowerCase()) {
					case 'gf' | 'girlfriend' | '1':
						charType = 2;
					case 'dad' | 'opponent' | '0':
						charType = 1;
					default:
						charType = Std.parseInt(event.value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event.value2;
				addCharacterToList(newCharacter, charType);
		}

		if(!eventPushedMap.exists(event.event)) {
			eventPushedMap.set(event.event, true);
		}
	}

	function eventNoteEarlyTrigger(event:EventNote):Float {
		var returnedValue:Float = callOnLuas('eventEarlyTrigger', [event.event]);
		if(returnedValue != 0) {
			return returnedValue;
		}

		switch(event.event) {
			case 'Kill Henchmen': //Better timing so that the kill sound matches the beat intended
				return 280; //Plays 280ms before the actual position
		}
		return 0;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByTime(Obj1:EventNote, Obj2:EventNote):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public var skipArrowStartTween:Bool = false; //for lua
	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var targetAlpha:Float = 1;
			if (player < 1 && ClientPrefs.middleScroll) targetAlpha = 0.35;

			var babyArrow:StrumNote = new StrumNote(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i, player);
			babyArrow.downScroll = ClientPrefs.downScroll;
			if (!isStoryMode && !skipArrowStartTween)
			{
				//babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {/*y: babyArrow.y + 10,*/ alpha: targetAlpha}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			else
			{
				babyArrow.alpha = targetAlpha;
			}

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				if(ClientPrefs.middleScroll)
				{
					babyArrow.x += 310;
					if(i > 1) { //Up and Right
						babyArrow.x += FlxG.width / 2 + 25;
					}
				}
				opponentStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);
			babyArrow.postAddedToGroup();

			arrowJunks.push([babyArrow.x, babyArrow.y]);
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = false;
			if (songSpeedTween != null)
				songSpeedTween.active = false;

			if(blammedLightsBlackTween != null)
				blammedLightsBlackTween.active = false;
			if(phillyCityLightsEventTween != null)
				phillyCityLightsEventTween.active = false;

			if(carTimer != null) carTimer.active = false;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = false;
				}
			}

			for (tween in modchartTweens) {
				tween.active = false;
			}
			for (timer in modchartTimers) {
				timer.active = false;
			}
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = true;
			if (songSpeedTween != null)
				songSpeedTween.active = true;

			if(blammedLightsBlackTween != null)
				blammedLightsBlackTween.active = true;
			if(phillyCityLightsEventTween != null)
				phillyCityLightsEventTween.active = true;
			
			if(carTimer != null) carTimer.active = true;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = true;
				}
			}
			
			for (tween in modchartTweens) {
				tween.active = true;
			}
			for (timer in modchartTimers) {
				timer.active = true;
			}
			paused = false;
			callOnLuas('onResume', []);

			#if desktop
			if (startTimer != null && startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if(finishTimer != null) return;

		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		if (!ClientPrefs.disablevocals)
		vocals.play();
	}

	public var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var limoSpeed:Float = 0;

	override public function update(elapsed:Float)
	{

		callOnLuas('onUpdate', [elapsed]);

		elapsedtime += elapsed;

		// dave and bambi moment
		if (SONG.song.toLowerCase() == 'oh-no' && curStep >= 208) // fuck you x3
			{
				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin(elapsedtime + (spr.ID)) * 500);
					spr.x += 500; 
					spr.y += Math.sin(elapsedtime) * Math.random();
					spr.y -= Math.sin(elapsedtime) * 1.3;
				});
				opponentStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin((elapsedtime + (spr.ID )) * 2) * 500);
					spr.x += 500; 
					spr.y += Math.sin(elapsedtime) * Math.random();
					spr.y -= Math.sin(elapsedtime) * 1.3;
				});
			}
		if (fuckyoumodchart) // fuck you x3
			{
				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin(elapsedtime + (spr.ID)) * 500);
					spr.x += 500; 
					spr.y += Math.sin(elapsedtime) * Math.random();
					spr.y -= Math.sin(elapsedtime) * 1.3;
				});
				opponentStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin((elapsedtime + (spr.ID )) * 2) * 500);
					spr.x += 500; 
					spr.y += Math.sin(elapsedtime) * Math.random();
					spr.y -= Math.sin(elapsedtime) * 1.3;
				});
			}
		if (ClientPrefs.modcharts) {
			if (flipcamlol) { // i don't give a shit if this is affected by FPS lol
				if (fuckingangle <= 175) {
					camHUD.angle += 5; // POV: you're too poor to play downscroll.
					fuckingangle += 5;
				}
			}
			else {
				if (fuckingangle >= 5) {
					camHUD.angle -= 5;
					fuckingangle -= 5;
				}
			}
				if (SONG.song.toLowerCase() == 'shriek-and-ori' && curBeat >= 921) // this is just dave and bambi
					{
						playerStrums.forEach(function(spr:FlxSprite)
						{
							spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(elapsedtime + (spr.ID)) * 300);
							spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos(elapsedtime + (spr.ID)) * 300);
						});
						opponentStrums.forEach(function(spr:FlxSprite)
						{
							spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime + (spr.ID )) * 2) * 300);
							spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + (spr.ID)) * 2) * 300);
						});
					}
				if (Paths.formatToSongPath(SONG.song) == 'shriek-and-ori' && curBeat >= 433 && curBeat <= 497) // deez all day
					{
					var krunkThing = 60;
		
					playerStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = arrowJunks[spr.ID + 4][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = arrowJunks[spr.ID + 4][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
		
						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;
		
						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);
	
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
	
						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					});
					opponentStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = arrowJunks[spr.ID][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = arrowJunks[spr.ID][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
		
						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;
		
						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);
		
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
		
						spr.scale.x *= 1.5;
						 spr.scale.y *= 1.5;
					});
		
					notes.forEachAlive(function(spr:Note){
						if (spr.mustPress) {
							spr.x = arrowJunks[spr.noteData + 4][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
							spr.y = arrowJunks[spr.noteData + 4][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;
	
							spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;
	
							spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);
		
							spr.scale.x += 0.2;
							spr.scale.y += 0.2;
	
							spr.scale.x *= 1.5;
							spr.scale.y *= 1.5;
							}
							 else
							{
							spr.x = arrowJunks[spr.noteData][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
							spr.y = arrowJunks[spr.noteData][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;
	
							spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;
		
							spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);
		
							spr.scale.x += 0.2;
							spr.scale.y += 0.2;
		
							spr.scale.x *= 1.5;
							spr.scale.y *= 1.5;
						}
					});
				}
				if (Paths.formatToSongPath(SONG.song) == 'disruption') // deez all day
					{
					var krunkThing = 60;
		
					playerStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = arrowJunks[spr.ID + 4][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = arrowJunks[spr.ID + 4][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
		
						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;
		
						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);
	
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
	
						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					});
					opponentStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = arrowJunks[spr.ID][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = arrowJunks[spr.ID][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
		
						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;
		
						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);
		
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
		
						spr.scale.x *= 1.5;
						 spr.scale.y *= 1.5;
					});
		
					notes.forEachAlive(function(spr:Note){
						if (spr.mustPress) {
							spr.x = arrowJunks[spr.noteData + 4][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
							spr.y = arrowJunks[spr.noteData + 4][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;
	
							spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;
	
							spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);
		
							spr.scale.x += 0.2;
							spr.scale.y += 0.2;
	
							spr.scale.x *= 1.5;
							spr.scale.y *= 1.5;
							}
							 else
							{
							spr.x = arrowJunks[spr.noteData][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
							spr.y = arrowJunks[spr.noteData][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;
	
							spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;
		
							spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);
		
							spr.scale.x += 0.2;
							spr.scale.y += 0.2;
		
							spr.scale.x *= 1.5;
							spr.scale.y *= 1.5;
						}
					});
				}
				if (Paths.formatToSongPath(SONG.song) == 'trirotation') // deez all day
					{
						if (CoolUtil.difficultyString() == 'ONELIFE' || CoolUtil.difficultyString() == 'BRUTAL') {
					var krunkThing = 60;
		
					playerStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = arrowJunks[spr.ID + 4][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = arrowJunks[spr.ID + 4][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
		
						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;
		
						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);
	
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
	
						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					});
					opponentStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = arrowJunks[spr.ID][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = arrowJunks[spr.ID][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
		
						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;
		
						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);
		
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
		
						spr.scale.x *= 1.5;
						 spr.scale.y *= 1.5;
					});
		
					notes.forEachAlive(function(spr:Note){
						if (spr.mustPress) {
							spr.x = arrowJunks[spr.noteData + 4][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
							spr.y = arrowJunks[spr.noteData + 4][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;
	
							spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;
	
							spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);
		
							spr.scale.x += 0.2;
							spr.scale.y += 0.2;
	
							spr.scale.x *= 1.5;
							spr.scale.y *= 1.5;
							}
							 else
							{
							spr.x = arrowJunks[spr.noteData][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
							spr.y = arrowJunks[spr.noteData][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;
	
							spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;
		
							spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);
		
							spr.scale.x += 0.2;
							spr.scale.y += 0.2;
		
							spr.scale.x *= 1.5;
							spr.scale.y *= 1.5;
						}
					});
				}
				}
				if (Paths.formatToSongPath(SONG.song) == 'fatality' && curStep >= 2240) // deez all day
					{
					var krunkThing = 60;
		
					playerStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = arrowJunks[spr.ID + 4][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = arrowJunks[spr.ID + 4][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
		
						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;
		
						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);
	
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
	
						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					});
					opponentStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = arrowJunks[spr.ID][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = arrowJunks[spr.ID][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
		
						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;
		
						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);
		
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
		
						spr.scale.x *= 1.5;
						 spr.scale.y *= 1.5;
					});
		
					notes.forEachAlive(function(spr:Note){
						if (spr.mustPress) {
							spr.x = arrowJunks[spr.noteData + 4][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
							spr.y = arrowJunks[spr.noteData + 4][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;
	
							spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;
	
							spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);
		
							spr.scale.x += 0.2;
							spr.scale.y += 0.2;
	
							spr.scale.x *= 1.5;
							spr.scale.y *= 1.5;
							}
							 else
							{
							spr.x = arrowJunks[spr.noteData][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
							spr.y = arrowJunks[spr.noteData][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;
	
							spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;
		
							spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);
		
							spr.scale.x += 0.2;
							spr.scale.y += 0.2;
		
							spr.scale.x *= 1.5;
							spr.scale.y *= 1.5;
						}
					});
				}
			if (SONG.song.toLowerCase() == 'deformation' || SONG.song.toLowerCase() == 'defeat') // cry about it
		    {
		    	playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x += Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 0.005 : -0.005);
					spr.x -= Math.sin(elapsedtime) * 1.5;
		    	});
			    opponentStrums.forEach(function(spr:FlxSprite)
				{
					spr.x -= Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 0.005 : -0.005);
					spr.x += Math.sin(elapsedtime) * 1.5;
				});
			}
			if (Paths.formatToSongPath(SONG.song) == 'screwed' && curBeat >= 464) // cry about it
				{
					if (storyDifficulty == 1) {
					playerStrums.forEach(function(spr:FlxSprite)
						{
							spr.x += Math.sin(elapsedtime * 3) * ((spr.ID % 2) == 0 ? 1 : -1);
							spr.x -= Math.sin(elapsedtime * 3) * 2;
						});
						opponentStrums.forEach(function(spr:FlxSprite)
						{
							spr.x -= Math.sin(elapsedtime * 3) * ((spr.ID % 2) == 0 ? 1 : -1);
							spr.x += Math.sin(elapsedtime * 3) * 2;
						});
					}
					else {
						playerStrums.forEach(function(spr:FlxSprite)
							{
								spr.x += Math.sin(elapsedtime * 3) * ((spr.ID % 4) == 0 ? 0.005 : -0.005);
								spr.x -= Math.sin(elapsedtime * 3) * 0.3;
							});
							opponentStrums.forEach(function(spr:FlxSprite)
							{
								spr.x -= Math.sin(elapsedtime * 3) * ((spr.ID % 4) == 0 ? 0.005 : -0.005);
								spr.x += Math.sin(elapsedtime * 3) * 0.3;
							});
					}
				}
			if (SONG.song.toLowerCase() == 'cheating') // fuck you
				{
					playerStrums.forEach(function(spr:FlxSprite)
					{
						spr.x += Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
						spr.x -= Math.sin(elapsedtime) * 1.5;
					});
					opponentStrums.forEach(function(spr:FlxSprite)
					{
						spr.x -= Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
						spr.x += Math.sin(elapsedtime) * 1.5;
					});
				}
				/*
			if (Paths.formatToSongPath(SONG.song) == 'spirit-tree-old') // deez all day
			{
	
				playerStrums.forEach(function(spr:FlxSprite)
				{	
					spr.scale.x += 0.2;
					spr.scale.y += 0.2;
	
					spr.scale.x *= 1.5;
					spr.scale.y *= 1.5;
				});
				opponentStrums.forEach(function(spr:FlxSprite)
				{	
					spr.scale.x += 0.2;
					spr.scale.y += 0.2;
	
					spr.scale.x *= 1.5;
					spr.scale.y *= 1.5;
				});
	
				notes.forEachAlive(function(spr:Note){
					if (spr.mustPress) {	
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
	
						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					}
					else {	
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
	
						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					}
				});
			}*/
		}
		switch (curStage)
		{
			case 'schoolEvil':
				if(!ClientPrefs.lowQuality && bgGhouls.animation.curAnim.finished) {
					bgGhouls.visible = false;
				}
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed * 1.5;
			case 'limo':
				if(!ClientPrefs.lowQuality) {
					grpLimoParticles.forEach(function(spr:BGSprite) {
						if(spr.animation.curAnim.finished) {
							spr.kill();
							grpLimoParticles.remove(spr, true);
							spr.destroy();
						}
					});

					switch(limoKillingState) {
						case 1:
							limoMetalPole.x += 5000 * elapsed;
							limoLight.x = limoMetalPole.x - 180;
							limoCorpse.x = limoLight.x - 50;
							limoCorpseTwo.x = limoLight.x + 35;

							var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
							for (i in 0...dancers.length) {
								if(dancers[i].x < FlxG.width * 1.5 && limoLight.x > (370 * i) + 130) {
									switch(i) {
										case 0 | 3:
											if(i == 0) FlxG.sound.play(Paths.sound('dancerdeath'), 0.5);

											var diffStr:String = i == 3 ? ' 2 ' : ' ';
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 200, dancers[i].y, 0.4, 0.4, ['hench leg spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 160, dancers[i].y + 200, 0.4, 0.4, ['hench arm spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x, dancers[i].y + 50, 0.4, 0.4, ['hench head spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);

											var particle:BGSprite = new BGSprite('gore/stupidBlood', dancers[i].x - 110, dancers[i].y + 20, 0.4, 0.4, ['blood'], false);
											particle.flipX = true;
											particle.angle = -57.5;
											grpLimoParticles.add(particle);
										case 1:
											limoCorpse.visible = true;
										case 2:
											limoCorpseTwo.visible = true;
									} //Note: Nobody cares about the fifth dancer because he is mostly hidden offscreen :(
									dancers[i].x += FlxG.width * 2;
								}
							}

							if(limoMetalPole.x > FlxG.width * 2) {
								resetLimoKill();
								limoSpeed = 800;
								limoKillingState = 2;
							}

						case 2:
							limoSpeed -= 4000 * elapsed;
							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x > FlxG.width * 1.5) {
								limoSpeed = 3000;
								limoKillingState = 3;
							}

						case 3:
							limoSpeed -= 2000 * elapsed;
							if(limoSpeed < 1000) limoSpeed = 1000;

							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x < -275) {
								limoKillingState = 4;
								limoSpeed = 800;
							}

						case 4:
							bgLimo.x = FlxMath.lerp(bgLimo.x, -150, CoolUtil.boundTo(elapsed * 9, 0, 1));
							if(Math.round(bgLimo.x) == -150) {
								bgLimo.x = -150;
								limoKillingState = 0;
							}
					}

					if(limoKillingState > 2) {
						var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
						for (i in 0...dancers.length) {
							dancers[i].x = (370 * i) + bgLimo.x + 280;
						}
					}
				}
			case 'mall':
				if(heyTimer > 0) {
					heyTimer -= elapsed;
					if(heyTimer <= 0) {
						bottomBoppers.dance(true);
						heyTimer = 0;
					}
				}
		}
		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			if(!startingSong && !endingSong && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
		}
		
		FlxG.camera.setFilters([new ShaderFilter(screenshader.shader)]); // this is very stupid but doesn't effect memory all that much so
		
		if (shakeCam && ClientPrefs.flashing)
			{
				// var shad = cast(FlxG.camera.screen.shader,Shaders.PulseShader);
				FlxG.camera.shake(0.015, 0.015);
			}
			if (shakeCamALT && ClientPrefs.flashing)
			{
				FlxG.camera.shake(0.015, 0.015);
			}
			
			screenshader.shader.uTime.value[0] += elapsed;
			if (shakeCam && ClientPrefs.flashing)
			{
				screenshader.shader.uampmul.value[0] = 1;
			}
			else
			{
				screenshader.shader.uampmul.value[0] -= (elapsed / 2);
			}
			screenshader.Enabled = shakeCam && ClientPrefs.flashing;
			

		super.update(elapsed);

		leTxt.text = 'Life Energy:';

		if (pushrankdownlmao >= 1 && allSicks && ClientPrefs.legacyver == 'v4.5') { // useless since this isn't forever lol
		scoreTxt.text = 'Score: ' + songScore + ' - Accuracy: 99% [MFC] - Combo Breaks: 0 (0) - Rank: S+ (Sick!)';
		}

		// This is a lot of shit here. Please don't yell at me about this mess :<
		if (ClientPrefs.legacyver == 'v4.5') {
		if(ratingName == '?') {
		//	scoreTxt.text = 'NPS: ' + nps + ' | Score: ' + songScore + ' | Combo Breaks: ' + songMisses + ' (' + (songMisses + shits) + ')' + ' | Rank: F (0%)';
		//	scoreTxt.text = '';
			scoreTxt.text = 'Score: ' + songScore + ' - Accuracy: ' + Highscore.floorDecimal(ratingPercent * 100, 2) + '%' + ratingFC + ' - Combo Breaks: ' + songMisses + ' (' + (songMisses + shits) + ')' + ' - Rank: F';
		}
		else {
		//	scoreTxt.text = 'NPS: ' + nps + ' | Score: ' + songScore + ' | Combo Breaks: ' + songMisses + ' (' + (songMisses + shits) + ')' + '| Accuracy: ' + Highscore.floorDecimal(ratingPercent * 100, 2) + '% | Rank: ' + ratingName + ' - ' + ratingFC;
			if (pushrankdownlmao == 0)
			scoreTxt.text = 'Score: ' + songScore + ' - Accuracy: ' + Highscore.floorDecimal(ratingPercent * 100, 2) + '% [' + ratingFC + '] - Combo Breaks: ' + songMisses + ' (' + (songMisses + shits) + ')' + ' - Rank:' + ratingName;
		}
		}
		else if (ClientPrefs.legacyver == 'DE Classic') {
		if(ratingName == '?') {
				scoreTxt.text = 'Score: ' + songScore + ' // Combo Breaks: ' + songMisses + ' (' + (songMisses + shits) + ')' + ' // Energy: ' + healthBar.percent + '%' + ' // Rank: F (0%)';
			} else {
				if (songMisses >= 65) {
					scoreTxt.text = 'Score: ' + songScore + (songScore >= -1 ? '' : songScore <= -1 ? " (Bruh)" : "") + ' // Combo Breaks: ' + songMisses + ' (' + (songMisses + shits) + ')' + ' // Energy: ' + healthBar.percent + '%' + ' // Rank: F' + ' (' + Highscore.floorDecimal(ratingPercent * 100, 2) + '%)' + ' | SKILL ISSUE';//peeps wanted no integer rating
				}
				else {
				scoreTxt.text = 'Score: ' + songScore + (songScore >= -1 ? '' : songScore <= -1 ? " (Bruh)" : "") + ' // Combo Breaks: ' + songMisses + ' (' + (songMisses + shits) + ')' + ' // Energy: ' + healthBar.percent + '%' + ' // Rank: ' + ratingName + ' (' + Highscore.floorDecimal(ratingPercent * 100, 2) + '%)';//peeps wanted no integer rating
			}}
		}
		else {
		if(ratingName == '?') {
			scoreTxt.text = 'Score: ' + songScore + ' | Misses: ' + songMisses + ' | Rating: ?';
		}
		else {
			scoreTxt.text = 'Score: ' + songScore + ' | Misses: ' + songMisses + ' | Rating: ' + ratingName + ' (' + Highscore.floorDecimal(ratingPercent * 100, 0) + '%)';
		}	
		}
		if (practiceMode) {
			scoreTxt.text = 'Cheater! - Combo Breaks: ' + songMisses + ' (' + (songMisses + shits) + ')';
		}


/*	if (FlxG.keys.justPressed.NINE) // FUCK YOU WHY YOU NO WORK
		{
			var isOldIcon:Bool = false;
			if (isOldIcon) {
				changeIcon(SONG.player1);
				isOldIcon = true;
			}
			else {
				changeIcon('bf-classic');
				isOldIcon = false;
			}
		}*/

		for(i in 0...notesHitArray.length)
			{
				var cock:Date = notesHitArray[i];
				if (cock != null)
					if (cock.getTime() + 2000 < Date.now().getTime())
					notesHitArray.remove(cock);
			}
			nps = Math.floor(notesHitArray.length / 2);

		if(botplayTxt.visible) {
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}

		if (controls.PAUSE && startedCountdown && canPause)
		{
			var ret:Dynamic = callOnLuas('onPause', []);
			if(ret != FunkinLua.Function_Stop) {
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

				// 1 / 1000 chance for Gitaroo Man easter egg
				/*if (FlxG.random.bool(0.1))
				{
					// gitaroo man easter egg
					cancelMusicFadeTween();
					MusicBeatState.switchState(new GitarooPause());
				}
				else {*/
				if(FlxG.sound.music != null) {
					FlxG.sound.music.pause();
					vocals.pause();
				}
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				//}
		
				#if desktop
				DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
			}
		}
		if (FlxG.keys.anyJustPressed(debugKeysChart) && !endingSong && !inCutscene) {
		if (Paths.formatToSongPath(SONG.song) == 'decay-old-chart') {
			PlayState.SONG = Song.loadFromJson('shriek-and-ori', 'shriek-and-ori'); // Secret Song
			LoadingState.loadAndSwitchState(new PlayState());
		}
		if (Paths.formatToSongPath(SONG.song) == 'decay') {
			PlayState.SONG = Song.loadFromJson('cheating', 'cheating'); // Screw You!
			LoadingState.loadAndSwitchState(new PlayState());
		}
		}
		if (FlxG.keys.anyJustPressed(debugKeysChart) && !endingSong && !inCutscene && ClientPrefs.debugmode)
		{
			openChartEditor();
		}

		if (Paths.formatToSongPath(SONG.song) == 'opposition' && !ClientPrefs.debugmode) {
		if (cpuControlled || practiceMode)
			FlxG.switchState(new SusState());
		}

		if (Paths.formatToSongPath(SONG.song) == 'trirotation' && !ClientPrefs.debugmode) {
			if (cpuControlled || practiceMode)
				FlxG.switchState(new SusState());
			}

		if (Paths.formatToSongPath(SONG.song) == '-' && !ClientPrefs.debugmode) {
			if (cpuControlled || practiceMode)
			FlxG.switchState(new SusState());
			}

		if (Paths.formatToSongPath(SONG.song) == 'decay-b-sides' && !ClientPrefs.debugmode) {
			if (cpuControlled || practiceMode)
			FlxG.switchState(new SusState());
		}

		RecalculateRating();

			if (Paths.formatToSongPath(SONG.song) == 'restoring-the-light' && curBeat >= 1 && curBeat <= 416) {
			if (!ClientPrefs.reducedmovements) {
			FlxG.camera.shake(0.005, 0.01);
			camHUD.shake(0.005, 0.01);
			}
			}
			
		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		if (healyou)
			if (Paths.formatToSongPath(SONG.song) == 'restoring-the-light')
			emergencyheallmao.text = 'Press Space to max out your HP\nPress H to give health regeneration\n';
			else
			emergencyheallmao.text = 'Press H to give health regeneration';
		else
			if (Paths.formatToSongPath(SONG.song) == 'restoring-the-light')
			emergencyheallmao.text = 'Press Space to max out your HP\n\n';
			else
			emergencyheallmao.text = '';

		if (healyou && FlxG.keys.anyJustPressed(heallmao)) {
			healticks = 250;
			healyou = false;
			FlxG.sound.play(Paths.soundRandom('heal', 1, 3), FlxG.random.float(0.1, 0.2));
		}

		if (Paths.formatToSongPath(SONG.song) == 'light-legacy') {
			healyou = false;
			health = 1; // basically disabling health
		}

		if (ClientPrefs.iconbop) {
		var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP1.scale.set(mult, mult);

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP2.scale.set(mult, mult);

	//	iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
	//	iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));
		/*
		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.8)),Std.int(FlxMath.lerp(150, iconP1.height, 0.8)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.8)),Std.int(FlxMath.lerp(150, iconP2.height, 0.8)));*/

	//	iconP1.centerOffsets();
	//	iconP2.centerOffsets();

		iconP1.updateHitbox();
		iconP2.updateHitbox();
		}

		var iconOffset:Int = 26;

	//	iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
	//	iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * iconP2.scale.x) / 2 - iconOffset * 2;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (ClientPrefs.bigball) {
		if (health > 0.6)
			health = 0.6;		
		}
		else {
		if (health > 2)
			health = 2;
		}

		if (CoolUtil.difficultyString() == 'OLDCHART' || CoolUtil.difficultyString() == 'LEGACY' && ClientPrefs.animatedicons) { // Just so the icons don't take a second before it changes if they are static.
			if (healthBar.percent < 20)
				iconP1.animation.play(iconP1.charPublic + " lose", true);
			else
				iconP1.animation.play(iconP1.charPublic, true);
	
			if (healthBar.percent > 80)
				iconP2.animation.play(iconP2.charPublic + " lose", true);
			else
				iconP2.animation.play(iconP2.charPublic, true);
	
			if (healthBar.percent > 80)			
				iconP1.animation.play(iconP1.charPublic + " win", true);
	
			if (healthBar.percent < 20)
				iconP2.animation.play(iconP2.charPublic + " win", true);
		}
		if (!ClientPrefs.animatedicons) {
		if (healthBar.percent < 20) { 
			iconP1.animation.curAnim.curFrame = 1;
			iconP2.animation.curAnim.curFrame = 2;
		}
		else if (healthBar.percent > 80) {
			if (dad.curCharacter != 'gone3')
			iconP1.animation.curAnim.curFrame = 2;
			iconP2.animation.curAnim.curFrame = 1;
		}
		else {
			iconP1.animation.curAnim.curFrame = 0;
			iconP2.animation.curAnim.curFrame = 0;
		}
		}
		if (Paths.formatToSongPath(SONG.song) == 'restoring-the-light') {
		if (healthBar.percent < 50 && healthBar.percent > 20) { 
			scoreTxt.setFormat(Paths.font("alex.ttf"), 20, FlxColor.YELLOW, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		}
		if (healthBar.percent < 20) { 
			scoreTxt.setFormat(Paths.font("alex.ttf"), 20, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		if (healthBar.percent > 80) {
			scoreTxt.setFormat(Paths.font("alex.ttf"), 20, FlxColor.CYAN, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		if (Paths.formatToSongPath(SONG.song) == 'restoring-the-light') {
		if (healthBar.percent < 80 && healthBar.percent > 49) { // Normal
			scoreTxt.setFormat(Paths.font("alex.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		}
		else {
		if (healthBar.percent < 80 && healthBar.percent > 20) { // Normal
			scoreTxt.setFormat(Paths.font("alex.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		}

		if (FlxG.keys.anyJustPressed(tauntlol) && ClientPrefs.tauntability) {
		if (Paths.formatToSongPath(SONG.song) != 'restoring-the-light' && Paths.formatToSongPath(SONG.song) != 'trirotation') {
		boyfriend.playAnim('hey', true);
		boyfriend.specialAnim = true;
		}
		}

		if (FlxG.keys.anyJustPressed(debugKeysCharacter) && !endingSong && !inCutscene && ClientPrefs.debugmode) {
			persistentUpdate = false;
			paused = true;
			cancelMusicFadeTween();
			MusicBeatState.switchState(new CharacterEditorState(SONG.player2));
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if(updateTime) {
					var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var songCalc:Float = (songLength - curTime);
					if(ClientPrefs.timeBarType == 'Time Elapsed') songCalc = curTime;

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					if(ClientPrefs.timeBarType != 'Song Name')
						timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
					
					if(Paths.formatToSongPath(SONG.song) == "lacuna" || Paths.formatToSongPath(SONG.song) == "practice")
						{
							#if mac
							timeTxt.text = '??:??';
							#else
							timeTxt.text = '∞:∞';
							#end
						}
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		// RESET = Quick Game Over Screen
		if (!ClientPrefs.noReset && controls.RESET && !inCutscene && !endingSong)
		{
			health = 0;
			trace("RESET = True");
		}
		doDeathCheck();

		if (unspawnNotes[0] != null)
		{
			var time:Float = 3000;//shit be werid on 4:3
			if(songSpeed < 1) time /= songSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			if (!inCutscene) {
				if(!cpuControlled) {
					keyShit();
				} else if(boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss')) {
					if (health <= 0.8 && Paths.formatToSongPath(SONG.song) != 'restoring-the-light')
					boyfriend.playAnim('scared', true);
					else
					boyfriend.dance();
					//boyfriend.animation.curAnim.finish();
				}
			}

			var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
				if(!daNote.mustPress) strumGroup = opponentStrums;

				var strumX:Float = strumGroup.members[daNote.noteData].x;
				var strumY:Float = strumGroup.members[daNote.noteData].y;
				var strumAngle:Float = strumGroup.members[daNote.noteData].angle;
				var strumDirection:Float = strumGroup.members[daNote.noteData].direction;
				var strumAlpha:Float = strumGroup.members[daNote.noteData].alpha;
				var strumScroll:Bool = strumGroup.members[daNote.noteData].downScroll;

				strumX += daNote.offsetX;
				strumY += daNote.offsetY;
				strumAngle += daNote.offsetAngle;
				strumAlpha *= daNote.multAlpha;

				if (strumScroll) //Downscroll
				{
					//daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
					daNote.distance = (0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
				}
				else //Upscroll
				{
					//daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
					daNote.distance = (-0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
				}

				var angleDir = strumDirection * Math.PI / 180;
				if (daNote.copyAngle)
					daNote.angle = strumDirection - 90 + strumAngle;

				if(daNote.copyAlpha)
					daNote.alpha = strumAlpha;
				
				if(daNote.copyX)
					daNote.x = strumX + Math.cos(angleDir) * daNote.distance;

				if(daNote.copyY)
				{
					daNote.y = strumY + Math.sin(angleDir) * daNote.distance;

					//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
					if(strumScroll && daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith('end')) {
							daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * songSpeed + (46 * (songSpeed - 1));
							daNote.y -= 46 * (1 - (fakeCrochet / 600)) * songSpeed;
							if(PlayState.isPixelStage) {
								daNote.y += 8 + (6 - daNote.originalHeightForCalcs) * PlayState.daPixelZoom;
							} else {
								daNote.y -= 19;
							}
						} 
						daNote.y += (Note.swagWidth / 2) - (60.5 * (songSpeed - 1));
						daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (songSpeed - 1);
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
				{
					opponentNoteHit(daNote);
				}

				if(daNote.mustPress && cpuControlled) {
					if(daNote.isSustainNote) {
						if(daNote.canBeHit) {
							goodNoteHit(daNote);
						}
					} else if(daNote.strumTime <= Conductor.songPosition || (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress)) {
						goodNoteHit(daNote);
					}
				}
				
				var center:Float = strumY + Note.swagWidth / 2;
				if(strumGroup.members[daNote.noteData].sustainReduce && daNote.isSustainNote && (daNote.mustPress || !daNote.ignoreNote) &&
					(!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					if (strumScroll)
					{
						if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
							swagRect.height = (center - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;

							daNote.clipRect = swagRect;
						}
					}
					else
					{
						if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
							swagRect.y = (center - daNote.y) / daNote.scale.y;
							swagRect.height -= swagRect.y;

							daNote.clipRect = swagRect;
						}
					}
				}

				// Kill extremely late notes and cause misses
				if (Conductor.songPosition > noteKillOffset + daNote.strumTime)
				{
					if (daNote.mustPress && !cpuControlled &&!daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit)) {
						noteMiss(daNote);
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
		checkEventNote();
		
		if(!endingSong && !startingSong && ClientPrefs.debugmode) {
			if (FlxG.keys.justPressed.ONE) {
				KillNotes();
				FlxG.sound.music.onComplete();
			}
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				setSongTime(Conductor.songPosition + 10000);
				clearNotesBefore(Conductor.songPosition);
			}
		}

		setOnLuas('cameraX', camFollowPos.x);
		setOnLuas('cameraY', camFollowPos.y);
		setOnLuas('botPlay', cpuControlled);
		setOnLuas('mechanicsbitch', mechanicslolingame);
		setOnLuas('modchartsbitch', modchartslol);
		callOnLuas('onUpdatePost', [elapsed]);
		for (i in shaderUpdates){
			i(elapsed);
		}
	}

	function openChartEditor()
	{
		persistentUpdate = false;
		paused = true;
		cancelMusicFadeTween();
		MusicBeatState.switchState(new ChartingState());
		chartingMode = true;

		#if desktop
		DiscordClient.changePresence("Chart Editor", null, null, true);
		#end
	}

	public var isDead:Bool = false; //Don't mess with this on Lua!!!
	function doDeathCheck(?skipHealthCheck:Bool = false) {
		if (((skipHealthCheck && instakillOnMiss) || health <= 0) && !practiceMode && !isDead)
		{
			var ret:Dynamic = callOnLuas('onGameOver', []);
			if(ret != FunkinLua.Function_Stop) {
				boyfriend.stunned = true;
				deathCounter++;

				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				persistentUpdate = false;
				persistentDraw = false;
				for (tween in modchartTweens) {
					tween.active = true;
				}
				for (timer in modchartTimers) {
					timer.active = true;
				}
				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x - boyfriend.positionArray[0], boyfriend.getScreenPosition().y - boyfriend.positionArray[1], camFollowPos.x, camFollowPos.y));

				// MusicBeatState.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				
				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
				isDead = true;
				return true;
			}
		}
		return false;
	}
	private function tweenIcons():Void
		{
			iconP1.scale.set(1.3, 1.3);
			FlxTween.tween(iconP1, {"scale.x": 1, "scale.y": 1}, Conductor.stepCrochet / 500, {ease: FlxEase.cubeOut});
	
			iconP2.scale.set(1.3, 1.3);
			FlxTween.tween(iconP2, {"scale.x": 1, "scale.y": 1}, Conductor.stepCrochet / 500, {ease: FlxEase.cubeOut});
		}

	public function checkEventNote() {
		while(eventNotes.length > 0) {
			var leStrumTime:Float = eventNotes[0].strumTime;
			if(Conductor.songPosition < leStrumTime) {
				break;
			}

			var value1:String = '';
			if(eventNotes[0].value1 != null)
				value1 = eventNotes[0].value1;

			var value2:String = '';
			if(eventNotes[0].value2 != null)
				value2 = eventNotes[0].value2;

			triggerEventNote(eventNotes[0].event, value1, value2);
			eventNotes.shift();
		}
	}

	public function getControl(key:String) {
		var pressed:Bool = Reflect.getProperty(controls, key);
		//trace('Control result: ' + pressed);
		return pressed;
	}

	public function triggerEventNote(eventName:String, value1:String, value2:String) {
		switch(eventName) {
			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				var time:Float = Std.parseFloat(value2);
				if(Math.isNaN(time) || time <= 0) time = 0.6;

				if(value != 0) {
					if(dad.curCharacter.startsWith('gf')) { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					} else if (gf != null) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = time;
					}

					if(curStage == 'mall') {
						bottomBoppers.animation.play('hey', true);
						heyTimer = time;
					}
				}
				if(value != 1) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = time;
				}
			case 'changeicon': // i didn't steal this from starlight mayhem sorry.
				switch (value1)
				{
					case 'p1':
						FlxTween.tween(iconP1, {angle: iconP1.angle + 360}, 0.3, {ease: FlxEase.expoOut});
						new FlxTimer().start(0.1, function(tmr:FlxTimer) {
							iconP1.changeIcon(value2);
						});
						switch (value2)
						{
							case 'bf':
								remakebar(dada,dadaa,dadaaa,49,176,209);
							case 'ori':
								remakebar(dada,dadaa,dadaaa,255,255,255);
							case 'bfori':
								remakebar(dada,dadaa,dadaaa,255,255,255);

						}
					case 'p2': // don't realy have a use for this yet
						FlxTween.tween(iconP2, {angle: iconP2.angle + 360}, 0.3, {ease: FlxEase.expoOut});
						new FlxTimer().start(0.1, function(tmr:FlxTimer) {
							iconP2.changeIcon(value2);
						});
						switch (value2)
						{
							case 'ori':
								remakebar(255,255,225,bfa,bfaa,bfaaa);
							case 'bf':
								remakebar(49,176,209,bfa,bfaa,bfaaa);
							case 'bf-christmas':
								remakebar(235,78,76,bfa,bfaa,bfaaa);
							case 'fizz':
								remakebar(124,106,202,bfa,bfaa,bfaaa);
						}
				}
			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if(Math.isNaN(value) || value < 1) value = 1;
				gfSpeed = value;

			case 'Blammed Lights':
				var lightId:Int = Std.parseInt(value1);
				if(Math.isNaN(lightId)) lightId = 0;

				var chars:Array<Character> = [boyfriend, gf, dad];
				if(lightId > 0 && curLightEvent != lightId) {
					if(lightId > 5) lightId = FlxG.random.int(1, 5, [curLightEvent]);

					var color:Int = 0xffffffff;
					switch(lightId) {
						case 1: //Blue
							color = 0xff31a2fd;
						case 2: //Green
							color = 0xff31fd8c;
						case 3: //Pink
							color = 0xfff794f7;
						case 4: //Red
							color = 0xfff96d63;
						case 5: //Orange
							color = 0xfffba633;
					}
					curLightEvent = lightId;

					if(blammedLightsBlack.alpha == 0) {
						if(blammedLightsBlackTween != null) {
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = FlxTween.tween(blammedLightsBlack, {alpha: 1}, 1, {ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween) {
								blammedLightsBlackTween = null;
							}
						});

						for (char in chars) {
							if(char.colorTween != null) {
								char.colorTween.cancel();
							}
							char.colorTween = FlxTween.color(char, 1, FlxColor.WHITE, color, {onComplete: function(twn:FlxTween) {
								char.colorTween = null;
							}, ease: FlxEase.quadInOut});
						}
					} else {
						if(blammedLightsBlackTween != null) {
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = null;
						blammedLightsBlack.alpha = 1;

						for (char in chars) {
							if(char.colorTween != null) {
								char.colorTween.cancel();
							}
							char.colorTween = null;
						}
						dad.color = color;
						boyfriend.color = color;
						if (gf != null)
							gf.color = color;
					}
					
					if(curStage == 'philly') {
						if(phillyCityLightsEvent != null) {
							phillyCityLightsEvent.forEach(function(spr:BGSprite) {
								spr.visible = false;
							});
							phillyCityLightsEvent.members[lightId - 1].visible = true;
							phillyCityLightsEvent.members[lightId - 1].alpha = 1;
						}
					}
				} else {
					if(blammedLightsBlack.alpha != 0) {
						if(blammedLightsBlackTween != null) {
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = FlxTween.tween(blammedLightsBlack, {alpha: 0}, 1, {ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween) {
								blammedLightsBlackTween = null;
							}
						});
					}

					if(curStage == 'philly') {
						phillyCityLights.forEach(function(spr:BGSprite) {
							spr.visible = false;
						});
						phillyCityLightsEvent.forEach(function(spr:BGSprite) {
							spr.visible = false;
						});

						var memb:FlxSprite = phillyCityLightsEvent.members[curLightEvent - 1];
						if(memb != null) {
							memb.visible = true;
							memb.alpha = 1;
							if(phillyCityLightsEventTween != null)
								phillyCityLightsEventTween.cancel();

							phillyCityLightsEventTween = FlxTween.tween(memb, {alpha: 0}, 1, {onComplete: function(twn:FlxTween) {
								phillyCityLightsEventTween = null;
							}, ease: FlxEase.quadInOut});
						}
					}

					for (char in chars) {
						if(char.colorTween != null) {
							char.colorTween.cancel();
						}
						char.colorTween = FlxTween.color(char, 1, char.color, FlxColor.WHITE, {onComplete: function(twn:FlxTween) {
							char.colorTween = null;
						}, ease: FlxEase.quadInOut});
					}

					curLight = 0;
					curLightEvent = 0;
				}

			case 'Kill Henchmen':
				killHenchmen();

			case 'Add Camera Zoom':
				if(ClientPrefs.camZooms && FlxG.camera.zoom < 1.35) {
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(camZoom)) camZoom = 0.015;
					if(Math.isNaN(hudZoom)) hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;
				}

			case 'Trigger BG Ghouls':
				if(curStage == 'schoolEvil' && !ClientPrefs.lowQuality) {
					bgGhouls.dance(true);
					bgGhouls.visible = true;
				}

			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;
		
						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.playAnim(value1, true);
					char.specialAnim = true;
				}

			case 'Camera Follow Pos':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 0;
				if(Math.isNaN(val2)) val2 = 0;

				isCameraOnForcedPos = false;
				if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
					camFollow.x = val1;
					camFollow.y = val2;
					isCameraOnForcedPos = true;
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
				}

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = 0;
					var intensity:Float = 0;
					if(split[0] != null) duration = Std.parseFloat(split[0].trim());
					if(split[1] != null) intensity = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}


			case 'Change Character':
				var charType:Int = 0;
				switch(value1) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend.alpha = 0.00001;
							boyfriend = boyfriendMap.get(value2);
							boyfriend.alpha = lastAlpha;
							iconP1.changeIcon(boyfriend.healthIcon);
						}
						setOnLuas('boyfriendName', boyfriend.curCharacter);

					case 1:
						if(dad.curCharacter != value2) {
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							var lastAlpha:Float = dad.alpha;
							dad.alpha = 0.00001;
							dad = dadMap.get(value2);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf && gf != null) {
									gf.visible = true;
								}
							} else if(gf != null) {
								gf.visible = false;
							}
							dad.alpha = lastAlpha;
							iconP2.changeIcon(dad.healthIcon);
						}
						setOnLuas('dadName', dad.curCharacter);

					case 2:
						if(gf != null)
						{
							if(gf.curCharacter != value2)
							{
								if(!gfMap.exists(value2))
								{
									addCharacterToList(value2, charType);
								}

								var lastAlpha:Float = gf.alpha;
								gf.alpha = 0.00001;
								gf = gfMap.get(value2);
								gf.alpha = lastAlpha;
							}
							setOnLuas('gfName', gf.curCharacter);
						}
				}
				reloadHealthBarColors();
			
			case 'BG Freaks Expression':
				if(bgGirls != null) bgGirls.swapDanceType();
			
			case 'Change Scroll Speed':
				if (songSpeedType == "constant")
					return;
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 1;
				if(Math.isNaN(val2)) val2 = 0;

				var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * val1;

				if(val2 <= 0)
				{
					songSpeed = newValue;
				}
				else
				{
					songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, val2, {ease: FlxEase.linear, onComplete:
						function (twn:FlxTween)
						{
							songSpeedTween = null;
						}
					});
				}
		}
		callOnLuas('onEvent', [eventName, value1, value2]);
	}

	function moveCameraSection(?id:Int = 0):Void {
		if(SONG.notes[id] == null) return;

		if (gf != null && SONG.notes[id].gfSection)
		{
			camFollow.set(gf.getMidpoint().x, gf.getMidpoint().y);
			camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
			camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
			tweenCamIn();
			callOnLuas('onMoveCamera', ['gf']);
			return;
		}

		if (!SONG.notes[id].mustHitSection)
		{
			moveCamera(true);
			callOnLuas('onMoveCamera', ['dad']);
		}
		else
		{
			moveCamera(false);
			callOnLuas('onMoveCamera', ['boyfriend']);
		}
	}

	var cameraTwn:FlxTween;
	public function moveCamera(isDad:Bool)
	{
		if(isDad)
		{
			camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
			camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
			tweenCamIn();
		}
		else
		{
			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
			camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];

			if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1)
			{
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
					function (twn:FlxTween)
					{
						cameraTwn = null;
					}
				});
			}
		}
	}

	function tweenCamIn() {
		if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1.3) {
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	//Any way to do this without using a different function? kinda dumb
	private function onSongComplete()
	{
		finishSong(false);
	}
	public function finishSong(?ignoreNoteOffset:Bool = false):Void
	{
		var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.

		updateTime = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		vocals.pause();
		if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
			finishCallback();
		} else {
			finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
				finishCallback();
			});
		}
	}


	public var transitioning = false;
	public function endSong():Void
	{
		//Should kill you if you tried to cheat
		if(!startingSong) {
			notes.forEach(function(daNote:Note) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			});
			for (daNote in unspawnNotes) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			}

			if(doDeathCheck()) {
				return;
			}
		}

		characteroverride = "none";
		formoverride = "none";
		
		timeBarBG.visible = false;
		oriTIMEBG.visible = false;
		timeBar.visible = false;
		timeTxt.visible = false;
		canPause = false;
		endingSong = true;
	//	if (Paths.formatToSongPath(SONG.song) != 'tutorial')
	//	camZooming = true;
	//	else
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		deathCounter = 0;
		seenCutscene = false;

		#if ACHIEVEMENTS_ALLOWED
		if(achievementObj != null) {
			return;
		} else {
			var achieve:String = checkForAchievement(['Nibel_nomiss', 'Nibel2_nomiss', 'Niwen_nomiss', 'NibelOL_nomiss', 'Nibel2OL_nomiss', 'NiwenOL_nomiss', 'Bonus_nomiss',
				'ONELIFE_nomiss', 'COR_nomiss', 'SAO_nomiss', 'FAT_nomiss', 'NibelOG_nomiss', 'Nibel2OG_nomiss', 'NiwenOG_nomiss', 'BonusOG_nomiss', 'ur_bad', 'ur_good', 'oversinging', 'hype', 'two_keys', 'toastie', 'debugger', 'ohshit']);

			if(achieve != null) {
				startAchievement(achieve);
				return;
			}
		}
		#end
		
		#if LUA_ALLOWED
		var ret:Dynamic = callOnLuas('onEndSong', []);
		#else
		var ret:Dynamic = FunkinLua.Function_Continue;
		#end

		if(ret != FunkinLua.Function_Stop && !transitioning) {
			if (SONG.validScore)
			{
				#if !switch
				
				var percent:Float = ratingPercent;
				if(Math.isNaN(percent)) percent = 0;
				Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent);
				#end
			}

			if (chartingMode)
			{
				openChartEditor();
				return;
			}

			if (isStoryMode)
			{
				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					if (SelectGameState.inpurgatory) {
					FlxG.sound.playMusic(Paths.music('purFreakyMenu'));
					MusicBeatState.switchState(new PURMainMenuState());
					}
					else {
					FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.menuMusic)), 0);
					MusicBeatState.switchState(new StoryMenuState());
					}

					cancelMusicFadeTween();
					if(FlxTransitionableState.skipNextTransIn) {
						CustomFadeTransition.nextCamera = null;
					}

					// if ()
					if(!ClientPrefs.getGameplaySetting('practice', false) && !ClientPrefs.getGameplaySetting('botplay', false)) {
						StoryMenuState.weekCompleted.set(WeekData.weeksList[storyWeek], true);

						if (SONG.validScore)
						{
							Highscore.saveWeekScore(WeekData.getWeekFileName(), campaignScore, storyDifficulty);
							
						}

						FlxG.save.data.weekCompleted = StoryMenuState.weekCompleted;
						FlxG.save.flush();
					}
					changedDifficulty = false;
				}
				else
				{
					var difficulty:String = CoolUtil.getDifficultyFilePath();

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

					var winterHorrorlandNext = (Paths.formatToSongPath(SONG.song) == "eggnog");
					if (winterHorrorlandNext)
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if(winterHorrorlandNext) {
						new FlxTimer().start(1.5, function(tmr:FlxTimer) {
							cancelMusicFadeTween();
							LoadingState.loadAndSwitchState(new PlayState());
						});
					} else {
						cancelMusicFadeTween();
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				cancelMusicFadeTween();
				if(FlxTransitionableState.skipNextTransIn) {
					CustomFadeTransition.nextCamera = null;
				}
				MusicBeatState.switchState(new FreeplayState());
				if (SelectGameState.inpurgatory) {
					FlxG.sound.playMusic(Paths.music('purFreakyMenu'));
					MusicBeatState.switchState(new PURMainMenuState());
				}
				else {
					FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.menuMusic)), 0);
					MusicBeatState.switchState(new FreeplayState());
				}
				changedDifficulty = false;
			}
			transitioning = true;
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	var achievementObj:AchievementObject = null;
	function startAchievement(achieve:String) {
		achievementObj = new AchievementObject(achieve, camOther);
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve);
	}
	function achievementEnd():Void
	{
		achievementObj = null;
		if(endingSong && !inCutscene) {
			endSong();
		}
	}
	#end

	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	public var totalPlayed:Int = 0;
	public var totalNotesHit:Float = 0.0;

	public var showCombo:Bool = true;
	public var showRating:Bool = true;

	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
		//trace(noteDiff, ' ' + Math.abs(note.strumTime - Conductor.songPosition));

		// boyfriend.playAnim('hey');
		if (!ClientPrefs.disablevocals)
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;
	//	var noteData:Array<SwagSection>;
		//tryna do MS based judgment due to popular demand
		var daRating:String = Conductor.judgeNote(note, noteDiff);
		var perfectSickString:String = "";
		if ((allSicks) && (daRating == "sick"))
			daRating = "sick-perfect";

		if (cpuControlled)
			daRating = "sick-perfect"; // always MFC when botplay is on

		switch (daRating)
		{
			case "shit": // shit
				totalNotesHit += 0;
				note.ratingMod = 0;
				score = 50;
				sickrows = 0;
				if (ClientPrefs.sickmode)
					health -= 69;
				if (ClientPrefs.gfcmode)
					health -= 69;
				if (ClientPrefs.fcmode)
					health -= 69;
				if (ClientPrefs.healthtype != 'Old') {
				if (ClientPrefs.lateDamage)
				health -= 0.05 * healthLoss;
				else
				health += 0.01 * healthGain;
				}
				else {
					if (ClientPrefs.lateDamage)
					health -= 0.1 * healthLoss;
						else
					health += 0.02 * healthGain;
				}
				if (allSicks)
					allSicks = false;
				if(!note.ratingDisabled) shits++;
			case "bad": // bad
				totalNotesHit += 0.5;
				note.ratingMod = 0.5;
				score = 100;
				sickrows = 0;
				if (ClientPrefs.lateDamage) {
				combo = 0;
				songMisses++;
				}
				if (ClientPrefs.sickmode)
					health -= 69;
				if (ClientPrefs.gfcmode)
					health -= 69;
				if (ClientPrefs.healthtype != 'Old') {
					if (ClientPrefs.lateDamage)
					health -= 0.025 * healthLoss;
					else
					health += 0.01 * healthGain;
				}
				else {
					if (ClientPrefs.lateDamage)
					health -= 0.025 * healthLoss;
						else
					health += 0.02 * healthGain;
				}
				if (allSicks)
					allSicks = false;
				if(!note.ratingDisabled) bads++;
			case "good": // good
				totalNotesHit += 0.75;
				note.ratingMod = 0.75;
				score = 200;
				sickrows = 0;
				if (ClientPrefs.sickmode)
				health -= 69;
				if (ClientPrefs.healthtype != 'Old') {
				if (!ClientPrefs.lateDamage)
				health += 0.02 * healthGain;
				}
				else {
				health += 0.02;
				}
				if (allSicks)
					allSicks = false;
				if(!note.ratingDisabled) goods++;
			case "sick": // sick
				totalNotesHit += 1;
				note.ratingMod = 1;
				sickrows += 1;
				if (ClientPrefs.healthtype != 'Old')
				health += 0.08 * healthGain;
				else
				health += 0.02;
				if(!note.ratingDisabled) sicks++;
			case "sick-perfect": // sick but epic
				totalNotesHit += 1;
				note.ratingMod = 1;
				sickrows += 1;
				if (ClientPrefs.healthtype != 'Old')
				health += 0.08 * healthGain;
				else
				health += 0.02;
				if(!note.ratingDisabled) sicks++;



		}

		note.rating = daRating;

		if(daRating == 'sick' && !note.noteSplashDisabled)
		{
			spawnNoteSplashOnNote(note);
		}
		if(daRating == 'sick-perfect' && !note.noteSplashDisabled)
		{
			spawnNoteSplashOnNote(note);
		}

		if(!practiceMode && !cpuControlled) {
			songScore += score;
			if(!note.ratingDisabled)
			{
				songHits++;
				totalPlayed++;
				RecalculateRating();
			}

			if(ClientPrefs.scoreZoom)
			{
				if(scoreTxtTween != null) {
					scoreTxtTween.cancel();
				}
				scoreTxt.scale.x = 1.075;
				scoreTxt.scale.y = 1.075;
				scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
					onComplete: function(twn:FlxTween) {
						scoreTxtTween = null;
					}
				});
			}
		}

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (PlayState.isPixelStage)
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.cameras = [camHUD];
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.visible = (!ClientPrefs.hideHud && showRating);
		rating.x += ClientPrefs.comboOffset[0];
		rating.y -= ClientPrefs.comboOffset[1];

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + (allSicks == true ? 'golden/' : allSicks == false ? '' : "") + 'combo' + pixelShitPart2));
		comboSpr.cameras = [camHUD];
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.visible = (!ClientPrefs.hideHud && showCombo);
		comboSpr.x += ClientPrefs.comboOffset[0];
		comboSpr.y -= ClientPrefs.comboOffset[1];


		comboSpr.velocity.x += FlxG.random.int(1, 10);
		insert(members.indexOf(strumLineNotes), rating);

		if (!PlayState.isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.85));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.85));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		if(combo >= 1000) {
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}
		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + (allSicks == true ? 'golden/' : allSicks == false ? '' : "") + 'num' + Std.int(i) + pixelShitPart2));
			numScore.cameras = [camHUD];
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			numScore.x += ClientPrefs.comboOffset[2];
			numScore.y -= ClientPrefs.comboOffset[3];

			if (!PlayState.isPixelStage)
			{
				numScore.antialiasing = ClientPrefs.globalAntialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
			numScore.visible = !ClientPrefs.hideHud;

			//if (combo >= 10 || combo == 0)
				insert(members.indexOf(strumLineNotes), numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
	}

	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		//trace('Pressed: ' + eventKey);
		if (!cpuControlled && !paused && key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || ClientPrefs.controllerMode))
			{
				if(!boyfriend.stunned && generatedMusic && !endingSong)
				{
					//more accurate hit time for the ratings?
					var lastTime:Float = Conductor.songPosition;
					Conductor.songPosition = FlxG.sound.music.time;
	
					var canMiss:Bool = !ClientPrefs.ghostTapping;
	
					// heavily based on my own code LOL if it aint broke dont fix it
					var pressNotes:Array<Note> = [];
					//var notesDatas:Array<Int> = [];
					var notesStopped:Bool = false;
	
					var sortedNotesList:Array<Note> = [];
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote)
						{
							if(daNote.noteData == key)
							{
								sortedNotesList.push(daNote);
								//notesDatas.push(daNote.noteData);
							}
							canMiss = true;
						}
					});
					sortedNotesList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
	
					if (sortedNotesList.length > 0) {
						for (epicNote in sortedNotesList)
						{
							for (doubleNote in pressNotes) {
								if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
									doubleNote.kill();
									notes.remove(doubleNote, true);
									doubleNote.destroy();
								} else
									notesStopped = true;
							}
								
							// eee jack detection before was not super good
							if (!notesStopped) {
								goodNoteHit(epicNote);
								pressNotes.push(epicNote);
							}
	
						}
					}
					else if (canMiss && ClientPrefs.antimash) {
						noteMissPress(key);
						callOnLuas('noteMissPress', [key]);
					}
	
					// I dunno what you need this for but here you go
					//									- Shubs
	
					// Shubs, this is for the "Just the Two of Us" achievement lol
					//									- Shadow Mario
					keysPressed[key] = true;
	
					//more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
					Conductor.songPosition = lastTime;
				}
	/*	if (!cpuControlled && !paused && key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || ClientPrefs.controllerMode))
		{
			if(!boyfriend.stunned && generatedMusic && !endingSong)
			{
				//more accurate hit time for the ratings?
				var lastTime:Float = Conductor.songPosition;
				Conductor.songPosition = FlxG.sound.music.time;

				var canMiss:Bool = !ClientPrefs.ghostTapping;

				var canMiss:Bool;

				// heavily based on my own code LOL if it aint broke dont fix it
				var pressNotes:Array<Note> = [];
				//var notesDatas:Array<Int> = [];
				var notesStopped:Bool = false;

				var sortedNotesList:Array<Note> = [];
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote)
					{
						if(daNote.noteData == key)
						{
							sortedNotesList.push(daNote);
							//notesDatas.push(daNote.noteData);
						}
						canMiss = true;
					}
				});
				sortedNotesList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

				if (sortedNotesList.length > 0) {
					for (epicNote in sortedNotesList)
					{
						for (doubleNote in pressNotes) {
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
								doubleNote.kill();
								notes.remove(doubleNote, true);
								doubleNote.destroy();
							} else
								notesStopped = true;
						}
							
						// eee jack detection before was not super good
						if (!notesStopped) {
							goodNoteHit(epicNote);
							pressNotes.push(epicNote);
						}

					}
				}
				else if (canMiss && ClientPrefs.antimash) {
					noteMissPress(key);
					callOnLuas('noteMissPress', [key]);
				//	ghostMiss();
				}

				// I dunno what you need this for but here you go
				//									- Shubs

				// Shubs, this is for the "Just the Two of Us" achievement lol
				//									- Shadow Mario
				keysPressed[key] = true;

				//more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
				Conductor.songPosition = lastTime;
			}*/

			var spr:StrumNote = playerStrums.members[key];
			if (!cpuControlled) { // disables player strums when botplay is on.
			if(spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyPress', [key]);
		}
		}
		//trace('pressed: ' + controlArray);
	}
	
	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		if(!cpuControlled && !paused && key > -1)
		{
			var spr:StrumNote = playerStrums.members[key];
			if(spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyRelease', [key]);
		}
		//trace('released: ' + controlArray);
	}

	private function getKeyFromEvent(key:FlxKey):Int
	{
		if(key != NONE)
		{
			for (i in 0...keysArray.length)
			{
				for (j in 0...keysArray[i].length)
				{
					if(key == keysArray[i][j])
					{
						return i;
					}
				}
			}
		}
		return -1;
	}

	// Hold notes
	private function keyShit():Void
	{
		// HOLDING
		var up = controls.NOTE_UP;
		var right = controls.NOTE_RIGHT;
		var down = controls.NOTE_DOWN;
		var left = controls.NOTE_LEFT;
		var controlHoldArray:Array<Bool> = [left, down, up, right];
		
		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var controlArray:Array<Bool> = [controls.NOTE_LEFT_P, controls.NOTE_DOWN_P, controls.NOTE_UP_P, controls.NOTE_RIGHT_P];
			if(controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if(controlArray[i])
						onKeyPress(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, -1, keysArray[i][0]));
				}
			}
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (!boyfriend.stunned && generatedMusic)
		{
			var canMiss:Bool = !ClientPrefs.ghostTapping;
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (daNote.isSustainNote && controlHoldArray[daNote.noteData] && daNote.canBeHit 
				&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit) {
					goodNoteHit(daNote);
					totalNotesHit += 1;
					totalPlayed += 1;
					if (allSicks) {
					pushrankdownlmao = 4;
					scoreTxt.text = 'Score: ' + songScore + ' - Accuracy: 99% [MFC] - Combo Breaks: 0 (0) - Rank: S+ (Sick!)';
					}
				}
				if(SONG.song.toLowerCase() == "defeat")
					{
						canMiss = true;
						ghostMiss();
					}
			});

			if (controlHoldArray.contains(true) && !endingSong) {
				#if ACHIEVEMENTS_ALLOWED
				var achieve:String = checkForAchievement(['oversinging']);
				if (achieve != null) {
					startAchievement(achieve);
				}
				#end
			}
			else if (boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				if (health <= 0.8 && Paths.formatToSongPath(SONG.song) != 'restoring-the-light')
				boyfriend.playAnim('scared', true);
				else
				boyfriend.dance();
				//boyfriend.animation.curAnim.finish();
			}
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var controlArray:Array<Bool> = [controls.NOTE_LEFT_R, controls.NOTE_DOWN_R, controls.NOTE_UP_R, controls.NOTE_RIGHT_R];
			if(controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if(controlArray[i])
						onKeyRelease(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, -1, keysArray[i][0]));
				}
			}
		}
	}

	function noteMiss(daNote:Note):Void { //You didn't hit the key and let it go offscreen, also used by Hurt Notes
		//Dupe note remove
		notes.forEachAlive(function(note:Note) {
			if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 1) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});
	//	if (storyDifficulty == 1 && curSong.toLowerCase() == 'corrupurgation') {
	//		health -= 69; // If you set the Modifier lower than 1 then you're a loser.
	//	}
		if (Paths.formatToSongPath(SONG.song) == 'defeat')
			health -= 69;

		if (CoolUtil.difficultyString() == 'ONELIFE') {
			health -= 0.2;
		}
		combo = 0;
		sickrows = 0;
		health -= 0.1 * healthLoss;
		if(instakillOnMiss)
		{
			vocals.volume = 0;
			doDeathCheck(true);
		}
		if (ClientPrefs.sickmode)
			health -= 69;
		if (ClientPrefs.gfcmode)
			health -= 69;
		if (ClientPrefs.fcmode)
			health -= 69;

		if(allSicks)
			allSicks = false;

		switch (boyfriend.curCharacter) { // different miss sounds
			case 'raylo-front':
				FlxG.sound.play(Paths.sound('avali_hurt'));
			case 'finn-player' | 'finn-scared' | 'finn-scared1' | 'ori-player' | 'ori' | 'ori-og' | 'nylo' | 'voltex':
			FlxG.sound.play(Paths.sound('finn-hurt'));
			default:
				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
		}

		//For testing purposes
		//trace(daNote.missHealth);
		songMisses++;
		vocals.volume = 0;
		if(!practiceMode) songScore -= 10;
		
		totalPlayed++;
		RecalculateRating();

		var char:Character = boyfriend;
		if(daNote.gfNote) {
			char = gf;
		}
	//	if (SONG.player1 != 'bf' || SONG.player1 != 'bf-up' || SONG.player1 != 'bf-og' || SONG.player1 != 'bf-old' || SONG.player1 != 'bf-run' || SONG.player1 != 'bf-scared' || SONG.player1 != 'bf-pixel' || SONG.player1 != 'bf-up-old' || SONG.player1 != 'finn-player' || SONG.player1 != 'ori-player' || SONG.player1 != 'ori' || SONG.player1 != 'ori-scared')
	//	boyfriend.color = 0xFF000084;

		if(char != null && char.hasMissAnimations)
		{
			var daAlt = '';
			if(daNote.noteType == 'Alt Animation') daAlt = '-alt';

			var animToPlay:String = singAnimations[Std.int(Math.abs(daNote.noteData))] + 'miss' + daAlt;
			char.playAnim(animToPlay, true);
		}

		callOnLuas('noteMiss', [notes.members.indexOf(daNote), daNote.noteData, daNote.noteType, daNote.isSustainNote]);
	}

	function ghostMiss(statement:Bool = false, direction:Int = 0, ?ghostMiss:Bool = false) {
		if (statement) {
			noteMissPress(direction);
			callOnLuas('noteMissPress', [direction]);
		}
	}

	function noteMissPress(direction:Int = 1):Void //You pressed a key when there was no notes to press for this key
	{
		if (!boyfriend.stunned)
		{
			health -= 0.1 * healthLoss;
			if(instakillOnMiss)
			{
				vocals.volume = 0;
				doDeathCheck(true);
			}
			if (ClientPrefs.sickmode)
				health -= 69;
			if (ClientPrefs.gfcmode)
				health -= 69;
			if (ClientPrefs.fcmode)
				health -= 69;

			if(allSicks)
				allSicks = false;

			if(ghostTapping) return;

			if (combo > 5 && gf != null && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
		//	if (storyDifficulty == 1 && curSong.toLowerCase() == 'corrupurgation') {
		//		health -= 69;
		//	}
			if (Paths.formatToSongPath(SONG.song) == 'defeat')
				health -= 69;

			if (CoolUtil.difficultyString() == 'ONELIFE') {
				health -= 0.2;
			}
			combo = 0;

			if(!practiceMode) songScore -= 10;
			if(!endingSong) {
				songMisses++;
			}
			totalPlayed++;
			RecalculateRating();

			switch (boyfriend.curCharacter) {
				case 'raylo-front':
					FlxG.sound.play(Paths.sound('avali_hurt'));
				case 'finn-player' | 'finn-scared' | 'finn-scared1' | 'ori-player' | 'ori' | 'ori-og' | 'james' | 'desito-og' | 'fin':
				FlxG.sound.play(Paths.sound('finn-hurt'));
				default:
					FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			}
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			/*boyfriend.stunned = true;

			// get stunned for 1/60 of a second, makes you able to
			new FlxTimer().start(1 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});*/

			if(boyfriend.hasMissAnimations) {
				boyfriend.playAnim(singAnimations[Std.int(Math.abs(direction))] + 'miss', true);
			}
			vocals.volume = 0;
		}
	}

	function opponentNoteHit(note:Note):Void
	{
		if (Paths.formatToSongPath(SONG.song) != 'tutorial')
			camZooming = true;

		if(note.noteType == 'health') {
			if (health >= 0.45)
			health -= 0.05;
			FlxG.sound.play(Paths.soundRandom('heal', 1, 3), FlxG.random.float(0.7, 1));
		}

		if(note.noteType == 'Hey!' && dad.animOffsets.exists('hey')) {
			dad.playAnim('hey', true);
			dad.specialAnim = true;
			dad.heyTimer = 0.6;
		} else if(!note.noAnimation) {
			var altAnim:String = "";

			var curSection:Int = Math.floor(curStep / 16);
			if (SONG.notes[curSection] != null)
			{
				if (SONG.notes[curSection].altAnim || note.noteType == 'Alt Animation') {
					altAnim = '-alt';
				}
			}

			var char:Character = dad;
			var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))] + altAnim;
			if(note.gfNote) {
				char = gf;
			}

			if(char != null)
			{
				char.playAnim(animToPlay, true);
				char.holdTimer = 0;
			}
		}

		if (SONG.needsVoices && !ClientPrefs.disablevocals)
			vocals.volume = 1;

		var time:Float = 0.15;
		if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
			time += 0.15;
		}
		StrumPlayAnim(true, Std.int(Math.abs(note.noteData)) % 4, time);
		note.hitByOpponent = true;
		if (dad.curCharacter == 'kuro' && Paths.formatToSongPath(SONG.song) == 'disruption') {
			if (curBeat >= 0 && curBeat <= 288)
			health -= 0.01;
			if (curBeat >= 288 && curBeat <= 415)
			health -= 0.005;
			if (curBeat >= 415)
			health -= 0.01;
		}
		if (dad.curCharacter == 'saln-god' && Paths.formatToSongPath(SONG.song) == 'opposition') {
			if (health >= 0.23)
			health -= 0.03;
		}

		if (dad.curCharacter == 'saln-god' && Paths.formatToSongPath(SONG.song) == 'rebound') {
			if (health >= 0.21)
			health -= 0.01;
		}

		if (dad.curCharacter == 'saln-god' && Paths.formatToSongPath(SONG.song) == 'reality-breaking') {
			if (health >= 0.525)
			health -= 0.025;
		}

		if (dad.curCharacter == 'saln-god' && Paths.formatToSongPath(SONG.song) == 'reality-breaking-classic') {
			if (health >= 0.52)
			health -= 0.02;
		}

		if (dad.curCharacter == 'finn-think' && Paths.formatToSongPath(SONG.song) == 'think') {
			if (health >= 0.51)
			health -= 0.01 * healthGain;
		}

		if (Paths.formatToSongPath(SONG.song) == 'final-boss-chan')
			health -= 0.015;

	/*	if (dad.curCharacter == 'arzo' && storyDifficulty == 0)
			{
			if (Paths.formatToSongPath(SONG.song) == 'corrupurgation' && health >= 0.015)
				health -= 0.015;
			}*/

		if (dad.curCharacter == 'shriek-old') {
			if (health >= 0.3)
			health -= 0.02;
			
			if (!ClientPrefs.reducedmovements) {
				FlxG.camera.shake(0.01, 1);
			}
		}

		if (dad.curCharacter == 'altalvar') {
			health -= 0.015;
			if (!ClientPrefs.reducedmovements) {
				FlxG.camera.shake(0.01, 1);
			}
		}

		if (dad.curCharacter == 'ben'){ 
			if (curBeat <= 126)
			health -= 0.02;
			if (curBeat >= 127 && curBeat <= 190)
			health -= 0.005;
			if (curBeat >= 191 && curBeat <= 321)
			health -= 0.02;
			if (curBeat >= 322)
			health -= 0.005;

			if (!ClientPrefs.reducedmovements) {
				FlxG.camera.shake(0.01, 0.1);
				camHUD.shake(0.01, 0.1);
			}
		}

		if (dad.curCharacter == 'shriek') {
			if (!ClientPrefs.reducedmovements) {
				FlxG.camera.shake(0.01, 0.1);
				camHUD.shake(0.01, 0.01);
			}
		}

		if (dad.curCharacter == 'evilori' && Paths.formatToSongPath(SONG.song) == 'trirotation') {
			health -= 0.02;
			if (!ClientPrefs.reducedmovements) {
				FlxG.camera.shake(0.01, 0.1);
				camHUD.shake(0.01, 0.1);
			}
		}
		if (dad.curCharacter == 'evilori' && Paths.formatToSongPath(SONG.song) != 'trirotation' && Paths.formatToSongPath(SONG.song) != 'upheaval') {
			if (health >= 0.2)
			health -= 0.01;
			if (!ClientPrefs.reducedmovements) {
				FlxG.camera.shake(0.01, 0.1);
				camHUD.shake(0.01, 0.1);
			}
		}

		if (dad.curCharacter == 'nightmare-kuro') {
			if (health >= 0.05)
			health -= 0.05;
			FlxG.camera.shake(0.01, 0.1);
			camHUD.shake(0.01, 0.1);
		}

		if (dad.curCharacter == 'nightmare-shriek') {
			if (health >= 0.08)
			health -= 0.08;
			FlxG.camera.shake(0.01, 0.1);
			camHUD.shake(0.01, 0.1);
		}

		if (Paths.formatToSongPath(SONG.song) == 'lacuna' || Paths.formatToSongPath(SONG.song) == 'oh-no') {
			if (ClientPrefs.screenshakeenabled)
			shakewindow();

			if(gf.animOffsets.exists('scared')) {
			gf.playAnim('scared', true);
			}
		}

		callOnLuas('opponentNoteHit', [notes.members.indexOf(note), Math.abs(note.noteData), note.noteType, note.isSustainNote]);

		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();

			if (dad.curCharacter == 'shriek') {
				if (health >= 0.415 && CoolUtil.difficultyString() != 'ONELIFE')
				health -= 0.0; // ha ha no damage go brrrr
				if (health >= 0.025 && CoolUtil.difficultyString() == 'ONELIFE')
					health -= 0.025;
				gf.playAnim('scared', true);
			}

			if (dad.curCharacter == 'shriekb') {
				if (health >= 0.415)
				health -= 0.015;
			}

			if (dad.curCharacter == 'finn-think' && Paths.formatToSongPath(SONG.song) == 'think') {
				if (health >= 0.525)
				health -= 0.025 * healthGain;
			}

		/*	if (dad.curCharacter == 'arzo' && storyDifficulty == 1)
				{
					if (Paths.formatToSongPath(SONG.song) == 'corrupurgation' && curBeat >= 0 && curBeat <= 407)
						health -= 0.01;
					if (Paths.formatToSongPath(SONG.song) == 'corrupurgation' && curBeat >= 408 && curBeat <= 472)
						health -= 0.005;
					if (Paths.formatToSongPath(SONG.song) == 'corrupurgation' && curBeat >= 472 && curBeat <= 536)
						health -= 0.01;
					if (Paths.formatToSongPath(SONG.song) == 'corrupurgation' && curBeat >= 536)
						health -= 0.02;
				
				}*/

			if (!note.noteSplashDisabled && Paths.formatToSongPath(SONG.song) != 'deformation' && Paths.formatToSongPath(SONG.song) != 'reality-breaking' && Paths.formatToSongPath(SONG.song) != 'starbucks' && Paths.formatToSongPath(SONG.song) != 'shriek-and-ori' && ClientPrefs.opponentnotesplashes) {
				spawnNoteSplashOnNote2(note);
			}
		}
	}
	
	function shakewindow()
		{
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				Lib.application.window.move(Lib.application.window.x + FlxG.random.int( -10, 10),Lib.application.window.y + FlxG.random.int( -2, 2));
			}, 20);
		}

	var nps:Int = 0;

	function goodNoteHit(note:Note):Void
	{
		if (!note.isSustainNote)
			notesHitArray.push(Date.now());
		if (!note.wasGoodHit)
		{
			if (ClientPrefs.hitsoundVolume > 0 && !note.hitsoundDisabled)
			{
				FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
			}

			if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;

			if(note.hitCausesMiss) {
				noteMiss(note);
				if(!note.noteSplashDisabled && !note.isSustainNote) {
					spawnNoteSplashOnNote(note);
				}

				switch(note.noteType) {
					case 'Hurt Note': //Hurt note
						if(boyfriend.animation.getByName('hurt') != null) {
							boyfriend.playAnim('hurt', true);
							boyfriend.specialAnim = true;
						}
					case 'decay-note': //Glitch note
						if(boyfriend.animation.getByName('hurt') != null) {
							boyfriend.playAnim('hurt', true);
							boyfriend.specialAnim = true;
						}
						FlxG.sound.play(Paths.sound('rock'));
						PlayState.poisonstacks++;
					case 'Glitch': //Glitch note but old.
						// It's the same as the new glitch note but without the health drain
						// since it never existed back in the legacy.
						if(boyfriend.animation.getByName('hurt') != null) {
							boyfriend.playAnim('hurt', true);
							boyfriend.specialAnim = true;
						}
						FlxG.sound.play(Paths.sound('rock'));
					case 'health':
						health += 0.05;
					case 'fuck you':
						System.exit(0);
				}
				
				note.wasGoodHit = true;
				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}

			if (!note.isSustainNote)
			{
				combo += 1;
				popUpScore(note);
				if(combo > 9999) combo = 9999;
				switch(note.noteType) {
					case 'health':
						FlxG.sound.play(Paths.soundRandom('heal', 1, 3), FlxG.random.float(0.7, 1));
				}
			}
			if (ClientPrefs.healthtype == 'Old')
			health += 0.01 * healthGain; // This will at least make the song easier

			RecalculateRating();
			if(!note.noAnimation) {
				var daAlt = '';
				if(note.noteType == 'Alt Animation') daAlt = '-alt';
	
				var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];

				if(note.gfNote) 
				{
					if(gf != null)
					{
						gf.playAnim(animToPlay + daAlt, true);
						gf.holdTimer = 0;
					}
				}
				else
				{
					boyfriend.playAnim(animToPlay + daAlt, true);
					boyfriend.holdTimer = 0;
				}

				if(note.noteType == 'Hey!') {
					if(boyfriend.animOffsets.exists('hey')) {
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.6;
					}
	
					if(gf != null && gf.animOffsets.exists('cheer')) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
					}
				}
			}

			if(cpuControlled) {
				var time:Float = 0.15;
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
					time += 0.15;
				}
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)) % 4, time);
			} else {
				playerStrums.forEach(function(spr:StrumNote)
				{
					if (Math.abs(note.noteData) == spr.ID)
					{
						spr.playAnim('confirm', true);
					}
				});
			}
			note.wasGoodHit = true;
			if (!ClientPrefs.disablevocals)
			vocals.volume = 1;

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}
	function spawnNoteSplashOnNote2(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			if (Paths.formatToSongPath(SONG.song) != 'starbucks') {
			var opstrum:StrumNote = opponentStrums.members[note.noteData];
			if(opstrum != null) {
				spawnNoteSplash(opstrum.x, opstrum.y, note.noteData, note);
			}
		}
			
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {
		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;
		
		var hue:Float = ClientPrefs.arrowHSV[data % 4][0] / 360;
		var sat:Float = ClientPrefs.arrowHSV[data % 4][1] / 100;
		var brt:Float = ClientPrefs.arrowHSV[data % 4][2] / 100;
		if(note != null) {
			skin = note.noteSplashTexture;
			hue = note.noteSplashHue;
			sat = note.noteSplashSat;
			brt = note.noteSplashBrt;
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, skin, hue, sat, brt);
		grpNoteSplashes.add(splash);
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	var carTimer:FlxTimer;
	function fastCarDrive()
	{
		//trace('Car drive');
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		carTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
			carTimer = null;
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			if (gf != null)
			{
				gf.playAnim('hairBlow');
				gf.specialAnim = true;
			}
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		if(gf != null)
		{
			gf.danced = false; //Sets head to the correct position once the animation ends
			gf.playAnim('hairFall');
			gf.specialAnim = true;
		}
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		if(!ClientPrefs.lowQuality) halloweenBG.animation.play('halloweem bg lightning strike');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if(boyfriend.animOffsets.exists('scared')) {
			boyfriend.playAnim('scared', true);
		}

		if(gf != null && gf.animOffsets.exists('scared')) {
			gf.playAnim('scared', true);
		}

		if(ClientPrefs.camZooms) {
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;

			if(!camZooming) { //Just a way for preventing it to be permanently zoomed until Skid & Pump hits a note
				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.5);
				FlxTween.tween(camHUD, {zoom: 1}, 0.5);
			}
		}

		if(ClientPrefs.flashing) {
			halloweenWhite.alpha = 0.4;
			FlxTween.tween(halloweenWhite, {alpha: 0.5}, 0.075);
			FlxTween.tween(halloweenWhite, {alpha: 0}, 0.25, {startDelay: 0.15});
		}
	}

	function killHenchmen():Void
	{
		if(!ClientPrefs.lowQuality && ClientPrefs.violence && curStage == 'limo') {
			if(limoKillingState < 1) {
				limoMetalPole.x = -400;
				limoMetalPole.visible = true;
				limoLight.visible = true;
				limoCorpse.visible = false;
				limoCorpseTwo.visible = false;
				limoKillingState = 1;

				#if ACHIEVEMENTS_ALLOWED
				Achievements.henchmenDeath++;
				FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
				var achieve:String = checkForAchievement(['roadkill_enthusiast']);
				if (achieve != null) {
					startAchievement(achieve);
				} else {
					FlxG.save.flush();
				}
				FlxG.log.add('Deaths: ' + Achievements.henchmenDeath);
				#end
			}
		}
	}

	function resetLimoKill():Void
	{
		if(curStage == 'limo') {
			limoMetalPole.x = -500;
			limoMetalPole.visible = false;
			limoLight.x = -500;
			limoLight.visible = false;
			limoCorpse.x = -500;
			limoCorpse.visible = false;
			limoCorpseTwo.x = -500;
			limoCorpseTwo.visible = false;
		}
	}

	private var preventLuaRemove:Bool = false;
	override function destroy() {
		preventLuaRemove = true;
		for (i in 0...luaArray.length) {
			luaArray[i].call('onDestroy', []);
			luaArray[i].stop();
		}
		luaArray = [];

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		super.destroy();
	}

	public static function cancelMusicFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	public function removeLua(lua:FunkinLua) {
		if(luaArray != null && !preventLuaRemove) {
			luaArray.remove(lua);
		}
	}

	var lastStepHit:Int = -1;
	override function stepHit()
	{
		super.stepHit();
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > 20))
		{
			resyncVocals();
		}

		if (pushrankdownlmao >= 1)
		pushrankdownlmao -= 1;

		if (healticks >= 1) {
			healticks -= 1;
			health += 0.01;
		}

		if (health >= (poisonstacks / 100) && enablepoisonlol) // Just so it's actually possible
			health -= (poisonstacks / 100);

		if(curStep == lastStepHit) {
			return;
		}

		switch (Paths.formatToSongPath(SONG.song)) {
			case 'trirotation':
				switch (curStep) {
					case 1:
						healyou = true;
					case 960:
						shakeCam = true;
					case 1139:
						shakeCam = false;
					case 1152:
						healyou = false;
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
						}
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
						}
					case 1183:
						FlxTween.tween(iconP2, {alpha: 0}, 0.5, {ease: FlxEase.linear});
				}
		}

		if (curStep == 1)
			{
				if (Paths.formatToSongPath(SONG.song) != 'decay') { // does not show until half way
				mechtut.alpha = 1;
				mechtut.y = -1000;
			//	FlxTween.tween(mechtut, {alpha: 1}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(mechtut, {y: 0}, 1, {ease: FlxEase.expoOut});
				}
				songinfo.alpha = 1;
			//	composertext.alpha = 1;
			//	songcomposer.alpha = 1;
				FlxTween.tween(songinfo, {x: 0}, 1, {ease: FlxEase.expoOut});
			}
		
		if (curStep == 32)
			{
			//	composertext.alpha = 0;
			//	songcomposer.alpha = 0;
			/*	FlxTween.tween(songinfo, {x: -1000}, 1, {
					ease: FlxEase.expoIn,
					onComplete: function(twn:FlxTween)
					{
						songinfo.alpha = 0;
					}
				});*/
				FlxTween.tween(songinfo, {alpha: 0}, 1, {ease: FlxEase.linear});
				
				if (Paths.formatToSongPath(SONG.song) != 'restoring-the-light')
				FlxTween.tween(mechtut, {alpha: 0}, 2, {ease: FlxEase.linear});

				FlxTween.tween(emergencyheallmao, {alpha: 0.4}, 4, {ease: FlxEase.linear}); // just so it doesn't always appear on screen.
			}
		if (ClientPrefs.mechanicslol) {
		if (ClientPrefs.bigball) {
		if(Paths.formatToSongPath(SONG.song) == 'restoring-the-light' && curBeat >= 1 && curBeat <= 416 && health >= (0.42 + (songMisses / 1500)) && ClientPrefs.mechanicslol)
			health -= 0.005 + (songMisses / 1500);
		}
		else {
		if(Paths.formatToSongPath(SONG.song) == 'restoring-the-light' && curBeat >= 1 && curBeat <= 416 && health >= (0.42 + (songMisses / 2500)) && ClientPrefs.mechanicslol)
			health -= 0.015 + (songMisses / 2500);
		}
		}

		switch (Paths.formatToSongPath(SONG.song)) {
			case 'rascal':
				switch (curStep) {
					case 1:
						healyou = false;
						FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
					case 208:
						healyou = true;
						FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
					case 976:
						FlxG.sound.play(Paths.sound('wellwellwell'), 0.6);
						FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
					case 1104:
						FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
					case 1872:
						healyou = false;
						FlxTween.tween(healthBar, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 3, {ease: FlxEase.linear});
				}
			case 'rebound':
					switch (curStep) {
						case 256:
							if (ClientPrefs.flashing) {
							addShaderToCamera('camHUD', new ChromaticAberrationEffect(0.01));
							}
							FlxTween.tween(songinfonew, {y: -500}, 1, {ease: FlxEase.linear});
							FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(scoreTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(oriHPBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						case 408 | 664 | 767 | 863 | 991 | 1280 | 1376 | 1560 | 1816 | 1920 | 2016 | 2144:
							shakeCam = true;
						case 416 | 671 | 799 | 927 | 1023 | 1312 | 1408 | 1568 | 1826 | 1952 | 2080:
							shakeCam = false;
						case 2176:
							shakeCam = false;
							FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							for (i in opponentStrums) {
								FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							}
							for (i in playerStrums) {
								FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							}
					}
				case 'lacuna':
					switch (curStep) {
						case 380 | 1392:
							shakeCam = true;
							fuckyoumodchart = true;
						case 885 | 1900:
							shakeCam = false;
							fuckyoumodchart = false;
						case 2279:
							FlxTween.tween(healthBar, {alpha: 0}, 10, {ease: FlxEase.linear});
							FlxTween.tween(oriHPBG, {alpha: 0}, 10, {ease: FlxEase.linear});
							FlxTween.tween(healthBarBG, {alpha: 0}, 10, {ease: FlxEase.linear});
							FlxTween.tween(iconP1, {alpha: 0}, 10, {ease: FlxEase.linear});
							FlxTween.tween(iconP2, {alpha: 0}, 10, {ease: FlxEase.linear});
							FlxTween.tween(leTxt, {alpha: 0}, 10, {ease: FlxEase.linear});
							for (i in opponentStrums) {
								FlxTween.tween(i, {alpha: 0}, 10, {ease: FlxEase.linear});
							}
							for (i in playerStrums) {
								FlxTween.tween(i, {alpha: 0}, 10, {ease: FlxEase.linear});
							}
					}
			case 'light-legacy':
				switch (curStep) {
					case 1:
						FlxTween.tween(healthBar, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 1, {ease: FlxEase.linear});
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
						}
				}
			case 'defeat':
				switch (curStep) {
					case 12:
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0.2}, 1, {ease: FlxEase.linear});
						}	
				}
			case 'final-boss-chan':
				switch (curStep) {
					case 8:
						FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
						}
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
						}
					case 32:
						FlxTween.tween(healthBar, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 1}, 1, {ease: FlxEase.linear});
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.linear});
						}
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.linear});
						}
					case 3679:
						bopslol = 2;
					case 4128:
						bopslol = 4;
					case 4383:
						healyou = false;
						FlxTween.tween(healthBar, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 1, {ease: FlxEase.linear});
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
						}
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
						}
				}
			case 'firestarter':
				switch (curStep) {
					case 18:
						FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
					case 1618:
						healyou = false;
						FlxTween.tween(healthBar, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 1, {ease: FlxEase.linear});
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
						}
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
						}
				}
			case 'upheaval':
				switch (curStep) {
					case 1:
						healyou = false;
						FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						}
					case 32:
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						}
					case 64:
						health = 2;
						FlxTween.tween(scoreTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 1}, 0.01, {ease: FlxEase.linear});
					case 96:
						FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
					case 128:
						FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
					case 160:
						healyou = true;
						FlxTween.tween(songinfonew, {y: -500}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
					}
			case 'main-theme':
				switch (curStep) {
					case 2:
						FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						}
					case 32:
						FlxTween.tween(healthBar, {alpha: 1}, 2.5, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 1}, 2.5, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 1}, 2.5, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 1}, 2.5, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 1}, 2.5, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 1}, 2.5, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 1}, 2.5, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 1}, 2.5, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 1}, 2.5, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 1}, 2.5, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 1}, 2.5, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 1}, 2.5, {ease: FlxEase.linear});
						}
					case 620:
						healyou = false;
						FlxTween.tween(healthBar, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 0}, 8, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 8, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 8, {ease: FlxEase.linear});
						}
				}
				case 'shattered':
				switch (curStep) {
					case 4:
						healyou = false;
						FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						}
					case 119:
						healyou = true;
						FlxTween.tween(healthBar, {alpha: 1}, 2, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 1}, 2, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 1}, 2, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 1}, 2, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 1}, 2, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 1}, 2, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 1}, 2, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 1}, 2, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 1}, 2, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 1}, 2, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 1}, 2, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 1}, 2, {ease: FlxEase.linear});
						}
					case 1663:
						FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0.2}, 1, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0.2}, 1, {ease: FlxEase.linear});
						}
					case 1670:
						health = 1;
					case 1791:
						FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.linear});
						}
					case 2559:
						healyou = false;
						FlxTween.tween(healthBar, {alpha: 0}, 4, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 4, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 4, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 0}, 4, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 4, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 4, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 4, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 0}, 4, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 0}, 4, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 0}, 4, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 4, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 4, {ease: FlxEase.linear});
						}
				}
				case 'spek':
				switch (curStep) {
					case 4:
						FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						}
					case 80:
						health = 2;
						FlxTween.tween(healthBar, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 1}, 1, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.linear});
						}
					case 480:
						healyou = false;
						FlxTween.tween(healthBar, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 0}, 3, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 0}, 3, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 3, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 3, {ease: FlxEase.linear});
						}
				}
			case 'deformation':
				switch (curStep) {
					case 4:
						FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						}
					case 512:
						health = 1;
						FlxTween.tween(songinfonew, {y: -500}, 1, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
						}
					case 1792:
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						}
					case 2048:
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
						}
					case 3328:
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						}
					case 3840:
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
						}
					case 4896:
						healyou = false;
						FlxTween.tween(healthBar, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(oriHPBG, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(leTxt, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(songWatermark, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(engineVerwatermark, {alpha: 0}, 8, {ease: FlxEase.linear});
						FlxTween.tween(judgementCounter, {alpha: 0}, 8, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 8, {ease: FlxEase.linear});
						}
						for (i in opponentStrums) {
							FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
						}
				}
				case 'haqualaku':
					switch (curStep) {
						case 3:
							FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(scoreTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(songWatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(engineVerwatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(judgementCounter, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							for (i in playerStrums) {
								FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							}
							for (i in opponentStrums) {
								FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							}
						case 69:
							FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(oriHPBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(scoreTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(leTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(songWatermark, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(engineVerwatermark, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(judgementCounter, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							for (i in playerStrums) {
								FlxTween.tween(i, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							}
							for (i in opponentStrums) {
								FlxTween.tween(i, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							}
						case 511:
							healyou = false;
							FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(scoreTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(songWatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(engineVerwatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							FlxTween.tween(judgementCounter, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							for (i in playerStrums) {
								FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							}
							for (i in opponentStrums) {
								FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							}
					}
				case 'well':
					switch (curStep) {
						case 20:
							FlxG.sound.play(Paths.sound('vineboom'), 1);
							strumLineNotes.forEach(function(note)
								{
									quickSpin(note);
								});
						case 84:
							FlxG.sound.play(Paths.sound('vineboom'), 1);
						case 416 | 928:
							FlxG.sound.play(Paths.sound('vineboom'), 0.5);
						case 936:
							FlxG.sound.play(Paths.sound('vineboom'), 1);
						case 944 | 1584:
							strumLineNotes.forEach(function(note)
								{
									quickSpin(note);
								});
					}
			}

		lastStepHit = curStep;
		setOnLuas('curStep', curStep);
		callOnLuas('onStepHit', []);
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var lastBeatHit:Int = -1;
	
	
	
	
	override function beatHit()
	{
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			//trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}

		if (dad.curCharacter == 'kuro' && Paths.formatToSongPath(SONG.song) == 'fleeing') {
			if (health >= 0.05 + (0.01 * songMisses)) {
			if (curBeat % 1 == 0)
			health -= 0.01 + (0.01 * songMisses);
		}
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

	//	if (Paths.formatToSongPath(SONG.song) == 'rtl-old-chart' || Paths.formatToSongPath(SONG.song) == 'spirit-tree-old-chart' || Paths.formatToSongPath(SONG.song) == 'decay-old-chart' || Paths.formatToSongPath(SONG.song) == 'shriek-and-ori' || Paths.formatToSongPath(SONG.song) == 'fatality') {
		if (ClientPrefs.iconbop) {

		var funnylol:Float = (healthBar.percent * 0.01) + 0.01;
		
	/*	if (Paths.formatToSongPath(SONG.song) == 'final-boss-chan') { // just so it reduces the icon bop and doesn't appear broken with the high bpm song
		if (curBeat % 2 == 0) {
			iconP1.scale.set(1 + (0.2 * funnylol), 1 + (0.2 * funnylol));
			iconP2.scale.set(1 + (0.2 * funnylol), 1 + (0.2 * funnylol));	
		}
		}
		else {
		iconP1.scale.set(1 + (0.2 * funnylol), 1 + (0.2 * funnylol));
		iconP2.scale.set(1 + (0.2 * funnylol), 1 + (0.2 * funnylol));
		}*/

		if (curBeat % bopslol == 0) {
			FlxTween.angle(iconP1, -30, 0, Conductor.crochet / 1500 * gfSpeed, {ease: FlxEase.quadOut});
			FlxTween.angle(iconP2, 30, 0, Conductor.crochet / 1500 * gfSpeed, {ease: FlxEase.quadOut});
		}
		
		if (Paths.formatToSongPath(SONG.song) == 'spek') {
			switch (curBeat) {
				case 4:
					bopslol = 1;
				case 112:
					bopslol = 4;
			}
		}
		

		tweenIcons();
		}

		if (ClientPrefs.animatedicons) {
			if (healthBar.percent < 20)
				iconP1.animation.play(iconP1.charPublic + " lose", true);
			else
				iconP1.animation.play(iconP1.charPublic, true);

		if (healthBar.percent > 80)
			iconP2.animation.play(iconP2.charPublic + " lose", true);
		else
			iconP2.animation.play(iconP2.charPublic, true);

		if (healthBar.percent > 80)			
			iconP1.animation.play(iconP1.charPublic + " win", true);

		if (healthBar.percent < 20)
			iconP2.animation.play(iconP2.charPublic + " win", true);
		}

		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		introAssets.set('default', ['ready', 'set', 'go']);
		introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

		var introAlts:Array<String> = introAssets.get('default');
		var antialias:Bool = ClientPrefs.globalAntialiasing;
		var credits:String;
		if(isPixelStage) {
			introAlts = introAssets.get('pixel');
			antialias = false;
		}
		switch (Paths.formatToSongPath(SONG.song)) {
				case 'spirit-tree':
					switch (curBeat) {
						case 1:
							FlxTween.tween(healthBar, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(oriHPBG, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(healthBarBG, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(scoreTxt, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(iconP1, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(iconP2, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(leTxt, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(songWatermark, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(engineVerwatermark, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(judgementCounter, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							for (i in playerStrums) {
								FlxTween.tween(i, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							}
							for (i in opponentStrums) {
								FlxTween.tween(i, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							}
						case 20:
							FlxTween.tween(healthBar, {alpha: 1}, 3, {ease: FlxEase.linear});
							FlxTween.tween(oriHPBG, {alpha: 1}, 3, {ease: FlxEase.linear});
							FlxTween.tween(healthBarBG, {alpha: 1}, 3, {ease: FlxEase.linear});
							FlxTween.tween(scoreTxt, {alpha: 1}, 3, {ease: FlxEase.linear});
							FlxTween.tween(iconP1, {alpha: 1}, 3, {ease: FlxEase.linear});
							FlxTween.tween(iconP2, {alpha: 1}, 3, {ease: FlxEase.linear});
							FlxTween.tween(leTxt, {alpha: 1}, 3, {ease: FlxEase.linear});
							FlxTween.tween(songWatermark, {alpha: 1}, 3, {ease: FlxEase.linear});
							FlxTween.tween(engineVerwatermark, {alpha: 1}, 3, {ease: FlxEase.linear});
							FlxTween.tween(judgementCounter, {alpha: 1}, 3, {ease: FlxEase.linear});
							for (i in playerStrums) {
								FlxTween.tween(i, {alpha: 1}, 3, {ease: FlxEase.linear});
							}
							for (i in opponentStrums) {
								FlxTween.tween(i, {alpha: 1}, 3, {ease: FlxEase.linear});
							}
						case 28:
							FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
						case 29:
							countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
							countdownReady.scrollFactor.set();
							countdownReady.updateHitbox();
		
							if (PlayState.isPixelStage)
								countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));
		
							countdownReady.screenCenter();
							countdownReady.antialiasing = antialias;
							add(countdownReady);
							FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									remove(countdownReady);
									countdownReady.destroy();
								}
							});
							FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
						case 30: 
							countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
							countdownSet.scrollFactor.set();
		
							if (PlayState.isPixelStage)
								countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));
		
							countdownSet.screenCenter();
							countdownSet.antialiasing = antialias;
							add(countdownSet);
							FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									remove(countdownSet);
									countdownSet.destroy();
								}
							});
							FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
						case 31: 
							countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
							countdownGo.scrollFactor.set();
		
							if (PlayState.isPixelStage)
								countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));
		
							countdownGo.updateHitbox();
		
							countdownGo.screenCenter();
							countdownGo.antialiasing = antialias;
							add(countdownGo);
							FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									remove(countdownGo);
									countdownGo.destroy();
								}
							});
							FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
							strumLineNotes.forEach(function(note)
								{
									quickSpin(note);
								});
							FlxTween.tween(songinfonew, {y: -500}, 1, {ease: FlxEase.linear});
						case 160:
							FlxTween.tween(healthBar, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(oriHPBG, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(healthBarBG, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(scoreTxt, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(iconP1, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(iconP2, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(leTxt, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(songWatermark, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(engineVerwatermark, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							FlxTween.tween(judgementCounter, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							for (i in playerStrums) {
								FlxTween.tween(i, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							}
							for (i in opponentStrums) {
								FlxTween.tween(i, {alpha: 0}, 0.5, {ease: FlxEase.linear});
							}
							healyou = false;
					}
					case 'reality-breaking69':
						switch (curBeat) {
							case 2:
								FlxTween.tween(healthBar, {alpha: 0}, 1, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 0}, 1, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 0}, 1, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 0}, 1, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.linear});
								for (i in playerStrums) {
									FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
								}
								for (i in opponentStrums) {
									FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
								}
							case 64:
								for (i in playerStrums) {
									FlxTween.tween(i, {alpha: 1}, 5, {ease: FlxEase.linear});
								}
								for (i in opponentStrums) {
									FlxTween.tween(i, {alpha: 1}, 5, {ease: FlxEase.linear});
								}
							case 124:
								FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
								FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							case 125:
								countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
								countdownReady.scrollFactor.set();
								countdownReady.updateHitbox();
		
								if (PlayState.isPixelStage)
									countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));
		
								countdownReady.screenCenter();
								countdownReady.antialiasing = antialias;
								add(countdownReady);
								FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownReady);
										countdownReady.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
								FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							case 126: 
								countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
								countdownSet.scrollFactor.set();
		
								if (PlayState.isPixelStage)
									countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));
		
								countdownSet.screenCenter();
								countdownSet.antialiasing = antialias;
								add(countdownSet);
								FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownSet);
										countdownSet.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
								FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							case 127: 
								countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
								countdownGo.scrollFactor.set();
		
								if (PlayState.isPixelStage)
									countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));
		
								countdownGo.updateHitbox();
		
								countdownGo.screenCenter();
								countdownGo.antialiasing = antialias;
								add(countdownGo);
								FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownGo);
										countdownGo.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
								strumLineNotes.forEach(function(note)
									{
										quickSpin(note);
									});
								FlxTween.tween(songinfonew, {y: -500}, 1, {ease: FlxEase.linear});
								FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							case 128:
							//	if (storyDifficulty != 1) {
								FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							//	FlxTween.tween(songWatermark, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							//	}
								FlxTween.tween(scoreTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								for (i in opponentStrums) {
									FlxTween.tween(i, {alpha: 0.6}, 0.2, {ease: FlxEase.linear});
								}
							case 256:
								shakeCam = true;
							case 384:
								shakeCam = false;
							case 512:
								shakeCam = true;
							case 640:
								shakeCam = false;
						}
					case 'starbucks':
						switch (curBeat) {
							case 2:
								FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								for (i in opponentStrums) {
									FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								}
						}
					case 'restoring-the-light-classic':
						switch (curBeat) {
							case 20:
								FlxTween.tween(healthBar, {alpha: 1}, 1, {ease: FlxEase.linear});
								FlxTween.tween(oriHPBG, {alpha: 1}, 1, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 1}, 1, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 1}, 1, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 1}, 1, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 1}, 1, {ease: FlxEase.linear});
								FlxTween.tween(leTxt, {alpha: 1}, 1, {ease: FlxEase.linear});
								FlxTween.tween(songWatermark, {alpha: 1}, 1, {ease: FlxEase.linear});
								FlxTween.tween(engineVerwatermark, {alpha: 1}, 1, {ease: FlxEase.linear});
								FlxTween.tween(judgementCounter, {alpha: 1}, 1, {ease: FlxEase.linear});
								for (i in playerStrums) {
									FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.linear});
								}
								for (i in opponentStrums) {
									FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.linear});
								}
							case 28:
								FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
							case 29:
								countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
								countdownReady.scrollFactor.set();
								countdownReady.updateHitbox();
		
								if (PlayState.isPixelStage)
									countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));
		
								countdownReady.screenCenter();
								countdownReady.antialiasing = antialias;
								add(countdownReady);
								FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownReady);
										countdownReady.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
							case 30: 
								countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
								countdownSet.scrollFactor.set();
		
								if (PlayState.isPixelStage)
									countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));
		
								countdownSet.screenCenter();
								countdownSet.antialiasing = antialias;
								add(countdownSet);
								FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownSet);
										countdownSet.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
							case 31: 
								countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
								countdownGo.scrollFactor.set();
		
								if (PlayState.isPixelStage)
									countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));
		
								countdownGo.updateHitbox();
		
								countdownGo.screenCenter();
								countdownGo.antialiasing = antialias;
								add(countdownGo);
								FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownGo);
										countdownGo.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
								strumLineNotes.forEach(function(note)
									{
										quickSpin(note);
									});
								FlxTween.tween(songinfonew, {y: -500}, 1, {ease: FlxEase.linear});
						}
					case 'reality-breaking':
						switch (curBeat) {
							case 2:
								FlxTween.tween(healthBar, {alpha: 0}, 1, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 0}, 1, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 0}, 1, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 0}, 1, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.linear});
								FlxTween.tween(oriHPBG, {alpha: 0}, 1, {ease: FlxEase.linear});
								for (i in playerStrums) {
									FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
								}
								for (i in opponentStrums) {
									FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
								}
							case 64:
								for (i in playerStrums) {
									FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.linear});
								}
								for (i in opponentStrums) {
									FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.linear});
								}
							case 124 | 126:
								FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(oriHPBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							case 125 | 127:
								FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							case 256 | 512:
								shakeCam = true;
								FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
							case 384:
								shakeCam = false;
								FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(oriHPBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
							case 128:
								FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(oriHPBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
								if (ClientPrefs.flashing)
								addShaderToCamera('camHUD', new ChromaticAberrationEffect(0.01));
								strumLineNotes.forEach(function(note)
									{
										quickSpin(note);
									});
								FlxTween.tween(songinfonew, {y: -500}, 1, {ease: FlxEase.linear});
							case 640:
								for (i in opponentStrums) {
									FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
								}
							case 703:
								for (i in playerStrums) {
									FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
								}
						}
						case 'upheaval-old':
							switch (curBeat) {
								case 2:
									FlxTween.tween(healthBar, {alpha: 0}, 1, {ease: FlxEase.linear});
									FlxTween.tween(healthBarBG, {alpha: 0}, 1, {ease: FlxEase.linear});
									FlxTween.tween(scoreTxt, {alpha: 0}, 1, {ease: FlxEase.linear});
									FlxTween.tween(iconP1, {alpha: 0}, 1, {ease: FlxEase.linear});
									FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.linear});
									for (i in playerStrums) {
										FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
									}
									for (i in opponentStrums) {
										FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
									}
								case 32:
									health = 2;
									FlxTween.tween(scoreTxt, {alpha: 1}, 3, {ease: FlxEase.linear});
									for (i in playerStrums) {
										FlxTween.tween(i, {alpha: 1}, 3, {ease: FlxEase.linear});
									}
									for (i in opponentStrums) {
										FlxTween.tween(i, {alpha: 1}, 3, {ease: FlxEase.linear});
									}
								case 48:
									FlxTween.tween(healthBar, {alpha: 1}, 3, {ease: FlxEase.linear});
									FlxTween.tween(healthBarBG, {alpha: 1}, 3, {ease: FlxEase.linear});
								case 64:
									FlxTween.tween(iconP1, {alpha: 1}, 3, {ease: FlxEase.linear});
								case 72:
									FlxTween.tween(iconP2, {alpha: 1}, 3, {ease: FlxEase.linear});
							}
				/*	case 'shriek-and-ori':
						switch (curBeat) {
							case 3:
								for (i in opponentStrums) {
									FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								}
								FlxTween.tween(healthBar, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(oriHPBG, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(leTxt, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
							case 160:
								for (i in playerStrums) {
									FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
								}
							case 220:
								for (i in playerStrums) {
									FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.linear});
								}
							case 921:
								credits = 'Ok, what the fuck finn';
							case 1054:
								for (i in playerStrums) {
									FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								}
								FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(songWatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(engineVerwatermark, {alpha: 0}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(judgementCounter, {alpha: 0}, 0.01, {ease: FlxEase.linear});	
						}*/
				/*	case 'practice':
						switch (curBeat) {
							case 1:
								for (i in opponentStrums) {
									FlxTween.tween(i, {alpha: 0}, 0.1, {ease: FlxEase.linear});
								}
								FlxTween.tween(healthBar, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(oriHPBG, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
								FlxTween.tween(leTxt, {alpha: 0.15}, 0.01, {ease: FlxEase.linear});
						}*/
					case 'restoring-the-light':
						switch (curBeat) {
							case 5:
								for (i in playerStrums) {
									FlxTween.tween(i, {alpha: 0}, 0.3, {ease: FlxEase.linear});
								}
								for (i in opponentStrums) {
									FlxTween.tween(i, {alpha: 0}, 0.3, {ease: FlxEase.linear});
								}
							case 1:
								FlxTween.tween(healthBar, {alpha: 0.3}, 0.5, {ease: FlxEase.linear});
								FlxTween.tween(oriHPBG, {alpha: 0.3}, 0.5, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 0.3}, 0.5, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 1}, 1, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 0.3}, 0.5, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 0.3}, 0.5, {ease: FlxEase.linear});
								FlxTween.tween(leTxt, {alpha: 0.3}, 0.5, {ease: FlxEase.linear});
							//	FlxTween.tween(songWatermark, {alpha: 1}, 1, {ease: FlxEase.linear});
							case 28:
								FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
								for (i in playerStrums) {
									FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.linear});
								}
								for (i in opponentStrums) {
									FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.linear});
								}
							case 29:
								countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
								countdownReady.scrollFactor.set();
								countdownReady.updateHitbox();
		
								if (PlayState.isPixelStage)
									countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));
		
								countdownReady.screenCenter();
								countdownReady.antialiasing = antialias;
								add(countdownReady);
								FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownReady);
										countdownReady.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
							case 30: 
								countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
								countdownSet.scrollFactor.set();
		
								if (PlayState.isPixelStage)
									countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));
		
								countdownSet.screenCenter();
								countdownSet.antialiasing = antialias;
								add(countdownSet);
								FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownSet);
										countdownSet.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
							case 31: 
								countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
								countdownGo.scrollFactor.set();
		
								if (PlayState.isPixelStage)
									countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));
		
								countdownGo.updateHitbox();
		
								countdownGo.screenCenter();
								countdownGo.antialiasing = antialias;
								add(countdownGo);
								FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownGo);
										countdownGo.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
								strumLineNotes.forEach(function(note)
									{
										quickSpin(note);
									});
								FlxTween.tween(mechtut, {alpha: 0}, 3, {ease: FlxEase.linear});
								FlxTween.tween(songinfonew, {y: -500}, 1, {ease: FlxEase.linear});
							case 64 | 80 | 114 | 144 | 176 | 208 | 240 | 272 | 288 | 320 | 352 | 384:
								if (ClientPrefs.modcharts) {
								strumLineNotes.forEach(function(note)
									{
										quickSpin(note);
									});
								}
							case 416:
								strumLineNotes.forEach(function(note)
									{
										quickSpin(note);
									});
									// so many quick spins aaa
								FlxTween.tween(healthBar, {alpha: 0}, 5, {ease: FlxEase.linear});
								FlxTween.tween(oriHPBG, {alpha: 0}, 5, {ease: FlxEase.linear});
								FlxTween.tween(healthBarBG, {alpha: 0}, 5, {ease: FlxEase.linear});
								FlxTween.tween(scoreTxt, {alpha: 0}, 5, {ease: FlxEase.linear});
								FlxTween.tween(iconP1, {alpha: 0}, 5, {ease: FlxEase.linear});
								FlxTween.tween(iconP2, {alpha: 0}, 5, {ease: FlxEase.linear});
								FlxTween.tween(leTxt, {alpha: 0}, 5, {ease: FlxEase.linear});
								FlxTween.tween(songWatermark, {alpha: 0}, 5, {ease: FlxEase.linear});
								FlxTween.tween(engineVerwatermark, {alpha: 0}, 5, {ease: FlxEase.linear});
								FlxTween.tween(judgementCounter, {alpha: 0}, 5, {ease: FlxEase.linear});
								for (i in playerStrums) {
									FlxTween.tween(i, {alpha: 0}, 5, {ease: FlxEase.linear});
								}
								for (i in opponentStrums) {
									FlxTween.tween(i, {alpha: 0}, 5, {ease: FlxEase.linear});
								}
								healyou = false;
							case 417:
								health = 0.001;
						}
						case 'corrupurgation':
							switch (curBeat) {
								case 10:
								//	if (storyDifficulty == 1) {
								//		FlxTween.tween(healthBar, {alpha: 0}, 1, {ease: FlxEase.linear});
								//		FlxTween.tween(oriHPBG, {alpha: 0}, 1, {ease: FlxEase.linear});
								//		FlxTween.tween(healthBarBG, {alpha: 0}, 1, {ease: FlxEase.linear});
								//		FlxTween.tween(iconP1, {alpha: 0}, 1, {ease: FlxEase.linear});
								//		FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.linear});
								//		FlxTween.tween(leTxt, {alpha: 1}, 1, {ease: FlxEase.linear});
								//		}
								case 12:
									FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
								case 13:
									countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
									countdownReady.scrollFactor.set();
									countdownReady.updateHitbox();
			
									if (PlayState.isPixelStage)
										countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));
			
									countdownReady.screenCenter();
									countdownReady.antialiasing = antialias;
									add(countdownReady);
									FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
										ease: FlxEase.cubeInOut,
										onComplete: function(twn:FlxTween)
										{
											remove(countdownReady);
											countdownReady.destroy();
										}
									});
									FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
								case 14: 
									countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
									countdownSet.scrollFactor.set();
			
									if (PlayState.isPixelStage)
										countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));
			
									countdownSet.screenCenter();
									countdownSet.antialiasing = antialias;
									add(countdownSet);
									FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
										ease: FlxEase.cubeInOut,
										onComplete: function(twn:FlxTween)
										{
											remove(countdownSet);
											countdownSet.destroy();
										}
									});
									FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
								case 15: 
									countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
									countdownGo.scrollFactor.set();
			
									if (PlayState.isPixelStage)
										countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));
			
									countdownGo.updateHitbox();
			
									countdownGo.screenCenter();
									countdownGo.antialiasing = antialias;
									add(countdownGo);
									FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
										ease: FlxEase.cubeInOut,
										onComplete: function(twn:FlxTween)
										{
											remove(countdownGo);
											countdownGo.destroy();
										}
									});
									FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
									FlxTween.tween(songinfonew, {y: -500}, 1, {ease: FlxEase.linear});
								//	if (storyDifficulty == 0) {
										FlxTween.tween(healthBar, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(oriHPBG, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(healthBarBG, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(scoreTxt, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(iconP1, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(iconP2, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(leTxt, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(songWatermark, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(engineVerwatermark, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(judgementCounter, {alpha: 1}, 0.25, {ease: FlxEase.linear});
									//	FlxTween.tween(songWatermark, {alpha: 1}, 0.5, {ease: FlxEase.linear});
								//	}
									strumLineNotes.forEach(function(note)
										{
											quickSpin(note);
										});
								case 728:
									health = 0.001; // ori fucking dies
							}
						case 'think':
							switch (curBeat) {
								case 10:
									if (CoolUtil.difficultyString() == 'BRUTAL') {
										for (i in playerStrums) {
											FlxTween.tween(i, {alpha: 0}, 0.3, {ease: FlxEase.linear});
										}
										for (i in opponentStrums) {
											FlxTween.tween(i, {alpha: 0}, 0.3, {ease: FlxEase.linear});
										}
									}
								case 44:
									FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
									noteWarning();
								case 45:
									countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
									countdownReady.scrollFactor.set();
									countdownReady.updateHitbox();
			
									if (PlayState.isPixelStage)
										countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));
			
									countdownReady.screenCenter();
									countdownReady.antialiasing = antialias;
									add(countdownReady);
									FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
										ease: FlxEase.cubeInOut,
										onComplete: function(twn:FlxTween)
										{
											remove(countdownReady);
											countdownReady.destroy();
										}
									});
									FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
								case 46: 
									countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
									countdownSet.scrollFactor.set();
			
									if (PlayState.isPixelStage)
										countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));
			
									countdownSet.screenCenter();
									countdownSet.antialiasing = antialias;
									add(countdownSet);
									FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
										ease: FlxEase.cubeInOut,
										onComplete: function(twn:FlxTween)
										{
											remove(countdownSet);
											countdownSet.destroy();
										}
									});
									FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
								case 47: 
									countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
									countdownGo.scrollFactor.set();
			
									if (PlayState.isPixelStage)
										countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));
			
									countdownGo.updateHitbox();
			
									countdownGo.screenCenter();
									countdownGo.antialiasing = antialias;
									add(countdownGo);
									FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
										ease: FlxEase.cubeInOut,
										onComplete: function(twn:FlxTween)
										{
											remove(countdownGo);
											countdownGo.destroy();
										}
									});
									FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
									FlxTween.tween(songinfonew, {y: -500}, 1, {ease: FlxEase.linear});
									if (storyDifficulty == 0) {
										FlxTween.tween(healthBar, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(oriHPBG, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(healthBarBG, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(scoreTxt, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(iconP1, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(iconP2, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										FlxTween.tween(leTxt, {alpha: 1}, 0.25, {ease: FlxEase.linear});
									//	FlxTween.tween(songWatermark, {alpha: 1}, 0.5, {ease: FlxEase.linear});
									}
									strumLineNotes.forEach(function(note)
										{
											quickSpin(note);
										});
							}
							case 'wireframe':
								switch (curBeat) {
									case 28:
										FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
									case 29:
										countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
										countdownReady.scrollFactor.set();
										countdownReady.updateHitbox();
				
										if (PlayState.isPixelStage)
											countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));
				
										countdownReady.screenCenter();
										countdownReady.antialiasing = antialias;
										add(countdownReady);
										FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
											ease: FlxEase.cubeInOut,
											onComplete: function(twn:FlxTween)
											{
												remove(countdownReady);
												countdownReady.destroy();
											}
										});
										FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
									case 30: 
										countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
										countdownSet.scrollFactor.set();
				
										if (PlayState.isPixelStage)
											countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));
				
										countdownSet.screenCenter();
										countdownSet.antialiasing = antialias;
										add(countdownSet);
										FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
											ease: FlxEase.cubeInOut,
											onComplete: function(twn:FlxTween)
											{
												remove(countdownSet);
												countdownSet.destroy();
											}
										});
										FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
									case 31: 
										countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
										countdownGo.scrollFactor.set();
				
										if (PlayState.isPixelStage)
											countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));
				
										countdownGo.updateHitbox();
				
										countdownGo.screenCenter();
										countdownGo.antialiasing = antialias;
										add(countdownGo);
										FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
											ease: FlxEase.cubeInOut,
											onComplete: function(twn:FlxTween)
											{
												remove(countdownGo);
												countdownGo.destroy();
											}
										});
										FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
										FlxTween.tween(songinfonew, {y: -500}, 1, {ease: FlxEase.linear});
											FlxTween.tween(healthBar, {alpha: 1}, 0.25, {ease: FlxEase.linear});
											FlxTween.tween(healthBarBG, {alpha: 1}, 0.25, {ease: FlxEase.linear});
											FlxTween.tween(scoreTxt, {alpha: 1}, 0.25, {ease: FlxEase.linear});
											FlxTween.tween(iconP1, {alpha: 1}, 0.25, {ease: FlxEase.linear});
											FlxTween.tween(iconP2, {alpha: 1}, 0.25, {ease: FlxEase.linear});
											FlxTween.tween(leTxt, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										strumLineNotes.forEach(function(note)
											{
												quickSpin(note);
											});
									case 256:
										health = 2;
								}
								case 'fast-food':
									switch (curBeat) {
										case 32 | 96 | 160 | 224 | 288 | 320 | 446 | 450 | 456 | 460 | 464 | 468 | 472 | 476 | 480:
											if (ClientPrefs.modcharts) {
												strumLineNotes.forEach(function(note)
													{
														quickSpin(note);
													});
												}
									}
								case 'decay':
									switch (curBeat) {
										case 3: 
												FlxTween.tween(healthBar, {alpha: 1}, 0.25, {ease: FlxEase.linear});
												FlxTween.tween(oriHPBG, {alpha: 1}, 0.25, {ease: FlxEase.linear});
												FlxTween.tween(healthBarBG, {alpha: 1}, 0.25, {ease: FlxEase.linear});
												FlxTween.tween(scoreTxt, {alpha: 1}, 0.25, {ease: FlxEase.linear});
												FlxTween.tween(iconP1, {alpha: 1}, 0.25, {ease: FlxEase.linear});
												FlxTween.tween(iconP2, {alpha: 1}, 0.25, {ease: FlxEase.linear});
												FlxTween.tween(leTxt, {alpha: 1}, 0.25, {ease: FlxEase.linear});
										case 32 | 48 | 64 | 68 | 72 | 76 | 80 | 84 | 88 | 92 | 93 | 94 | 95 | 96 | 100 | 104 | 108 | 109 | 110 | 111 | 112 | 116 | 120 | 124 | 125 | 126 | 127 | 128 | 132 | 136 | 140 | 144 | 148 | 152 | 156 | 157 | 158 | 159 | 160 | 164 | 168 | 172 | 176 | 180 | 184 | 188 | 189 | 190 | 191 | 196 | 200 | 204 | 208 | 212 | 216 | 220 | 228 | 232 | 236 | 244 | 248 | 252 | 320 | 384 | 416 | 624 | 640 | 656:
											if (ClientPrefs.modcharts) {
											strumLineNotes.forEach(function(note)
												{
													quickSpin(note);
												});
											}
										case 192 | 608:
											if (ClientPrefs.modcharts) {
												strumLineNotes.forEach(function(note)
													{
														quickSpin(note);
													});
												}
											FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
										case 256:
											enablepoisonlol = true;
											FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(oriHPBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(leTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
											mechtut.alpha = 1;
											mechtut.y = -1000;
											FlxTween.tween(mechtut, {y: 0}, 1, {ease: FlxEase.expoOut});
											strumLineNotes.forEach(function(note)
												{
													quickSpin(note);
												});
										case 288 | 384 | 480 | 488 | 512 | 544 | 736:
											enablepoisonlol = false;
										case 320 | 416 | 448 | 484 | 504 | 524 | 608:
											enablepoisonlol = true;
										case 280: // just so it last abit longer
											FlxTween.tween(mechtut, {alpha: 0}, 2, {ease: FlxEase.linear});
										case 672:
											if (ClientPrefs.modcharts) {
												strumLineNotes.forEach(function(note)
													{
														quickSpin(note);
													});
												}
											FlxTween.tween(healthBar, {alpha: 1}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(oriHPBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(healthBarBG, {alpha: 1}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(iconP1, {alpha: 1}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(iconP2, {alpha: 1}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(leTxt, {alpha: 1}, 0.01, {ease: FlxEase.linear});
										case 736:
											FlxTween.tween(healthBar, {alpha: 0}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(oriHPBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(healthBarBG, {alpha: 0}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(iconP1, {alpha: 0}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(iconP2, {alpha: 0}, 0.01, {ease: FlxEase.linear});
											FlxTween.tween(leTxt, {alpha: 0}, 0.01, {ease: FlxEase.linear});
											for (i in playerStrums) {
												FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
											}
											for (i in opponentStrums) {
												FlxTween.tween(i, {alpha: 0}, 0.01, {ease: FlxEase.linear});
											}
									}
				}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				//FlxG.log.add('CHANGED BPM!');
				setOnLuas('curBpm', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}
			setOnLuas('mustHitSection', SONG.notes[Math.floor(curStep / 16)].mustHitSection);
			setOnLuas('altAnim', SONG.notes[Math.floor(curStep / 16)].altAnim);
			setOnLuas('gfSection', SONG.notes[Math.floor(curStep / 16)].gfSection);
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !endingSong && !isCameraOnForcedPos)
		{
			moveCameraSection(Std.int(curStep / 16));
		}
		if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		if (curBeat % 4 == 0)
			{
				if(timeTxtTween != null) {
					timeTxtTween.cancel();
				}
				timeTxt.scale.x = 1.1;
				timeTxt.scale.y = 1.1;
				timeTxtTween = FlxTween.tween(timeTxt.scale, {x: 1, y: 1}, 0.2, {
					onComplete: function(twn:FlxTween) {
						timeTxtTween = null;
					}
				});
			}
		if (curBeat % 1 == 0)
			{
				if(fclevelTween != null) {
					fclevelTween.cancel();
				}
				fcLevel.scale.x = 0.5;
				fcLevel.scale.y = 0.5;
				fclevelTween = FlxTween.tween(fcLevel.scale, {x: 0.4, y: 0.4}, 0.2, {
					onComplete: function(twn:FlxTween) {
						fclevelTween = null;
					}
				});
			}
		
	/*	if (curBeat % 2 == 0)
			FlxTween.angle(timeTxt, -15, 0, Conductor.crochet / 900 * gfSpeed, {ease: FlxEase.quadOut});
		else
			FlxTween.angle(timeTxt, 15, 0, Conductor.crochet / 900 * gfSpeed, {ease: FlxEase.quadOut});*/

		if (Paths.formatToSongPath(SONG.song) == 'roundabout' || Paths.formatToSongPath(SONG.song) == 'rtl-piano') {
			if (curBeat % 4 == 0) {
				if (ClientPrefs.modcharts) {
					strumLineNotes.forEach(function(note)
						{
							quickSpin(note);
						});
					}
			}
		}

		if (Paths.formatToSongPath(SONG.song) == 'oh-no' || Paths.formatToSongPath(SONG.song) == 'spek') {
		if (curBeat % 4 == 2)
			flipcamlol = true;
		else if (curBeat % 2 == 0)
			flipcamlol = false;
		}
		if (Paths.formatToSongPath(SONG.song) == 'lacuna') { // yeah, remember THAT song? You're lucky that we didn't make a remix version of that.
			if (curBeat <= 64) {
			if (curBeat % 2 == 0)
				flipcamlol = true;
			else
				flipcamlol = false;
			}
			else {
			if (curBeat % 4 == 2)
				flipcamlol = true;
			else if (curBeat % 2 == 0)
				flipcamlol = false;
			}
		}

		if (gf != null && curBeat % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && !gf.stunned && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
		{
			gf.dance();
		}
		if (curBeat % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
		{
			if (health <= 0.8 && Paths.formatToSongPath(SONG.song) != 'restoring-the-light')
			boyfriend.playAnim('scared', true);
			else
			boyfriend.dance();
		}
		if (curBeat % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
		{
			dad.dance();
		}

		switch (curStage)
		{
			case 'school':
				if(!ClientPrefs.lowQuality) {
					bgGirls.dance();
				}

			case 'mall':
				if(!ClientPrefs.lowQuality) {
					upperBoppers.dance(true);
				}

				if(heyTimer <= 0) bottomBoppers.dance(true);
				santa.dance(true);

			case 'limo':
				if(!ClientPrefs.lowQuality) {
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});
				}

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:BGSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1, [curLight]);

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (curStage == 'spooky' && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
		lastBeatHit = curBeat;

		setOnLuas('curBeat', curBeat); //DAWGG?????
		callOnLuas('onBeatHit', []);
	}

	public var closeLuas:Array<FunkinLua> = [];
	public function callOnLuas(event:String, args:Array<Dynamic>):Dynamic {
		var returnVal:Dynamic = FunkinLua.Function_Continue;
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			var ret:Dynamic = luaArray[i].call(event, args);
			if(ret != FunkinLua.Function_Continue) {
				returnVal = ret;
			}
		}

		for (i in 0...closeLuas.length) {
			luaArray.remove(closeLuas[i]);
			closeLuas[i].stop();
		}
		#end
		return returnVal;
	}

	public function setOnLuas(variable:String, arg:Dynamic) {
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			luaArray[i].set(variable, arg);
		}
		#end
	}

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}
	var fcrank:String;
	public var ratingName:String = '?';
	public var ratingPercent:Float;
	public var ratingFC:String;
	public function RecalculateRating() {
		setOnLuas('score', songScore);
		setOnLuas('misses', songMisses);
		setOnLuas('hits', songHits);

		var ret:Dynamic = callOnLuas('onRecalculateRating', []);
		if(ret != FunkinLua.Function_Stop)
		{
			if(totalPlayed < 1) //Prevent divide by 0
				ratingName = '?';
			else
			{
				// Rating Percent
				ratingPercent = Math.min(1, Math.max(0, totalNotesHit / totalPlayed));
				//trace((totalNotesHit / totalPlayed) + ', Total: ' + totalPlayed + ', notes hit: ' + totalNotesHit);

				// Rating Name
				if(ratingPercent >= 1)
				{
					if (ClientPrefs.newrank)
					ratingName = ratingStuff[ratingStuff.length-1][0]; //Uses last string
					else
					ratingName = ratingStuffOLD[ratingStuffOLD.length-1][0]; //Uses last string
				}
				else
				{
					for (i in 0...ratingStuff.length-1)
					{
						if (ClientPrefs.newrank) {
						if(ratingPercent < ratingStuff[i][1])
						{
							ratingName = ratingStuff[i][0];
							break;
						}
					}
					else {
						if(ratingPercent < ratingStuffOLD[i][1])
							{
								ratingName = ratingStuffOLD[i][0];
								break;
							}
					}
					}
				}
			}

		//	fcLevel = 'fclevel/' + fcrank;
			fcLevel.loadGraphic(Paths.image('fclevel/$fcrank'));

			if (sicks > 0) fcrank = "MFC";
			if (goods > 0) fcrank = "GFC";
			if (bads > 0) fcrank = "FC";
			if (shits > 0) fcrank = "FC-";
			if (songMisses > 0 && songMisses < 10) fcrank = "SDCB";
			if (songMisses >= 10 && songMisses <= 65) fcrank = "Clear";
			if (songMisses >= 65 && songMisses <= 500) fcrank = "Skill Issue";
			else if (songMisses >= 500) fcrank = "What the fuck";

			// Rating FC
			ratingFC = "";
			if (sicks > 0) ratingFC = "MFC";
			if (goods > 0) ratingFC = "GFC";
			if (bads > 0) ratingFC = "FC";
			if (shits > 0) ratingFC = "FC-";
			if (songMisses > 0 && songMisses < 10) ratingFC = "S.D.C.B.";
			if (songMisses >= 10 && songMisses < 65) ratingFC = "Clear";
			if (songMisses >= 65 && songMisses <= 500) ratingFC = "S.I.";
			else if (songMisses >= 500) ratingFC = 'What the fuck?!';
		}
		setOnLuas('rating', ratingPercent);
		setOnLuas('ratingName', ratingName);
		setOnLuas('ratingFC', ratingFC);
		if (songMisses >= 65)
		judgementCounter.text = 'Sicks: ${sicks} (${sickrows})\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\nMisses: ${songMisses} (Skill Issue)\n';
		else
		judgementCounter.text = 'Sicks: ${sicks} (${sickrows})\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\nMisses: ${songMisses}\n';
	}

	#if ACHIEVEMENTS_ALLOWED
	private function checkForAchievement(achievesToCheck:Array<String> = null):String
	{
		if(chartingMode) return null;

		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		for (i in 0...achievesToCheck.length) {
			var achievementName:String = achievesToCheck[i];
			if(!Achievements.isAchievementUnlocked(achievementName) && !cpuControlled) {
				var unlock:Bool = false;
				switch(achievementName)
				{
					case 'Nibel_nomiss' | 'Nibel2_nomiss' | 'Niwen_nomiss' | 'Bonus_nomiss':
						if(isStoryMode && campaignMisses + songMisses < 1 && CoolUtil.difficultyString() == 'STANDERED' && storyPlaylist.length <= 1 && !changedDifficulty && !usedPractice && !ClientPrefs.disabledachievements)
						{
							var weekName:String = WeekData.getWeekFileName();
							switch(weekName) //I know this is a lot of duplicated code, but it's easier readable and you can add weeks with different names than the achievement tag
							{
								case 'nibel':
									if(achievementName == 'Nibel_nomiss') unlock = true;
								case 'kuro':
									if(achievementName == 'Nibel2_nomiss') unlock = true;
								case 'niwen':
									if(achievementName == 'Niwen_nomiss') unlock = true;
								case 'bonus':
									if(achievementName == 'Bonus_nomiss') unlock = true;
							}
						}
					case 'ONELIFE_nomiss':
						if(isStoryMode && campaignMisses + songMisses < 1 && CoolUtil.difficultyString() == 'ONELIFE' && storyPlaylist.length <= 1 && !changedDifficulty && !usedPractice && !ClientPrefs.disabledachievements)
						{
							var weekName:String = WeekData.getWeekFileName();
							switch(weekName) // I know this is the same as above, but it's easier that way. And honestly it's the exact same thing but on One Life.
							{
								case 'preonelife':
									if(achievementName == 'ONELIFE_nomiss') unlock = true;
							}
						}
					case 'NibelOG_nomiss' | 'Nibel2OG_nomiss' | 'NiwenOG_nomiss' | 'BonusOG_nomiss':
						if(isStoryMode && campaignMisses + songMisses < 1 && (CoolUtil.difficultyString() == 'OLDCHART' || CoolUtil.difficultyString() == 'LEGACY') && storyPlaylist.length <= 1 && !changedDifficulty && !usedPractice && !ClientPrefs.disabledachievements)
						{
							var weekName:String = WeekData.getWeekFileName();
							switch(weekName)
							{
								case 'nibel':
									if(achievementName == 'NibelOG_nomiss') unlock = true;
								case 'kuro':
									if(achievementName == 'Nibel2OG_nomiss') unlock = true;
								case 'niwen':
									if(achievementName == 'NiwenOG_nomiss') unlock = true;
								case 'bonus':
									if(achievementName == 'BonusOG_nomiss') unlock = true;
							}
						}
					case 'COR_nomiss' | 'SAO_nomiss' | 'FAT_nomiss':
						if(campaignMisses + songMisses < 1 && storyPlaylist.length <= 1 && !changedDifficulty && !usedPractice && !ClientPrefs.disabledachievements)
						{
						//	var weekName:String = WeekData.getWeekFileName();
							switch(Paths.formatToSongPath(SONG.song))
							{
								case 'shriek-and-ori':
									if(achievementName == 'SAO_nomiss') unlock = true;
								case 'corrupurgation':
									if(achievementName == 'COR_nomiss') unlock = true;
								case 'fatality':
									if(achievementName == 'FAT_nomiss') unlock = true;
							}
						}
					case 'ur_bad':
						if(ratingPercent < 0.2 && !practiceMode && Paths.formatToSongPath(SONG.song) != 'blind-forest' && !ClientPrefs.disabledachievements) {
							unlock = true;
						}
					case 'ur_good':
						if(ratingPercent >= 1 && !usedPractice && !ClientPrefs.disabledachievements) {
							unlock = true;
						}
					case 'ohshit':
						if (Paths.formatToSongPath(SONG.song) == 'blind-forest')
						unlock = true;
					case 'oversinging':
						if(boyfriend.holdTimer >= 10 && !usedPractice && !ClientPrefs.disabledachievements) {
							unlock = true;
						}
					case 'hype':
						if(!boyfriendIdled && !usedPractice && !ClientPrefs.disabledachievements) {
							unlock = true;
						}
					case 'two_keys':
						if(!usedPractice && Paths.formatToSongPath(SONG.song) != 'blind-forest' && !ClientPrefs.disabledachievements) {
							var howManyPresses:Int = 0;
							for (j in 0...keysPressed.length) {
								if(keysPressed[j]) howManyPresses++;
							}

							if(howManyPresses <= 2) {
								unlock = true;
							}
						}
					case 'toastie':
						if(ClientPrefs.framerate <= 60 && ClientPrefs.lowQuality && !ClientPrefs.globalAntialiasing && !ClientPrefs.imagesPersist && !ClientPrefs.disabledachievements) {
							unlock = true;
						}
					case 'debugger':
						if(Paths.formatToSongPath(SONG.song) == 'test' && !usedPractice && !ClientPrefs.disabledachievements) {
							unlock = true;
						}
				}

				if(unlock) {
					Achievements.unlockAchievement(achievementName);
					return achievementName;
				}
			}
		}
		return null;
	}
	#end

	  var curLight:Int = -1;
	var curLightEvent:Int = -1;
}    
		
