colorchange = 'FFA496'
tweentime = 0.01

function onCreate()
	x = 0
	y = -100

	makeLuaSprite('gloweffect','nibel/origlow',-100,280)

	makeLuaSprite('bg','nibel/v5/bgsunset',x,y)
	setProperty('bg.scale.x', 2);
	setProperty('bg.scale.y', 2);

	makeLuaSprite('clouds','nibel/v5/clouds',x,y+300)
	setProperty('clouds.scale.x', 2);
	setProperty('clouds.scale.y', 2);

	makeLuaSprite('thing','nibel/v5/tinythingintheback',x-100,y-100)
	setProperty('thing.scale.x', 2);
	setProperty('thing.scale.y', 2);

	makeLuaSprite('mountains','nibel/v5/mountains',x-100,y+300)
	setProperty('mountains.scale.x', 2);
	setProperty('mountains.scale.y', 2);

	makeLuaSprite('tree','nibel/v5/tree',x+700,y+50)
	setProperty('tree.scale.x', 2);
	setProperty('tree.scale.y', 2);
	
	makeLuaSprite('treeglow','nibel/v5/treeglow',x,y)
	setProperty('treeglow.scale.x', 2);
	setProperty('treeglow.scale.y', 2);
	
	makeLuaSprite('bushes','nibel/v5/bushes day',x,y+500)
	setProperty('bushes.scale.x', 2);
	setProperty('bushes.scale.y', 2);

	makeLuaSprite('grass','nibel/v5/gss',x,y+100)
	setProperty('grass.scale.x', 2);
	setProperty('grass.scale.y', 2);

	makeLuaSprite('treeeees','nibel/v5/trees',100,300)
	setProperty('treeeees.scale.x', 2);
	setProperty('treeeees.scale.y', 2);

	addLuaSprite('bg',false)
	addLuaSprite('clouds',false)
	addLuaSprite('thing',false)
	addLuaSprite('mountains',false)
	addLuaSprite('tree',false)
	addLuaSprite('treeglow',false)
	addLuaSprite('bushes',false)
	addLuaSprite('grass',false)
	addLuaSprite('gloweffect',true)

	addLuaSprite('treeeees',true)

	setScrollFactor('treeeees', 1.2, 1.2);
	setScrollFactor('bg', 0.05, 0.05);
	setScrollFactor('clouds', 0.06, 0.06);
	setScrollFactor('thing', 0.1, 0.1);
	setScrollFactor('mountains', 0.1, 0.1);
	setScrollFactor('tree', 0.15, 0.15);
	setScrollFactor('treeglow', 0.15, 0.15);
	setScrollFactor('bushes', 0.75, 0.75);

	if songName == 'CORN' then
	makeLuaSprite('ragequitlol','purgatory/rage quit',-450,-230)
	setGraphicSize('ragequitlol',1920, 1080)
	setObjectCamera('ragequitlol','camHud')
	updateHitbox('ragequitlol')
	setProperty('ragequitlol.alpha', 0);
	addLuaSprite('ragequitlol',false)
	end

	if not lowQuality then
		--makes the gang
		makeAnimatedLuaSprite('gang', 'nibel/forest/thegang', 200, 310); 
		addAnimationByPrefix('gang', 'bop', 'thegang idle', 12, false)
		addLuaSprite('gang', false);
		makeAnimationList();
	end

end

function onCreatePost() --psych engine you suck
	doTweenColor('gang','gang',colorchange,tweentime);
	doTweenColor('bushes','bushes',colorchange,tweentime);
	doTweenColor('mountains','mountains',colorchange,tweentime);
	doTweenColor('thing','thing',colorchange, tweentime);
	doTweenColor('tree','tree',colorchange,tweentime);
	doTweenColor('grass','grass',colorchange,tweentime);
	doTweenColor('treeeees','treeeees',colorchange,tweentime);
	doTweenColor('bf', 'boyfriend',colorchange,tweentime);
	doTweenColor('gf', 'gf',colorchange,tweentime);
end

function onBeatHit()
	if curBeat % 1 == 0 then
		--makes the gang bop to the beat
		objectPlayAnimation('gang', 'bop', true);
	end

end
function onStepHit()
	if songName == 'CORN' then
	if curStep == 142 then
	setProperty('ragequitlol.alpha', 1);
	end
	if curStep == 179 then
	setProperty('ragequitlol.alpha', 0);
	end
end
end
