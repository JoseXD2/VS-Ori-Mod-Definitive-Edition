lastanim = 'singLEFT'
function onUpdate()
	if getProperty('gf.animation.curAnim.name') ~= lastanim then
		objectPlayAnimation('fizzlight', getProperty('gf.animation.curAnim.name'))
	end
	lastanim = getProperty('gf.animation.curAnim.name')
end

function onCreate()
	makeAnimatedLuaSprite('fizzlight', 'characters/fizzlight', getProperty('gf.x'), getProperty('gf.y'))
	addAnimationByIndices('fizzlight', 'danceLeft', 'fizzlight dance', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14', 24)
	addAnimationByIndices('fizzlight', 'danceRight', 'fizzlight dance', '15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29', 24)
	addAnimationByPrefix('fizzlight', 'singUP', 'fizzlight up', 24)
	addAnimationByPrefix('fizzlight', 'singDOWN', 'fizzlight down', 24)
	addAnimationByPrefix('fizzlight', 'singLEFT', 'fizzlight left', 24)
	addAnimationByPrefix('fizzlight', 'singRIGHT', 'fizzlight right', 24)
	
	--don't ask why the fps is different for the light to sync up, I don't even know lol
	addLuaSprite('fizzlight', true)
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	--light changes color to hitting the notes
	if direction == 0 then
		setProperty('fizzlight.color', 10879231)
		doTweenColor('bacc', 'fizzlight', 16777215, 0.5)
	elseif direction == 1 then
		setProperty('fizzlight.color', 4095)
		doTweenColor('bacc', 'fizzlight', 16777215, 0.5)
	elseif direction == 2 then
		setProperty('fizzlight.color', 65280)
		doTweenColor('bacc', 'fizzlight', 16777215, 0.5)
	else
		setProperty('fizzlight.color', 16711680)
		doTweenColor('bacc', 'fizzlight', 16777215, 0.5)
	end
end
