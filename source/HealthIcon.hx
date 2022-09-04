package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';
	public var charPublic:String = 'bf';

//	public var offsetX = 0;
//	public var offsetY = 0;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
		charPublic = char;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String) {
		if(this.char != char) {
		if (ClientPrefs.animatedicons) {
		switch (char) { // Yeah I know, this is a mess.
			case 'bf' | 'default' | 'bf-up' | 'bf-up-old' | 'cutscene-bf' | 'altbf':
				frames = Paths.getSparrowAtlas('icons');
								
				animation.addByPrefix(char + ' win', 'bf winning0', 24, true, isPlayer, false);
				animation.addByPrefix(char, 'bf idle', 24, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'bf hurt0', 24, true, isPlayer, false);
			case 'bf-old':
				frames = Paths.getSparrowAtlas('animatedicons/classic_icons_assets');
								
				animation.addByPrefix(char + ' win', 'beta bf healthy0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'beta bf healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'beta bf hurt0', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' ohshit', 'beta bf hurt0', 12, true, isPlayer, false);
			case 'bf-classic':
				frames = Paths.getSparrowAtlas('animatedicons/classic_icons_assets');
								
				animation.addByPrefix(char + ' win', 'og bf winning0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'og bf healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'og bf hurt0', 12, true, isPlayer, false);
			case 'ori-ku-og':
				frames = Paths.getSparrowAtlas('animatedicons/static_icons');
								
				animation.addByPrefix(char + ' win', 'oriku winning0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'oriku healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'oriku hurt0', 12, true, isPlayer, false);
			case 'ori-player' | 'ori-scared' | 'ori':
				frames = Paths.getSparrowAtlas('icons');
								
				animation.addByPrefix(char + ' win', 'ori winning0', 24, true, isPlayer, false);
				animation.addByPrefix(char, 'ori idle', 24, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'ori dead0', 24, true, isPlayer, false);
			case 'ori-classic' | 'ori-bad':
				frames = Paths.getSparrowAtlas('animatedicons/classic_icons_assets');
								
				animation.addByPrefix(char + ' win', 'og ori healthy0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'og ori healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'og ori hurt0', 12, true, isPlayer, false);
			case 'ori-pastel':
				frames = Paths.getSparrowAtlas('animatedicons/classic_icons_assets');
								
				animation.addByPrefix(char + ' win', 'og ori pastel winning0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'og ori pastel healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'og ori pastel hurt0', 12, true, isPlayer, false);
			case 'ori-run':
				frames = Paths.getSparrowAtlas('animatedicons/ori_icon_assets');
				// It's the same above but fliped winning and losing
				animation.addByPrefix(char + ' win', 'ori hurt0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'ori healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'ori winning0', 12, true, isPlayer, false);
			case 'shriek':
				frames = Paths.getSparrowAtlas('icons');

				animation.addByPrefix(char + ' win', 'shriek winning0', 24, true, isPlayer, false);
				animation.addByPrefix(char, 'shriek idle', 24, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'shriek pissed0', 24, true, isPlayer, false);
			case 'shriek-classic':
				frames = Paths.getSparrowAtlas('animatedicons/classic_icons_assets');

				animation.addByPrefix(char + ' win', 'og shriek healthy0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'og shriek healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'og shriek hurt0', 12, true, isPlayer, false);
			case 'shriekwhiteasslmao':
				frames = Paths.getSparrowAtlas('animatedicons/starbucks_icon_assets');

				animation.addByPrefix(char + ' win', 'shriek happi0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'shriek healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'shriek pissed0', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' winalt', 'shriek ohfuck0', 24, true, isPlayer, false);
			case 'nonelmao':
				frames = Paths.getSparrowAtlas('animatedicons/nonelmao');
				animation.addByPrefix(char + ' win', 'nothing0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'nothing', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'nothing0', 12, true, isPlayer, false);
			case 'finn' | 'finn-player' | 'finn-think' | 'finn-scared' | 'finn-scared1':
				frames = Paths.getSparrowAtlas('animatedicons/finn');
					
				animation.addByPrefix(char + ' win', 'finn winning0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'finn healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'finn hurt0', 12, true, isPlayer, false);
			case 'arzo':
				frames = Paths.getSparrowAtlas('animatedicons/purgatory_icon_assets');
					
				animation.addByPrefix(char + ' win', 'arzo winning0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'arzo healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'arzo pissed0', 12, true, isPlayer, false);
			case 'arzo-classic':
				frames = Paths.getSparrowAtlas('animatedicons/classic_icons_assets');
					
				animation.addByPrefix(char + ' win', 'og arzo winning0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'og arzo healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'og arzo pissed0', 12, true, isPlayer, false);
			case 'evilori':
				frames = Paths.getSparrowAtlas('animatedicons/purgatory_icon_assets');
					
				animation.addByPrefix(char + ' win', 'evilori winning0', 24, true, isPlayer, false);
				animation.addByPrefix(char, 'evilori healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'evilori hurt0', 12, true, isPlayer, false);
			case 'eduori':
				frames = Paths.getSparrowAtlas('animatedicons/classic_icons_assets');
					
				animation.addByPrefix(char + ' win', 'eduori healthy0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'eduori healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'eduori hurt0', 12, true, isPlayer, false);
			case 'pizza':
				frames = Paths.getSparrowAtlas('animatedicons/classic_icons_assets');
					
				animation.addByPrefix(char + ' win', 'cesar pizza winning0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'cesar pizza healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'cesar pizza hurt0', 12, true, isPlayer, false);
			case 'voltex':
				frames = Paths.getSparrowAtlas('animatedicons/static_icons');

				animation.addByPrefix(char + ' win', 'voltex winning0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'voltex healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'voltex hurt0', 12, true, isPlayer, false);
			case 'bfori-old':
				frames = Paths.getSparrowAtlas('animatedicons/classic_icons_assets');
					
				animation.addByPrefix(char + ' win', 'og bfori winning0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'og bfori healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'og bfori hurt0', 12, true, isPlayer, false);
			case 'ben':
				frames = Paths.getSparrowAtlas('animatedicons/purgatory_icon_assets');
					
				animation.addByPrefix(char + ' win', 'ben happy0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'ben still', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'ben angy0', 12, true, isPlayer, false);
			case 'bf-pixel' | 'bf-pixel-opponent':
				frames = Paths.getSparrowAtlas('animatedicons/main_icons');
					
				animation.addByPrefix(char + ' win', 'pixel bfwin0', 24, true, isPlayer, false);
				animation.addByPrefix(char, 'pixeel bf idle', 24, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'pixel bf lose0', 24, true, isPlayer, false);
			case 'gf':
				frames = Paths.getSparrowAtlas('animatedicons/main_icons');
				// It doesn't matter, girlfriend doesn't have a winning or losing.
				animation.addByPrefix(char +' win', 'gf icons', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'gf icons', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'gf icons', 12, true, isPlayer, false);
			case 'cesar':
				frames = Paths.getSparrowAtlas('animatedicons/classic_icons_assets');

				animation.addByPrefix(char +' win', 'cesar healthy0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'cesar healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'cesar hurt0', 12, true, isPlayer, false);
			case 'altcesar':
				frames = Paths.getSparrowAtlas('animatedicons/classic_icons_assets');

				animation.addByPrefix(char +' win', 'cesar alt smile0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'cesar alt healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'cesar alt what0', 12, true, isPlayer, false);
			case 'alvar':
				frames = Paths.getSparrowAtlas('animatedicons/classic_icons_assets');
	
				animation.addByPrefix(char +' win', 'alvar healthy0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'alvar healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'alvar hurt0', 12, true, isPlayer, false);
			case 'altalvar':
				frames = Paths.getSparrowAtlas('animatedicons/classic_icons_assets');
	
				animation.addByPrefix(char +' win', 'alvar alt healthy0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'alvar alt healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'alvar alt angy0', 12, true, isPlayer, false);
			default:
				frames = Paths.getSparrowAtlas('animatedicons/main_icons');
						
				animation.addByPrefix(char + ' win', 'face winning0', 12, true, isPlayer, false);
				animation.addByPrefix(char, 'face healthy', 12, true, isPlayer, false);
				animation.addByPrefix(char + ' lose', 'face hurt0', 12, true, isPlayer, false);
		}
	}
		else {
			var name:String = 'forevericons/main/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/main/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/characterselector/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/extras/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/purgatory/icon-' + char; //Purgatory Icons
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/old/icon-' + char; //Old Icons
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/freeplay/icon-' + char; //Freeplay Icons
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/joke/icon-' + char; //Joke!!!!
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Prevents crash from missing icon
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-awesomface'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file, true, 150, 150);

			animation.add(char, [0, 1, 2], 0, false, isPlayer);
			animation.play(char);
			this.char = char;
		}
		updateHitbox();
		animation.play(char);
		antialiasing = ClientPrefs.globalAntialiasing;
		if(char.endsWith('-pixel')) {
			antialiasing = false;
		}
	}
	}

	public function getCharacter():String {
		return char;
	}
}
