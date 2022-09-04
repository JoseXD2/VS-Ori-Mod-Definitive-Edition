function onCreate()

	colorchange = '727272'
	tweentime = 0.01

	makeLuaSprite('hell','purgatory/hell/hell i think',0,0)
	setProperty('hell.scale.x', getProperty('hell.scale.x') + 4);
	setProperty('hell.scale.y', getProperty('hell.scale.y') + 4);
	
		
	addLuaSprite('hell',false)
	setScrollFactor('hell', 0, 0);

	makeLuaSprite('flash', '', 0, 0);
	makeGraphic('flash',1280,720,'ffffff')
	addLuaSprite('flash', true);
	setLuaSpriteScrollFactor('flash',0,0)
	setProperty('flash.scale.x',1.2)
	setProperty('flash.scale.y',1.2)
	setProperty('flash.alpha',0)

end

function onCreatePost()
	if songName ~= 'Defeat' then
	doTweenColor('bfColorTween', 'boyfriend', colorchange, 0.01);
	end
	doTweenColor('gfColorTween', 'gf', colorchange, 0.01);
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if songName 'Opposition' or songName 'Deafening' or songName 'Rebound' then
	triggerEvent('Screen Shake','0.1,0.03','0.1,0.03')
end
end
