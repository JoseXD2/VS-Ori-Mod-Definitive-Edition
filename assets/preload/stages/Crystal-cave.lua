function onCreate()
	makeLuaSprite('cave','purgatory/fatality/Crystal_Cave',390,100)
	setProperty('cave.scale.x', 1.9);
	setProperty('cave.scale.y', 1.9);
	addLuaSprite('cave',false)

	makeLuaSprite('the','purgatory/fatality/Mandela_place',350,100)
	setProperty('the.scale.x', 2);
	setProperty('the.scale.y', 2);

	makeLuaSprite('void','purgatory/fatality/Fucking_void',390,100)
	setProperty('void.scale.x', 1.9);
	setProperty('void.scale.y', 1.9);

end

function onStepHit()
	if curStep == 256 then
		addLuaSprite('the',false)
		removeLuaSprite('cave',false)
		removeLuaSprite('void',false)
		cameraFlash('hud', 'FFFFFF', 1, true)
	end
	if curStep == 512 then
		removeLuaSprite('the',false)
		addLuaSprite('cave',false)
		removeLuaSprite('void',false)
		cameraFlash('hud', 'FFFFFF', 1, true)
	end
	if curStep == 1152 then
		addLuaSprite('the',false)
		removeLuaSprite('cave',false)
		removeLuaSprite('void',false)
		cameraFlash('hud', 'FFFFFF', 1, true)
	end
	if curStep == 1536 then
		removeLuaSprite('the',false)
		addLuaSprite('cave',false)
		removeLuaSprite('void',false)
		cameraFlash('hud', 'FFFFFF', 1, true)
	end
	if curStep == 1984 then
		addLuaSprite('the',false)
		removeLuaSprite('cave',false)
		removeLuaSprite('void',false)
		cameraFlash('hud', 'FFFFFF', 1, true)
	end
	if curStep == 2240 then
		removeLuaSprite('the',false)
		removeLuaSprite('cave',false)
		addLuaSprite('void',false)
		cameraFlash('hud', 'FFFFFF', 1, true)
	end
end