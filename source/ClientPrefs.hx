package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

class ClientPrefs {
	public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var showFPS:Bool = true;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var lowQuality:Bool = false;
	public static var framerate:Int = 144;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var camZooms:Bool = true;
	public static var hideHud:Bool = false;
	public static var memorylevel:Bool = false;
	public static var iconsplus:Bool = false;
	public static var orihpbar:Bool = false;
	public static var noteOffset:Int = 0;
	public static var beatslol:Int = 1;
	public static var boplol:Int = 5;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var imagesPersist:Bool = false;
	public static var reducedmovements:Bool = false;
	public static var disabledachievements:Bool = false;
	public static var bigball:Bool = false;
	public static var antimash:Bool = false;
	public static var unlockpurgatory:Bool = true; // forget it
	public static var disablevocals:Bool = false;
	public static var iconbop:Bool = true;
	public static var ghostTapping:Bool = true;
	public static var timeBarType:String = 'Time Left';
	public static var legacyver:String = 'v4.5';
	public static var iconboptype:String = 'OG';
	public static var healthtype:String = 'v3 Classic';
	public static var scoreZoom:Bool = false;
	public static var overridemusiclol:Bool = false;
	public static var tauntability:Bool = true;
	public static var watermarks:Bool = true;
	public static var debugmode:Bool = false;
	public static var sickmode:Bool = false;
	public static var gfcmode:Bool = false;
	public static var hideFCRank:Bool = false;
	public static var fcmode:Bool = false;
	public static var instakill:Bool = false;
	public static var practice:Bool = false;
	public static var botplay:Bool = false;
	public static var newrank:Bool = true;
	public static var modcharts:Bool = true;
	public static var lateDamage:Bool = false;
	public static var mechanicslol:Bool = true;
	public static var animatedicons:Bool = false;
	public static var noReset:Bool = false;
	public static var healthBarAlpha:Float = 1;
	public static var oriBarAlpha:Float = 1;
	public static var controllerMode:Bool = false;
	public static var displayTut:Bool = true;
	public static var screenshakeenabled:Bool = true;
	public static var skipwarnings:Bool = false;
	public static var longhealth:Bool = false;
	public static var hitsoundVolume:Float = 0;
	public static var healthgain:Float = 1;
	public static var healthloss:Float = 1;
	public static var scrollspeed:Float = 1;
	public static var pauseMusic:String = 'Tea Time';
	public static var menuMusic:String = 'Still';
	public static var opponentnotesplashes:Bool = true;
	public static var followarrow:Bool = true;
	public static var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false
	];

	public static var comboOffset:Array<Int> = [0, 0, 0, 0];
	public static var ratingOffset:Int = 0;
	public static var sickWindow:Int = 45;
	public static var goodWindow:Int = 90;
	public static var badWindow:Int = 135;
	public static var safeFrames:Float = 10;

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'note_left'		=> [A, LEFT],
		'note_down'		=> [S, DOWN],
		'note_up'		=> [W, UP],
		'note_right'	=> [D, RIGHT],
		
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_up'			=> [W, UP],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R, NONE],
		
		'volume_mute'	=> [ZERO, NONE],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],

		'tauntkey'		=> [SPACE, NONE],
		'heallmao'		=> [H, NONE],
		
		'debug_1'		=> [SEVEN, NONE],
		'debug_2'		=> [EIGHT, NONE],
		'go_to_options' => [O, NONE]
	//	'gamejoltmenu'  => [G, NONE],
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		//trace(defaultKeys);
	}

	public static function saveSettings() {
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.orihpbar = orihpbar;
		FlxG.save.data.hideFCRank = hideFCRank;
		FlxG.save.data.opponentnotesplashes = opponentnotesplashes;
		FlxG.save.data.screenshakeenabled = screenshakeenabled;
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.tauntability = tauntability;
		FlxG.save.data.newrank = newrank;
		FlxG.save.data.bigball = bigball;
		FlxG.save.data.memorylevel = memorylevel;
		FlxG.save.data.iconbop = iconbop;
		FlxG.save.data.reducedmovements = reducedmovements;
		FlxG.save.data.lateDamage = lateDamage;
		FlxG.save.data.watermarks = watermarks;
		FlxG.save.data.unlockpurgatory = unlockpurgatory;
		FlxG.save.data.healthtype = healthtype;
		FlxG.save.data.iconboptype = iconboptype;
		FlxG.save.data.modcharts = modcharts;
		FlxG.save.data.iconsplus = iconsplus;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.followarrow = followarrow;
		FlxG.save.data.disablevocals = disablevocals;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.framerate = framerate;
		FlxG.save.data.sickmode = sickmode;
		FlxG.save.data.gfcmode = gfcmode;
		FlxG.save.data.fcmode = fcmode;
		FlxG.save.data.healthgain = healthgain;
		FlxG.save.data.antimash = antimash;
		FlxG.save.data.instakill = instakill;
		FlxG.save.data.oriBarAlpha = oriBarAlpha;
		FlxG.save.data.healthloss = healthloss;
		FlxG.save.data.practice = practice;
		FlxG.save.data.botplay = botplay;
		FlxG.save.data.mechanicslol = mechanicslol;
		FlxG.save.data.scrollspeed = scrollspeed;
		FlxG.save.data.overridemusiclol = overridemusiclol;
		FlxG.save.data.disabledachievements = disabledachievements;
		//FlxG.save.data.cursing = cursing;
		//FlxG.save.data.violence = violence;
		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.longhealth = longhealth;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.boplol = boplol;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.beatslol = beatslol;
		FlxG.save.data.imagesPersist = imagesPersist;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.timeBarType = timeBarType;
		FlxG.save.data.scoreZoom = scoreZoom;
		FlxG.save.data.skipwarnings = skipwarnings;
		FlxG.save.data.animatedicons = animatedicons;
		FlxG.save.data.noReset = noReset;
		FlxG.save.data.menuMusic = menuMusic;
		FlxG.save.data.healthBarAlpha = healthBarAlpha;
		FlxG.save.data.comboOffset = comboOffset;
		FlxG.save.data.achievementsMap = Achievements.achievementsMap;
		FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;

		FlxG.save.data.ratingOffset = ratingOffset;
		FlxG.save.data.sickWindow = sickWindow;
		FlxG.save.data.legacyver = legacyver;
		FlxG.save.data.goodWindow = goodWindow;
		FlxG.save.data.badWindow = badWindow;
		FlxG.save.data.debugmode = debugmode;
		FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.gameplaySettings = gameplaySettings;
		FlxG.save.data.controllerMode = controllerMode;
		FlxG.save.data.hitsoundVolume = hitsoundVolume;
		FlxG.save.data.pauseMusic = pauseMusic;
	
		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'ninjamuffin99'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
		if(FlxG.save.data.downScroll != null) {
			downScroll = FlxG.save.data.downScroll;
		}
		if(FlxG.save.data.middleScroll != null) {
			middleScroll = FlxG.save.data.middleScroll;
		}
		if(FlxG.save.data.hideFCRank != null) {
			hideFCRank = FlxG.save.data.hideFCRank;
		}
		if(FlxG.save.data.orihpbar != null) {
			orihpbar = FlxG.save.data.orihpbar;
		}
		if(FlxG.save.data.disablevocals != null) {
			disablevocals = FlxG.save.data.disablevocals;
		}
		if(FlxG.save.data.iconsplus != null) {
			iconsplus = FlxG.save.data.iconsplus;
		}
		if(FlxG.save.data.oriBarAlpha != null) {
			oriBarAlpha = FlxG.save.data.oriBarAlpha;
		}
		if(FlxG.save.data.disabledachievements != null) {
			disabledachievements = FlxG.save.data.disabledachievements;
		}
		if(FlxG.save.data.opponentnotesplashes != null) {
			opponentnotesplashes = FlxG.save.data.opponentnotesplashes;
		}
		if(FlxG.save.data.reducedmovements != null) {
			reducedmovements = FlxG.save.data.reducedmovements;
		}
		if(FlxG.save.data.screenshakeenabled != null) {
			screenshakeenabled = FlxG.save.data.screenshakeenabled;
		}
		if(FlxG.save.data.overridemusiclol != null) {
			overridemusiclol = FlxG.save.data.overridemusiclol;
		}
		if(FlxG.save.data.followarrow != null) {
			followarrow = FlxG.save.data.followarrow;
		}
		if(FlxG.save.data.longhealth != null) {
			longhealth = FlxG.save.data.longhealth;
		}
		if(FlxG.save.data.healthtype != null) {
			healthtype = FlxG.save.data.healthtype;
		}
		if(FlxG.save.data.skipwarnings != null) {
			skipwarnings = FlxG.save.data.skipwarnings;
		}
		if(FlxG.save.data.unlockpurgatory != null) {
			unlockpurgatory = FlxG.save.data.unlockpurgatory;
		}
		if(FlxG.save.data.newrank != null) {
			newrank = FlxG.save.data.newrank;
		}
		if(FlxG.save.data.bigball != null) {
			bigball = FlxG.save.data.bigball;
		}
		if(FlxG.save.data.debugmode != null) {
			debugmode = FlxG.save.data.debugmode;
		}
		if(FlxG.save.data.showFPS != null) {
			showFPS = FlxG.save.data.showFPS;
			if(Main.fpsVar != null) {
				Main.fpsVar.visible = showFPS;
			}
		}
		if(FlxG.save.data.flashing != null) {
			flashing = FlxG.save.data.flashing;
		}
		if(FlxG.save.data.iconbop != null) {
			iconbop = FlxG.save.data.iconbop;
		}
		if(FlxG.save.data.antimash != null) {
			antimash = FlxG.save.data.antimash;
		}
		if(FlxG.save.data.legacyver != null) {
			legacyver = FlxG.save.data.legacyver;
		}
		if(FlxG.save.data.memorylevel != null) {
			memorylevel = FlxG.save.data.memorylevel;
		}
		if(FlxG.save.data.modcharts != null) {
			modcharts = FlxG.save.data.modcharts;
		}
		if(FlxG.save.data.tauntability != null) {
			tauntability = FlxG.save.data.tauntability;
		}
		if(FlxG.save.data.animatedicons != null) {
			animatedicons = FlxG.save.data.animatedicons;
		}
		if(FlxG.save.data.iconboptype != null) {
			iconboptype = FlxG.save.data.iconboptype;
		}
		if(FlxG.save.data.globalAntialiasing != null) {
			globalAntialiasing = FlxG.save.data.globalAntialiasing;
		}
		if(FlxG.save.data.noteSplashes != null) {
			noteSplashes = FlxG.save.data.noteSplashes;
		}
		if(FlxG.save.data.lowQuality != null) {
			lowQuality = FlxG.save.data.lowQuality;
		}
		if(FlxG.save.data.beatslol != null) {
			beatslol = FlxG.save.data.beatslol;
		}
		if(FlxG.save.data.menuMusic != null) {
			menuMusic = FlxG.save.data.menuMusic;
		}
		if(FlxG.save.data.mechanicslol != null) {
			mechanicslol = FlxG.save.data.mechanicslol;
		}
		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}
		/*if(FlxG.save.data.cursing != null) {
			cursing = FlxG.save.data.cursing;
		}
		if(FlxG.save.data.violence != null) {
			violence = FlxG.save.data.violence;
		}*/
		if(FlxG.save.data.camZooms != null) {
			camZooms = FlxG.save.data.camZooms;
		}
		if(FlxG.save.data.lateDamage != null) {
			lateDamage = FlxG.save.data.lateDamage;
		}
		if(FlxG.save.data.watermarks != null) {
			watermarks = FlxG.save.data.watermarks;
		}
		if(FlxG.save.data.hideHud != null) {
			hideHud = FlxG.save.data.hideHud;
		}
		if(FlxG.save.data.noteOffset != null) {
			noteOffset = FlxG.save.data.noteOffset;
		}
		if(FlxG.save.data.arrowHSV != null) {
			arrowHSV = FlxG.save.data.arrowHSV;
		}
		if(FlxG.save.data.ghostTapping != null) {
			ghostTapping = FlxG.save.data.ghostTapping;
		}
		if(FlxG.save.data.timeBarType != null) {
			timeBarType = FlxG.save.data.timeBarType;
		}
		if(FlxG.save.data.scoreZoom != null) {
			scoreZoom = FlxG.save.data.scoreZoom;
		}
		if(FlxG.save.data.noReset != null) {
			noReset = FlxG.save.data.noReset;
		}
		if(FlxG.save.data.healthBarAlpha != null) {
			healthBarAlpha = FlxG.save.data.healthBarAlpha;
		}
		if(FlxG.save.data.comboOffset != null) {
			comboOffset = FlxG.save.data.comboOffset;
		}
		
		if(FlxG.save.data.ratingOffset != null) {
			ratingOffset = FlxG.save.data.ratingOffset;
		}
		if(FlxG.save.data.sickWindow != null) {
			sickWindow = FlxG.save.data.sickWindow;
		}
		if(FlxG.save.data.goodWindow != null) {
			goodWindow = FlxG.save.data.goodWindow;
		}
		if(FlxG.save.data.badWindow != null) {
			badWindow = FlxG.save.data.badWindow;
		}
		if(FlxG.save.data.safeFrames != null) {
			safeFrames = FlxG.save.data.safeFrames;
		}
		if(FlxG.save.data.controllerMode != null) {
			controllerMode = FlxG.save.data.controllerMode;
		}
		if(FlxG.save.data.hitsoundVolume != null) {
			hitsoundVolume = FlxG.save.data.hitsoundVolume;
		}
		if(FlxG.save.data.pauseMusic != null) {
			pauseMusic = FlxG.save.data.pauseMusic;
		}
		if(FlxG.save.data.boplol != null) {
			boplol = FlxG.save.data.boplol;
		}
		if(FlxG.save.data.sickmode != null) {
			sickmode = FlxG.save.data.sickmode;
		}
		if(FlxG.save.data.gfcmode != null) {
			gfcmode = FlxG.save.data.gfcmode;
		}
		if(FlxG.save.data.fcmode != null) {
			fcmode = FlxG.save.data.fcmode;
		}
		if(FlxG.save.data.instakill != null) {
			instakill = FlxG.save.data.instakill;
		}
		if(FlxG.save.data.healthgain != null) {
			healthgain = FlxG.save.data.healthgain;
		}
		if(FlxG.save.data.healthloss != null) {
			healthloss = FlxG.save.data.healthloss;
		}
		if(FlxG.save.data.practice != null) {
			practice = FlxG.save.data.practice;
		}
		if(FlxG.save.data.botplay != null) {
			botplay = FlxG.save.data.botplay;
		}
		if(FlxG.save.data.scrollspeed != null) {
			scrollspeed = FlxG.save.data.scrollspeed;
		}
		if(FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
			{
				gameplaySettings.set(name, value);
			}
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null)
		{
			FlxG.sound.volume = FlxG.save.data.volume;
		}
		if (FlxG.save.data.mute != null)
		{
			FlxG.sound.muted = FlxG.save.data.mute;
		}

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'ninjamuffin99');
		if(save != null && save.data.customControls != null) {
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls) {
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic {
		return /*PlayState.isStoryMode ? defaultValue : */ (gameplaySettings.exists(name) ? gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}
	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}
