function onCreate()

	
	makeLuaSprite('fuckyou','purgatory/screw you/cheating',0,0)
	setProperty('fuckyou.scale.x', getProperty('fuckyou.scale.x') + 4);
	setProperty('fuckyou.scale.y', getProperty('fuckyou.scale.y') + 4);
	
		
	addLuaSprite('fuckyou',false)
	setScrollFactor('fuckyou', 0, 0);
	
	

end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	triggerEvent('Screen Shake','1,0.01,1,0.01')
end
