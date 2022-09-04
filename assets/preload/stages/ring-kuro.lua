function onCreate()

	
	makeLuaSprite('ring','placeholders/ring',100,100)
	setProperty('ring.scale.x', getProperty('ring.scale.x') + 0.7);
	setProperty('ring.scale.y', getProperty('ring.scale.y') + 0.7);

	addLuaSprite('ring',false)

	makeLuaSprite('flash', '', 0, 0);
	makeGraphic('flash',1280,720,'ffffff')
	addLuaSprite('flash', true);
	setLuaSpriteScrollFactor('flash',0,0)
	setProperty('flash.scale.x',1.2)
	setProperty('flash.scale.y',1.2)
	setProperty('flash.alpha',0)

end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	triggerEvent('Screen Shake','0.1,0.01','0.1,0.01')
end

function onBeatHit()
--give me something to add.
end

