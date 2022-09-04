package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
// Not even outdated lmfao
class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();
		leftState = false;
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Ok let me explain before you continue
			
			This mod is made by a lot of people and there will be
			different art styles and music and stuff like that
			This is kinda turned into a fan made project than official
			because I'm tired and I don't wanna do everything.
			
			Another thing to note, This mod WILL BE HARD! If you
			think the song difficulty isn't accurate well you're very
			wrong.
			There will be a list why that difficulty is choosen as that in
			a google document so DO NOT COMPLAIN ABOUT THE SONG DIFFICULTY
			NOT BEING RIGHT. I AM VERY ACCURATE WITH THOSE OPTIONS. IF YOU
			THINK IT'S HARD THEN TURN OFF MODCHARTS OR MECHANICS! That's all.
			
			btw thank you for downloading this mod.",
			32);
		warnText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
			//	CoolUtil.browserLoad("https://github.com/ShadowMario/FNF-PsychEngine/releases");
			}
			else if(controls.BACK) {
				leftState = true;
			}

			if(leftState)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 0.1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new SelectGameState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
