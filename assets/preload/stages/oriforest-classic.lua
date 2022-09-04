function onCreate()

	makeLuaSprite('treeeees','nibel/forest/day/trees',100,150)
	setProperty('treeeees.scale.x', getProperty('treeeees.scale.x') + 1);
	setProperty('treeeees.scale.y', getProperty('treeeees.scale.y') + 1);

	makeLuaSprite('grass','nibel/forest/day/grass shit',100,100)
	setProperty('grass.scale.x', getProperty('grass.scale.x') + 1);
	setProperty('grass.scale.y', getProperty('grass.scale.y') + 1);

	makeLuaSprite('ass','nibel/forest/day/grass',100,100)
	setProperty('ass.scale.x', getProperty('ass.scale.x') + 1);
	setProperty('ass.scale.y', getProperty('ass.scale.y') + 1);

	makeLuaSprite('backgroundtrees','nibel/forest/day/background trees',100,-50)
	setProperty('backgroundtrees.scale.x', getProperty('backgroundtrees.scale.x') + 1);
	setProperty('backgroundtrees.scale.y', getProperty('backgroundtrees.scale.y') + 1);

	makeLuaSprite('spirittree','nibel/forest/day/spirit tree',100,20)
	setProperty('spirittree.scale.x', getProperty('spirittree.scale.x') + 0.6);
	setProperty('spirittree.scale.y', getProperty('spirittree.scale.y') + 0.6);

	makeLuaSprite('backgroundshit','nibel/forest/day/far away shit',100,-50)
	setProperty('backgroundshit.scale.x', getProperty('backgroundshit.scale.x') + 0.8);
	setProperty('backgroundshit.scale.y', getProperty('backgroundshit.scale.y') + 0.8);

	makeLuaSprite('skybox','nibel/forest/day/sky',250,100)
	setProperty('skybox.scale.x', getProperty('skybox.scale.x') + 1);
	setProperty('skybox.scale.y', getProperty('skybox.scale.y') + 1);
	
	
	addLuaSprite('skybox',false)
	addLuaSprite('backgroundshit',false)
	addLuaSprite('spirittree',false)
	addLuaSprite('backgroundtrees',false)
	addLuaSprite('ass',false)
	addLuaSprite('grass',false)
	addLuaSprite('treeeees',false)
	setScrollFactor('treeeees', 1.1, 1.1);
	setScrollFactor('ass', 0.95, 0.95);
	setScrollFactor('backgroundtrees', 0.6, 0.6);
	setScrollFactor('spirittree', 0.3, 0.3);
	setScrollFactor('backgroundshit', 0.2, 0.2);
	setScrollFactor('skybox', 0.05, 0.05);

	makeLuaSprite('warning','purgatory/rage quit',-450,-230)
	setGraphicSize('warning',1920, 1080)
	setObjectCamera('warning','camHud')
	updateHitbox('warning')
	setProperty('warning.alpha', 0);
	addLuaSprite('warning',false)

	makeLuaSprite('flash', '', 0, 0);
	makeGraphic('flash',1280,720,'ffffff')
	addLuaSprite('flash', true);
	setLuaSpriteScrollFactor('flash',0,0)
	setProperty('flash.scale.x',1.2)
	setProperty('flash.scale.y',1.2)
	setProperty('flash.alpha',0)

end

function onBeatHit()
	if curBeat % 1 == 0 then
		objectPlayAnimation('gang', 'bop', true);
	end
end

function onStepHit()
	if songName == 'CORN' then
	if curStep == 142 then
	setProperty('warning.alpha', 1);
	end
	if curStep == 160 then
	setProperty('warning.alpha', 0);
	end
end
end