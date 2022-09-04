

function onCreate()
    makeLuaSprite('gray', 'purgatory/think/gray', -300, -300)
    addLuaSprite('gray')
    setProperty('gray.alpha', 0.4)

    makeLuaSprite('bg', 'purgatory/think/bg', -540, -725)
    addLuaSprite('bg', false)

    makeLuaSprite('layer', 'purgatory/think/layer', -540, -725)
    addLuaSprite('layer', true)

    makeLuaSprite('songdata', 'purgatory/think/songdata', -540, -725)
    addLuaSprite('songdata', true)
end

function onBeatHit()
	if math.random(0,100) == 50 then
		characterPlayAnim('boyfriend', 'WHAT', true);
		setProperty('boyfriend.specialAnim', true);
	end
end

function onStepHit()
	if curStep == 32 then
	setProperty('songdata.alpha', 0);
	end
end
