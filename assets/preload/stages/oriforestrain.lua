function onCreate()
	x = 0
	y = -100
	colorchange = '2B2B2B'
	bgcolorchange = '121212'
	tweentime = 0.01

	makeLuaSprite('bgnight','nibel/forest/day/bg',x,y)
	setProperty('bgnight.scale.x', 2);
	setProperty('bgnight.scale.y', 2);

	makeLuaSprite('bg','nibel/forest/day/bg',x,y)
	setProperty('bg.scale.x', 2);
	setProperty('bg.scale.y', 2);

	makeLuaSprite('tree','nibel/forest/day/tree',x,y)
	setProperty('tree.scale.x', 2);
	setProperty('tree.scale.y', 2);
	
	makeLuaSprite('treeglow','nibel/forest/treeglow',x,y)
	setProperty('treeglow.scale.x', 2);
	setProperty('treeglow.scale.y', 2);

	makeLuaSprite('thing','nibel/forest/day/thingyintheback',x,y)
	setProperty('thing.scale.x', 2);
	setProperty('thing.scale.y', 2);

	makeLuaSprite('mountains','nibel/forest/day/twomountains',x,y)
	setProperty('mountains.scale.x', 2);
	setProperty('mountains.scale.y', 2);
	
	makeLuaSprite('bushes','nibel/forest/day/twobushes',x,y)
	setProperty('bushes.scale.x', 2);
	setProperty('bushes.scale.y', 2);

	makeLuaSprite('grass','nibel/forest/day/gss',x,y)
	setProperty('grass.scale.x', 2);
	setProperty('grass.scale.y', 2);

	

	makeLuaSprite('treeeees','nibel/forest/night/trees-dark',320,300)
	setProperty('treeeees.scale.x', 2);
	setProperty('treeeees.scale.y', 2);

	makeLuaSprite('gloweffect','nibel/origlow',-300,280)
	setProperty('gloweffect.alpha', 0)
	setProperty('gloweffect.color', '000000');
	
	addLuaSprite('bgnight',false)
	addLuaSprite('bg',false)
	addLuaSprite('tree',false)
	addLuaSprite('treeglow',false)
	addLuaSprite('thing',false)
	addLuaSprite('mountains',false)
	addLuaSprite('bushes',false)
	addLuaSprite('grass',false)

	addLuaSprite('treeeees',false)
	addLuaSprite('gloweffect',true)
	setScrollFactor('treeeees', 1.1, 1.1);
	setScrollFactor('bgnight', 0.5, 0.5);
	setScrollFactor('tree', 0.7, 0.7);
	setScrollFactor('treeglow', 0.7, 0.7);
	setScrollFactor('thing', 0.7, 0.7);
	setScrollFactor('mountains', 0.8, 0.8);
	setScrollFactor('bushes', 0.9, 0.9);
	
	

	makeAnimatedLuaSprite('rain1','nibel/forest/rain/NewRAINLayer01', 0, 0)
	addAnimationByPrefix('rain1', 'rain', 'RainFirstlayer instance 1', 30, true)
	setObjectCamera('rain1','camHud')
	updateHitbox('rain1')
	addLuaSprite('rain1', true);

	makeAnimatedLuaSprite('rain2','nibel/forest/rain/NewRainLayer02', 0, 0)
	addAnimationByPrefix('rain2', 'rainn', 'RainFirstlayer instance 1', 30, true)
	setObjectCamera('rain2','camHud')
	updateHitbox('rain2')
	addLuaSprite('rain2', true);
	makeAnimationList();



	
	objectPlayAnimation('rain1', 'rain', true);
	objectPlayAnimation('rain2', 'rainn', true);



end
function onCreatePost()
	if not isStoryMode or seenCutscene then 
		--turns instantly dark if you aren't in a cutscene
		doTweenColor('bfColorTween', 'boyfriend', colorchange, tweentime);
		doTweenColor('gfColorTween', 'gf', colorchange, tweentime);
		doTweenAlpha('gloweffectTween', 'gloweffect', 1, tweentime);
		doTweenAlpha('bgdie', 'bg', 0, tweentime);
		doTweenColor('bgColorTween1', 'bgnight', colorchange, tweentime);
		doTweenColor('bgColorTween3', 'tree', bgcolorchange, tweentime);
		doTweenColor('bgColorTween4', 'thing', bgcolorchange, tweentime);
		doTweenColor('bgColorTween5', 'mountains', bgcolorchange, tweentime);
		doTweenColor('bgColorTween6', 'bushes', colorchange, tweentime);
		doTweenColor('bgColorTween7', 'grass', colorchange, tweentime);
		doTweenColor('forebgColorTween', 'treeeees', colorchange, tweentime);
	end
end
recentBeat = 0
function onBeatHit()
	--lightning stuff, recentBeat used to stop lightning from occuring too close to eachother
	if recentBeat + 20 < curBeat then
		if math.random(1,15) == 2 then
			runTimer('lightning', 0.05, 4)
			playSound('lightning')
			recentBeat = curBeat
			objectPlayAnimation('boyfriend', 'scared')
			objectPlayAnimation('ori', 'scared')
		end
	end
end
function onTimerCompleted(tag, loops, loopsLeft)
	--timer for lightning stuff
	if tag == 'lightning' then
		if loopsLeft % 2 == 0 then
			--doTweenColor('bflightning', 'boyfriend', colorchange, tweentime);
			doTweenColor('bglightning', 'bgnight', colorchange, tweentime);
		else
			--doTweenColor('bflightningback', 'boyfriend', 'FFFFFF', tweentime);
			doTweenColor('bglightningback', 'bgnight', 'FFFFFF', tweentime);
		end
	end
end

