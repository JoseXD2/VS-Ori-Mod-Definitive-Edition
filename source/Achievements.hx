import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class Achievements {
	public static var achievementsStuff:Array<Dynamic> = [ //Name, Description, Achievement save tag, Hidden achievement
		["Freaky on a Friday Night",	"Play on a Friday... Night.",						'friday_night_play',	 true],
		["Full Combo!",					"Beat Nibel with no Misses.",				'Nibel_nomiss',			true],
		["Evilish",						"Beat Trirotation with no Misses.",					'Bonus_nomiss',			true],
	//	["Save the forest",				"Beat Kuro with no Misses.",						'Nibel2_nomiss',		false],
		["No Corruption today",			"Beat Niwen with no Misses.",					'Niwen_nomiss',			true],
		["Supersonic", 					"Beat Blind Forest under 3 hours\n(Because the song is less than 3 hours long)", 'ohshit', true],
		["Orgin",						"Beat The OG Nibel with no Misses.",		'NibelOG_nomiss',		true],
		["Well Well Well",				"Beat The OG Trirotation with no Misses.",		'BonusOG_nomiss',		true],
	//	["Blind Forest",				"Beat The OG Kuro with no Misses.",			'Nibel2OG_nomiss',		true],
		["Offbeat FC",					"Beat The OG Niwen with no Misses.",		'NiwenOG_nomiss',		true],
		["The Completionist",			"Beat All songs on One Life with no Misses.",		'ONELIFE_nomiss',		true],
		["Pre-Alpha Spirit",			"Beat Shriek and Ori with no Misses.",				'SAO_nomiss',		true],
		["Death?",						"Beat Corrupurgation with no Misses.",		'COR_nomiss',		true],
	//	["Death?",						"Beat Defeat with no Misses.",		'DEF_nomiss',		true],
		["Not Powerful enough",			"Beat Fatality with no Misses.",		'FAT_nomiss',		true],
	//	["Why don\'t you stay a bit longer?",	"Leave Ori behind and never play the song lol",		'fuck',				 true],
	//	["Go play Tutorial lmao",		"Were you trying to get this?",					'faillol',								false],
		["What a Funkin' Disaster!",	"Complete a Song with a rating lower than 20%.",	'ur_bad',							false],
		["Perfectionist",				"Complete a Song with a rating of 100%.",			'ur_good',							false],
		["Oversinging Much...?",		"Hold down a note for 10 seconds.",					'oversinging',						false],
		["Hyperactive",					"Finish a Song without going Idle.",				'hype',								false],
		["Just the Two of Us",			"Finish a Song pressing only two keys.",			'two_keys',							false],
		["Toaster Gamer",				"Have you tried to run the game on a toaster?",		'toastie',							false],
		["Debugger",					"Beat the \"Test\" Stage from the Chart Editor.\nEven though you could play in Freeplay lmao",	'debugger',				 true],
	//	["Just like Finn",				"You know what to do",								'immortal',							false]
	];
	public static var achievementsMap:Map<String, Bool> = new Map<String, Bool>();

	public static var henchmenDeath:Int = 0;
	public static function unlockAchievement(name:String):Void {
		FlxG.log.add('Completed achievement "' + name +'"');
		achievementsMap.set(name, true);
		FlxG.sound.play(Paths.sound('unlock_achievement'), 0.7);
	}

	public static function isAchievementUnlocked(name:String) {
		if(achievementsMap.exists(name) && achievementsMap.get(name)) {
			return true;
		}
		return false;
	}

	public static function getAchievementIndex(name:String) {
		for (i in 0...achievementsStuff.length) {
			if(achievementsStuff[i][2] == name) {
				return i;
			}
		}
		return -1;
	}

	public static function loadAchievements():Void {
		if(FlxG.save.data != null) {
			if(FlxG.save.data.achievementsMap != null) {
				achievementsMap = FlxG.save.data.achievementsMap;
			}
			if(henchmenDeath == 0 && FlxG.save.data.henchmenDeath != null) {
				henchmenDeath = FlxG.save.data.henchmenDeath;
			}
		}
	}
}

class AttachedAchievement extends FlxSprite {
	public var sprTracker:FlxSprite;
	private var tag:String;
	public function new(x:Float = 0, y:Float = 0, name:String) {
		super(x, y);

		changeAchievement(name);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function changeAchievement(tag:String) {
		this.tag = tag;
		reloadAchievementImage();
	}

	public function reloadAchievementImage() {
		if(Achievements.isAchievementUnlocked(tag)) {
			loadGraphic(Paths.image('achievements/' + tag));
		} else {
			loadGraphic(Paths.image('achievements/lockedachievement'));
		}
		scale.set(0.7, 0.7);
		updateHitbox();
	}

	override function update(elapsed:Float) {
		if (sprTracker != null)
			setPosition(sprTracker.x - 130, sprTracker.y + 25);

		super.update(elapsed);
	}
}

class AchievementObject extends FlxSpriteGroup {
	public var onFinish:Void->Void = null;
	var alphaTween:FlxTween;
	public function new(name:String, ?camera:FlxCamera = null)
	{
		super(x, y);
		ClientPrefs.saveSettings();

		var id:Int = Achievements.getAchievementIndex(name);
		var achievementBG:FlxSprite = new FlxSprite(60, 50).makeGraphic(420, 120, FlxColor.BLACK);
		achievementBG.scrollFactor.set();

		var achievementIcon:FlxSprite = new FlxSprite(achievementBG.x + 10, achievementBG.y + 10).loadGraphic(Paths.image('achievements/' + name));
		achievementIcon.scrollFactor.set();
		achievementIcon.setGraphicSize(Std.int(achievementIcon.width * (2 / 3)));
		achievementIcon.updateHitbox();
		achievementIcon.antialiasing = ClientPrefs.globalAntialiasing;

		var achievementName:FlxText = new FlxText(achievementIcon.x + achievementIcon.width + 20, achievementIcon.y + 16, 280, Achievements.achievementsStuff[id][0], 16);
		achievementName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementName.scrollFactor.set();

		var achievementText:FlxText = new FlxText(achievementName.x, achievementName.y + 32, 280, Achievements.achievementsStuff[id][1], 16);
		achievementText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementText.scrollFactor.set();

		add(achievementBG);
		add(achievementName);
		add(achievementText);
		add(achievementIcon);

		var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
		if(camera != null) {
			cam = [camera];
		}
		alpha = 0;
		achievementBG.cameras = cam;
		achievementName.cameras = cam;
		achievementText.cameras = cam;
		achievementIcon.cameras = cam;
		alphaTween = FlxTween.tween(this, {alpha: 1}, 0.5, {onComplete: function (twn:FlxTween) {
			alphaTween = FlxTween.tween(this, {alpha: 0}, 0.5, {
				startDelay: 2.5,
				onComplete: function(twn:FlxTween) {
					alphaTween = null;
					remove(this);
					if(onFinish != null) onFinish();
				}
			});
		}});
	}

	override function destroy() {
		if(alphaTween != null) {
			alphaTween.cancel();
		}
		super.destroy();
	}
}