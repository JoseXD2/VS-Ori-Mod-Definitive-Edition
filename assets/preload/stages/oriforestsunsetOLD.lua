colorchange = 'FFA496'
tweentime = 0.01

function onCreate()
	x = 0
	y = -100

	makeLuaSprite('gloweffect','nibel/origlow',-100,280)

	makeLuaSprite('bg','nibel/forest/sunset/bgsunset',x,y)
	setProperty('bg.scale.x', 2);
	setProperty('bg.scale.y', 2);

	makeLuaSprite('clouds','nibel/forest/day/clouds',x,y+300)
	setProperty('clouds.scale.x', 2);
	setProperty('clouds.scale.y', 2);

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

	makeLuaSprite('grass','nibel/forest/day/gss',x,y+100)
	setProperty('grass.scale.x', 2);
	setProperty('grass.scale.y', 2);

	makeLuaSprite('treeeees','nibel/forest/day/trees',150,300)
	setProperty('treeeees.scale.x', 2);
	setProperty('treeeees.scale.y', 2);

	addLuaSprite('bg',false)
	if not lowQuality then
	addLuaSprite('clouds',false)
	end
	addLuaSprite('tree',false)
	if not lowQuality then
	addLuaSprite('treeglow',false)
	end
	addLuaSprite('thing',false)
	addLuaSprite('mountains',false)
	addLuaSprite('bushes',false)
	addLuaSprite('grass',false)
	addLuaSprite('gloweffect',false)

	addLuaSprite('treeeees',true)

	setScrollFactor('treeeees', 1.2, 1.2);
	setScrollFactor('bg', 0.05, 0.05);
	setScrollFactor('clouds', 0.06, 0.06);
	setScrollFactor('thing', 0.2, 0.2);
	setScrollFactor('mountains', 0.2, 0.2);
	setScrollFactor('tree', 0.4, 0.4);
	setScrollFactor('treeglow', 0.4, 0.4);
	setScrollFactor('bushes', 0.75, 0.75);

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

