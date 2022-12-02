function onStepHit()
	if curStep == 446 then
	setPropertyFromClass('GameOverSubstate', 'characterName', 'finn-player');
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'finn-faints');
	setProperty('health', getProperty('health')-3);
	end
end
