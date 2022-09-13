package;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.system.FlxSoundGroup;
import flixel.math.FlxPoint;
import openfl.geom.Point;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
 /**
 hey you fun commiting people, 
 i don't know about the rest of the mod but since this is basically 99% my code 
 i do not give you guys permission to grab this specific code and re-use it in your own mods without asking me first.
 the secondary dev, ben

 shut up ben lmfao
*/
/**

	hi

**/

class CharacterInSelect
{
	public var names:Array<String>;
	public var polishedNames:Array<String>;

	public function new(names:Array<String>, polishedNames:Array<String>)
	{
		this.names = names;
		this.polishedNames = polishedNames;
	}
}
class CharacterSelectState extends MusicBeatState
{
	public var char:Boyfriend;
	public var current:Int = 0;
	public var curForm:Int = 0;
	public var characterText:FlxText;
	public var menubg:String = 'menuBG';
	public var funnyIconMan:HealthIcon;
	private var cock:FlxText;
	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

	public var isDebug:Bool = false; //CHANGE THIS TO FALSE BEFORE YOU COMMIT RETARDS

	public var PressedTheFunny:Bool = false;

	var selectedCharacter:Bool = false;

	private var cock2:FlxText;

	var currentSelectedCharacter:CharacterInSelect;

	private var pressedTheFunny:Bool = false;

	var noteMsTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	//it goes left,right,up,down
	
	public var characters:Array<CharacterInSelect> = 
	[
		new CharacterInSelect(['default'], ["Default\n(Reccomended)"]),
		new CharacterInSelect(['altbf', 'bfchristmasyey', 'bf-pixel', 'bfb'], ["Boyfriend", 'Christmas Boyfriend', 'Pixel Boyfriend', 'B-Sides Boyfriend']),
		new CharacterInSelect(['ori-player', 'ori-pastel', 'ori-ku'], ['Ori', '[PURGATORY]\nOri Nibel', 'Ori and Ku\n(by LittleKingDW)']),
		new CharacterInSelect(['evilori'], ['[PURGATORY]\nEvil Ori']),
		new CharacterInSelect(['kuro'], ['Kuro']),
		new CharacterInSelect(['shriek', 'shriekb'], ['Shriek', 'B-Sides Shriek']),
		new CharacterInSelect(['finn-player'], ['[PURGATORY]\nFinn Young']),
		new CharacterInSelect(['destio','destio-og'], ['[PURGATORY]\nDestio', '[PURGATORY]\nDestio (OLD)']),
		new CharacterInSelect(['james'], ['[PURGATORY]\nJames Jamestar']),
	//	new CharacterInSelect(['saln', 'saln-god'], ['[PURGATORY]\nSaln', '[PURGATORY]\nSaln GOD']),
		new CharacterInSelect(['acebf'], ["Funsized Ace"]),
		new CharacterInSelect(['arzo'], ['[PURGATORY]\nArzo']),
		new CharacterInSelect(['cesar', 'CEEZARS-PIZZA-AAAA'], ['[PURGATORY]\nCesar', '[PURGATORY]\nCESAR\'S PIZZA\nAAAAAAAAAAAA']),
		new CharacterInSelect(['alvar'], ['[PURGATORY]\nAlvar']),
		new CharacterInSelect(['nylo'], ['[PURGATORY]\nNylo']),
		new CharacterInSelect(['voltex'], ['[PURGATORY]\nVoltex']),
		new CharacterInSelect(['kuch'], ['Kuchisake-onna'])

	];
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		Conductor.changeBPM(110);
		currentSelectedCharacter = characters[current];

		if (SelectGameState.inpurgatory)
			menubg = 'purgatorydecay';
		else
			menubg = 'new-forest';

		FlxG.save.data.unlockedcharacters = [true,true,true,true,true,true,true,true]; //unlock everyone hi

