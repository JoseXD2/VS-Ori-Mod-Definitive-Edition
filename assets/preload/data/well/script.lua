
function onCreate()

	iconname = 'funni/eduardo'
	iconnamew = 'funni/eduardow'
	iconnamel = 'funni/eduardol'

	
	makeAnimatedLuaSprite('fi', 'purgatory/funni/wellgang', -300, -1000); 
	addAnimationByPrefix('fi', 'bop', 'fin bop', 12, false)
	addAnimationByPrefix('fi', 'sus', 'fin sus', 12, false)

	addLuaSprite('fi', false);
	scaleObject('fi', 1.3, 1.3);
	
	makeAnimatedLuaSprite('deto', 'purgatory/funni/wellgang', -450, -950); 
	addAnimationByPrefix('deto', 'bop', 'desto bop', 12, false)
	addAnimationByPrefix('deto', 'sus', 'desto sus', 12, false)
	addLuaSprite('deto', false);
	scaleObject('deto', 1.3, 1.3);

	
	makeAnimatedLuaSprite('h', 'purgatory/funni/wellgang', -600, -900); 
	addAnimationByPrefix('h', 'bop', 'hu bop', 12, false)
	addAnimationByPrefix('h', 'sus', 'hu sus', 12, false)
	addLuaSprite('h', false);
	scaleObject('h', 1.3, 1.3);

	makeAnimatedLuaSprite('ka', 'purgatory/funni/wellgang', 1500, 250) 
	addAnimationByPrefix('ka', 'bop', 'kala bop', 12, false)
	addAnimationByPrefix('ka', 'sus', 'kala sus', 12, false)
	addLuaSprite('ka', false);
	scaleObject('ka', 1.3, 1.3);
	setProperty('ka.flipX', true)
	setProperty('ka.visible', false)

	makeAnimatedLuaSprite('wardo', 'purgatory/funni/EduardoBG', 2200, 400); -- well well well
	addAnimationByPrefix('wardo', 'walk', 'EduardoWalks', 120, true)
	addAnimationByPrefix('wardo', 'idle', 'EduardoIdol', 24, false)
	setScrollFactor('wardo', 1, 1);
	setProperty('wardo.alpha', 1);
	scaleObject('wardo', 1, 1);
	addLuaSprite('wardo', true);
	

	makeAnimatedLuaSprite('eduar', 'characters/Eduardo', 10, 400); -- eduardo
	addAnimationByPrefix('eduar', 'idle', 'EduardoIdle', 24, false)
	addAnimationByPrefix('eduar', 'singLEFT', 'EduardoLeft', 24, false)
	addAnimationByPrefix('eduar', 'singDOWN', 'EduardoDown', 24, false)
	addAnimationByPrefix('eduar', 'singUP', 'EduardoUp', 24, false)
	addAnimationByPrefix('eduar', 'singRIGHT', 'EduardoRight', 24, false)
	addAnimationByPrefix('eduar', 'well', 'EduardoWell', 24, false)
	setScrollFactor('eduar', 1, 1);
	setProperty('eduar.alpha', 0);
	scaleObject('eduar', 1, 1);
	addLuaSprite('eduar', true);

	makeAnimationList();

	

end


function onBeatHit()
	if curBeat == 67 then
		ganganim = 'quarter'
	end
	if curBeat == 131 then
		ganganim = 'half'
	end
	if curBeat == 195 then
		ganganim = 'sus'
	end
	if curBeat == 227 then
		playSound('runnin', 1, 's t o p')
	end
	if curBeat == 228 then
		setProperty('wardo.alpha', 1);
		doTweenX('WardoTweenX', 'wardo', 10, 1);
		
		objectPlayAnimation('wardo','walk',true)
	end
	if curBeat == 231 then
		doTweenY(' ', 'fi', 250, 0.4)
	end
	if curBeat == 232 then
		setProperty('wardo.alpha', 0);
		setProperty('eduar.alpha', 1);
		doTweenY('', 'deto', 350, 0.4)
		objectPlayAnimation('eduar', 'well', true)
		
	end
	if curBeat == 233 then
		objectPlayAnimation('eduar', 'well', true)
		doTweenY('  ', 'h', 450, 0.4)
	end
	if curBeat == 234 then
		objectPlayAnimation('eduar', 'well', true)
		setProperty('ka.visible', true)

	end
	if curBeat == 290 then
		finanim = 'sus'
	end
	if curBeat == 329 then
		destanim = 'sus'
	end
	if curBeat == 361 then
		huanim = 'sus'
	end
	if curBeat == 386 then
		kanim = 'sus'
	end

	if curBeat % 2 == 0 then
		objectPlayAnimation('gang', ganganim, true);
		if curBeat > 235 then
			objectPlayAnimation('eduar', 'idle', true);
			objectPlayAnimation('deto', destanim, true);
			objectPlayAnimation('fi', finanim, true);
			objectPlayAnimation('h', huanim, true);
			objectPlayAnimation('ka', kanim, true);
		end
	end
end
destanim = 'bop'
finanim = 'bop'
huanim = 'bop'
kanim = 'bop'
ganganim = 'bop'
function onTweenCompleted(tag)
	if tag == 'WardoTweenX' then
		objectPlayAnimation('wardo', 'idle', true)
		stopSound('s t o p')
	end
end





animationsList = {}
holdTimers = {eduar = -1.0};
noteDatas = {eduar = 0};
function makeAnimationList()
	animationsList[0] = 'singLEFT';
	animationsList[1] = 'singDOWN';
	animationsList[2] = 'singUP';
	animationsList[3] = 'singRIGHT';
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Special Sing' then
		if not isSustainNote then
			noteDatas.eduar = direction;
		end
		characterToPlay = 'eduar'
		animToPlay = noteDatas.eduar;
			
		playAnimation(characterToPlay, animToPlay, true);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'doIdol' then
		doIdle = true
	end
end

function playAnimation(character, animId, forced)
	animName = animationsList[animId];
	--debugPrint(animName);
	if character == 'eduar' then
		objectPlayAnimation('eduar', animName, forced); -- this part is easily broke if you use objectPlayAnim (I have no idea why its like this)
	end
end
