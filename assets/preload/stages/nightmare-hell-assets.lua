function onCreate()
	colorchange = '5B5E7D'
	tweentime = 0.01
	x = 0
	y = -100
	makeLuaSprite('bg','nibel/v5/bg-dark',x,y)
	setProperty('bg.scale.x', 2);
	setProperty('bg.scale.y', 2);

	makeLuaSprite('clouds','nibel/v5/clouds-dark',x,y+300)
	setProperty('clouds.scale.x', 2);
	setProperty('clouds.scale.y', 2);

	makeLuaSprite('thing','nibel/v5/thingyintheback-dark',x-100,y-100)
	setProperty('thing.scale.x', 2);
	setProperty('thing.scale.y', 2);

	makeLuaSprite('mountains','nibel/v5/mountains night',x-100,y+300)
	setProperty('mountains.scale.x', 2);
	setProperty('mountains.scale.y', 2);

	makeLuaSprite('grass','purgatory/nightmare-hell/nibel/ground',x,y+100)
	setProperty('grass.scale.x', 3);
	setProperty('grass.scale.y', 3);

	makeLuaSprite('treeeees','nibel/v5/trees-dark',100,300)
	setProperty('treeeees.scale.x', 3);
	setProperty('treeeees.scale.y', 3);

	makeLuaSprite('cave','purgatory/nightmare-hell/cave/cave',100,y+300)
	setProperty('cave.scale.x', 3);
	setProperty('cave.scale.y', 3);

	makeLuaSprite('cavespikes','purgatory/nightmare-hell/cave/cave spikes',100,0)
	setProperty('cavespikes.scale.x', 3);
	setProperty('cavespikes.scale.y', 3);

	makeLuaSprite('dieforest','purgatory/nightmare-hell/niwen/dieforest',x,y+100)
	setProperty('dieforest.scale.x', getProperty('dieforest.scale.x') + 4.5);
	setProperty('dieforest.scale.y', getProperty('dieforest.scale.y') + 4.5);

	makeLuaSprite('ground','purgatory/nightmare-hell/niwen/gound',x,y+100)
	setProperty('ground.scale.x', getProperty('ground.scale.x') + 4.5);
	setProperty('ground.scale.y', getProperty('ground.scale.y') + 4.5);

	makeLuaSprite('treeslol','purgatory/nightmare-hell/niwen/backgroundtreeslol',x,y+200)
	setProperty('treeslol.scale.x', getProperty('treeslol.scale.x') + 4.5);
	setProperty('treeslol.scale.y', getProperty('treeslol.scale.y') + 4.5);

	makeLuaSprite('skybox','purgatory/nightmare-hell/niwen/withered sky',x,y+100)
	setProperty('skybox.scale.x', getProperty('skybox.scale.x') + 4.5);
	setProperty('skybox.scale.y', getProperty('skybox.scale.y') + 4.5);

	makeLuaSprite('extradip','purgatory/nightmare-hell/niwen/extradip',x,y+100)
	setProperty('extradip.scale.x', getProperty('extradip.scale.x') + 4.5);
	setProperty('extradip.scale.y', getProperty('extradip.scale.y') + 4.5);

	doTweenColor('bfColorTween', 'boyfriend', colorchange, tweentime);
	doTweenColor('gfColorTween', 'gf', colorchange, tweentime);
	doTweenColor('gangColorTween', 'gang', colorchange, tweentime);
	

	addLuaSprite('bg',false)
	addLuaSprite('clouds',false)
	addLuaSprite('thing',false)
	addLuaSprite('mountains',false)
	addLuaSprite('bushes',false)
	addLuaSprite('grass',false)

	addLuaSprite('treeeees',true)

	setScrollFactor('treeeees', 1.2, 1.2);
	setScrollFactor('bg', 0.05, 0.05);
	setScrollFactor('clouds', 0.06, 0.06);
	setScrollFactor('thing', 0.1, 0.1);
	setScrollFactor('mountains', 0.1, 0.1);
	setScrollFactor('cavespikes', 1.1, 1.1);
	setScrollFactor('skybox', 0.05, 0.05);
	setScrollFactor('treeslol', 0.85, 0.85);
	setScrollFactor('extradip', 1.1, 1.1);

	makeLuaSprite('eff','niwen/thefunnyeffect', 0, 0)
	setGraphicSize('eff',1280,720)
	setObjectCamera('eff','camHud')
	updateHitbox('eff')
	setBlendMode('eff','multiply')
	addLuaSprite('eff', true);

end

function onCreatePost()
	doTweenColor('bfColorTween', 'boyfriend', colorchange, 0.01);
	doTweenColor('grass', 'grass', colorchange, 0.01);
	doTweenColor('gfColorTween', 'gf', colorchange, 0.01);
	doTweenColor('cave', 'cave', colorchange, 0.01);
	doTweenColor('cavespikes', 'cavespikes', colorchange, 0.01);
end

function onUpdate()
	setProperty('eff.alpha', 1-(getProperty('health')/2));
end

function onStepHit()
	if curStep == 1792 then
	removeLuaSprite('bg',false)
	removeLuaSprite('clouds',false)
	removeLuaSprite('thing',false)
	removeLuaSprite('mountains',false)
	removeLuaSprite('bushes',false)
	removeLuaSprite('grass',false)
	removeLuaSprite('treeeees',true)
	addLuaSprite('cave',false)
	addLuaSprite('cavespikes',false)
	end
	if curStep == 3328 then
	removeLuaSprite('cave',false)
	removeLuaSprite('cavespikes',false)

	addLuaSprite('skybox',false)
	addLuaSprite('treeslol',false)
	addLuaSprite('dieforest',false)
	addLuaSprite('ground',false)
	addLuaSprite('extradip',false)
	end
end

function onBeatHit()
	if curBeat % 4 == 0 then
		if getProperty('health') < 1 and getProperty('health') > 0.4 then
		playSound('heartbeat', 1/getProperty('health'));
		playSound('heartbeat', 1/getProperty('health'));
		end
	end
	if curBeat % 2 == 0 then
		if getProperty('health') < 0.4 then
		playSound('heartbeat', 1);
		playSound('heartbeat', 1);
		end
	end
end