		var end:FlxSprite = new FlxSprite(0, 0);
		if (SelectGameState.inpurgatory)
		FlxG.sound.playMusic(Paths.music("darkness"),1,true);	
		else
		FlxG.sound.playMusic(Paths.music("the-blinded-forest"),0.7,true);
		add(end);
		
		//create stage
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image(menubg));
		bg.setGraphicSize(Std.int(bg.width * 1.4));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		add(bg);
		/*
		var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		stageFront.antialiasing = true;
		stageFront.scrollFactor.set(0.9, 0.9);
		stageFront.active = false;
		add(stageFront);

		var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		stageCurtains.updateHitbox();
		stageCurtains.antialiasing = true;
		stageCurtains.scrollFactor.set(1.3, 1.3);
		stageCurtains.active = false;
		add(stageCurtains);*/

		FlxG.camera.zoom = 0.75;

		new FlxTimer().start(1, bopit);

		//create character
		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, "default");
		char.screenCenter();
		char.y = 450;
		add(char);
		
		characterText = new FlxText((FlxG.width / 9) - 50, (FlxG.height / 8) - 100, "Default\n(Reccomended)");
		characterText.font = 'vcr';
		characterText.setFormat(Paths.font("vcr.ttf"), 90, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		characterText.autoSize = false;
		characterText.fieldWidth = 1080;
		characterText.borderSize = 7;
		characterText.screenCenter(X);
		add(characterText);

		funnyIconMan = new HealthIcon('bf', true);
		funnyIconMan.sprTracker = characterText;
		funnyIconMan.visible = true;
		funnyIconMan.y += 500;
		funnyIconMan.alpha = 0.7;
		add(funnyIconMan);

		var tutorialThing:FlxSprite = new FlxSprite(-100, -50).loadGraphic(Paths.image('charSelectGuide'));
		tutorialThing.setGraphicSize(Std.int(tutorialThing.width * 1.5));
		tutorialThing.antialiasing = true;
		add(tutorialThing);

		cock = new FlxText(12, FlxG.height - 44, 0, "", 20);
		cock.scrollFactor.set();
		cock.alpha = 0;
		cock.text = 'NOTE: This character does not normally appear in the Definitive Edition!';
		cock.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.RED, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(cock);

		cock2 = new FlxText(12, FlxG.height - 84, 0, "", 20);
		cock2.scrollFactor.set();
		cock2.alpha = 0;
		cock2.text = '(Character animation enabled, press shift again to disable)';
		cock2.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(cock2);
		
		#if android
		addVirtualPad(LEFT_FULL, A_B);
		#end
	}

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		//FlxG.camera.focusOn(FlxG.ce);

	//	if (FlxG.keys.justPressed.ESCAPE)
	//	{
	//		LoadingState.loadAndSwitchState(new PlayMenuState());
	//	}

		if (FlxG.keys.justPressed.SHIFT && char.curCharacter != 'default') {
			if (!pressedTheFunny) {
			pressedTheFunny = true;
			cock2.alpha = 1;
			}
			else {
			pressedTheFunny = false;
			cock2.alpha = 0;
			}
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			
			if (SelectGameState.inpurgatory)
			MusicBeatState.switchState(new PURFreeplayState());
			else
			MusicBeatState.switchState(new FreeplayState());
		}

		
		if(controls.UI_LEFT_P && pressedTheFunny)
		{
			if(char.curCharacter != 'bf' || char.curCharacter != 'bf-pixel' || char.curCharacter != 'destio' || char.curCharacter != 'finn-player' || char.curCharacter != 'ori-player' || char.curCharacter != 'acebf' || char.curCharacter != 'ori-ku')
			{ // doesn't work for every character since I'm too lazy to list every single one lmao
				char.playAnim('singLEFT', true);
			}
			else
			{
				char.playAnim('singRIGHT', true);
			}

		}
		if(controls.UI_RIGHT_P && pressedTheFunny)
		{
			if(char.curCharacter != 'altbf' || char.curCharacter != 'bf-pixel' || char.curCharacter != 'destio' || char.curCharacter != 'finn-player' || char.curCharacter != 'ori-player' || char.curCharacter != 'acebf' || char.curCharacter != 'ori-ku')
			{ // doesn't work for every character since I'm too lazy to list every single one lmao
				char.playAnim('singRIGHT', true);
			}
			else
			{
				char.playAnim('singLEFT', true);
			}
		}
		if(controls.UI_UP_P && pressedTheFunny)
		{
			char.playAnim('singUP', true);
		}
		if(controls.UI_DOWN_P && pressedTheFunny)
		{
			char.playAnim('singDOWN', true);
		}
		if (controls.ACCEPT)
		{
			if (!pressedTheFunny)
			{
			selectedCharacter = true;
			var heyAnimation:Bool = char.animation.getByName("hey") != null; 
			char.playAnim(heyAnimation ? 'hey' : 'singUP', true);
			FlxG.sound.music.stop();
		//	FlxG.sound.play(Paths.music('gameOverEnd'));
			FlxG.sound.play(Paths.sound('confirmMenu'), 1);
			new FlxTimer().start(0.1, endIt);
			}
		}
		if (!pressedTheFunny)
		{
		if (FlxG.keys.justPressed.LEFT && !selectedCharacter)
		{
			curForm = 0;
			current--;
			if (current < 0)
			{
				current = characters.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (FlxG.keys.justPressed.RIGHT && !selectedCharacter)
		{
			curForm = 0;
			current++;
			if (current > characters.length - 1)
			{
				current = 0;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		if (FlxG.keys.justPressed.DOWN && !selectedCharacter)
		{
			curForm--;
			if (curForm < 0)
			{
				curForm = characters[current].names.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (FlxG.keys.justPressed.UP && !selectedCharacter)
		{
			curForm++;
			if (curForm > characters[current].names.length - 1)
			{
				curForm = 0;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		}
	}

	public function UpdateBF()
	{
		funnyIconMan.color = FlxColor.WHITE;
		currentSelectedCharacter = characters[current];
		characterText.text = currentSelectedCharacter.polishedNames[curForm];
		char.destroy();
		remove(cock);
		remove(cock2);
		funnyIconMan.destroy();
		funnyIconMan = new HealthIcon(currentSelectedCharacter.names[curForm], true);
		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, currentSelectedCharacter.names[curForm]);
		char.screenCenter();
		funnyIconMan.screenCenter(X);
		char.y = 450;
		funnyIconMan.y += 500;
		funnyIconMan.alpha = 0.7;

		switch (char.curCharacter)
		{
			case 'fin' | 'destio' | 'destio-og' | 'finn-player' | 'saln' | 'saln-god' | 'shriekb' | 'bfb' | 'james' | 'kuch' | 'acebf' | 'ori-ku':
				cock.alpha = 1;
				char.y = 100;
			case 'altbf' | 'bf' | 'bf-pixel' | 'bf-christmas' | 'default' | 'ori-pastel' | 'ori-ku':
				cock.alpha = 0;
			default: char.y = 100;
				cock.alpha = 0;

		}
		add(char);
		funnyIconMan.animation.play(char.curCharacter);
		add(funnyIconMan);
		characterText.screenCenter(X);
		add(cock);
		add(cock2);
	}

	override function beatHit()
	{
		super.beatHit();
	}
	
	private function bopit(e:FlxTimer = null)
	{
		new FlxTimer().start(1, bopit); // infinite loop.
		if (char != null)
			{
				char.playAnim('idle');
			}	
	}

	public function endIt(e:FlxTimer = null)
	{
		trace("ENDING");
		PlayState.characteroverride = currentSelectedCharacter.names[0];
		PlayState.formoverride = currentSelectedCharacter.names[curForm];
		PlayState.curmult = [1, 1, 1, 1];
		LoadingState.loadAndSwitchState(new PlayState());
	}
	
}
