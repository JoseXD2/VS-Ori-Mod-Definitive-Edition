function onCreate()

	
	makeLuaSprite('treeeees','nibel/forest/night-old/trees',100,150)
	setProperty('treeeees.scale.x', getProperty('treeeees.scale.x') + 1);
	setProperty('treeeees.scale.y', getProperty('treeeees.scale.y') + 1);

	makeLuaSprite('grass','nibel/forest/night-old/grass shit',100,100)
	setProperty('grass.scale.x', getProperty('grass.scale.x') + 1);
	setProperty('grass.scale.y', getProperty('grass.scale.y') + 1);

	makeLuaSprite('ass','nibel/forest/night-old/grass',100,100)
	setProperty('ass.scale.x', getProperty('ass.scale.x') + 1);
	setProperty('ass.scale.y', getProperty('ass.scale.y') + 1);

	makeLuaSprite('backgroundtrees','nibel/forest/night-old/background trees',100,-50)
	setProperty('backgroundtrees.scale.x', getProperty('backgroundtrees.scale.x') + 1);
	setProperty('backgroundtrees.scale.y', getProperty('backgroundtrees.scale.y') + 1);

	makeLuaSprite('spirittree','nibel/forest/night-old/spirit tree',100,20)
	setProperty('spirittree.scale.x', getProperty('spirittree.scale.x') + 0.6);
	setProperty('spirittree.scale.y', getProperty('spirittree.scale.y') + 0.6);

	makeLuaSprite('backgroundshit','nibel/forest/night-old/far away shit',100,-50)
	setProperty('backgroundshit.scale.x', getProperty('backgroundshit.scale.x') + 0.8);
	setProperty('backgroundshit.scale.y', getProperty('backgroundshit.scale.y') + 0.8);

	makeLuaSprite('skybox','nibel/forest/rain/sky',100,100)
	setProperty('skybox.scale.x', getProperty('skybox.scale.x') + 0.3);
	setProperty('skybox.scale.y', getProperty('skybox.scale.y') + 0.3);
	
	
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

	makeLuaSprite('eff','thefunnyeffect', 0, 0)
	setGraphicSize('eff',1280,720)
	setObjectCamera('eff','camHud')
	updateHitbox('eff')
	setBlendMode('eff','multiply')
	addLuaSprite('eff', false);
	setProperty('eff.alpha', 0.5);


	

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

