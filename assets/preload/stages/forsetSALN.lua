function onCreate()


	makeLuaSprite('treeeees','purgatory/hellforest/trees',100,150)
	setProperty('treeeees.scale.x', getProperty('treeeees.scale.x') + 1);
	setProperty('treeeees.scale.y', getProperty('treeeees.scale.y') + 1);

	makeLuaSprite('ass','purgatory/hellforest/grass',100,100)
	setProperty('ass.scale.x', getProperty('ass.scale.x') + 1);
	setProperty('ass.scale.y', getProperty('ass.scale.y') + 1);

	makeLuaSprite('backgroundtrees','purgatory/hellforest/background trees',100,-50)
	setProperty('backgroundtrees.scale.x', getProperty('backgroundtrees.scale.x') + 1);
	setProperty('backgroundtrees.scale.y', getProperty('backgroundtrees.scale.y') + 1);

	makeLuaSprite('spirittree','purgatory/hellforest/spirit tree',100,20)
	setProperty('spirittree.scale.x', getProperty('spirittree.scale.x') + 0.6);
	setProperty('spirittree.scale.y', getProperty('spirittree.scale.y') + 0.6);

	makeLuaSprite('backgroundshit','purgatory/hellforest/far away shit',100,-50)
	setProperty('backgroundshit.scale.x', getProperty('backgroundshit.scale.x') + 0.8);
	setProperty('backgroundshit.scale.y', getProperty('backgroundshit.scale.y') + 0.8);

	makeLuaSprite('skybox','purgatory/hellforest/sky',100,100)
	setProperty('skybox.scale.x', getProperty('skybox.scale.x') + 0.3);
	setProperty('skybox.scale.y', getProperty('skybox.scale.y') + 0.3);
	
	addLuaSprite('skybox',false)
	addLuaSprite('backgroundshit',false)
	addLuaSprite('spirittree',false)
	addLuaSprite('backgroundtrees',false)
	addLuaSprite('ass',false)
	addLuaSprite('treeeees',false)
	setScrollFactor('treeeees', 1.1, 1.1);
	setScrollFactor('backgroundtrees', 0.6, 0.6);
	setScrollFactor('spirittree', 0.3, 0.3);
	setScrollFactor('backgroundshit', 0.2, 0.2);
	setScrollFactor('skybox', 0.05, 0.05);

	makeLuaSprite('eff','purgatory/thefunnyeffect', 0, 0)
	setGraphicSize('eff',1280,720)
	setObjectCamera('eff','camHud')
	updateHitbox('eff')
	setBlendMode('eff','multiply')
	addLuaSprite('eff', false);

	makeLuaSprite('fuckyou','purgatory/blocked', 400, -200)
	setObjectCamera('fuckyou','camHud')
	updateHitbox('fuckyou')
	setGraphicSize('fuckyou',1024, 768)
	addLuaSprite('fuckyou',false)

	makeLuaSprite('warning','purgatory/hellforest/warning',-400,-300)
	setGraphicSize('warning',1920, 1080)
	setObjectCamera('warning','camHud')
	updateHitbox('warning')
	setProperty('warning.alpha', 0);
	addLuaSprite('warning',false)
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    if curBeat > 123 then
    triggerEvent('Screen Shake','0.01, 0.01','999, 0.015')
	end
end

function onUpdate()
	if keyPressed('space') then
	setProperty('fuckyou.alpha', 1);
	else
	setProperty('fuckyou.alpha', 0);
end
	setProperty('eff.alpha', 0.5/getProperty('health'));
end

function onStepHit()
	if curStep == 8 then
	setProperty('warning.alpha', 1);
	end
	if curStep == 128 then
	setProperty('warning.alpha', 0);
	end
end

function onBeatHit()
	if curBeat % 4 == 0 then
		if getProperty('health') < 1.4 and getProperty('health') > 0.4 then
		playSound('heartbeat', 0.6/getProperty('health'));
		end
	end
	if curBeat % 2 == 0 then
		if getProperty('health') < 0.4 then
		playSound('heartbeat', 0.6/getProperty('health'));
		end
	end
end

