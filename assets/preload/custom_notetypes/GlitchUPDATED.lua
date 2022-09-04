	function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is a Fire Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'GlitchUPDATED' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'extra/GlitchNOTE_assets'); --Change texture --Change note splash texture
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0.3');
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Lets Opponent's instakill notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has no penalties
			else
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false);
			end
		end
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'GlitchUPDATED' then
		characterPlayAnim('boyfriend', 'hurt', true);
		health = getProperty('health')
		playSound('rock', 0.8);
		setProperty('health', getProperty('health')-0.1);
		characterPlayAnim('boyfriend', 'hurt', true);
end
	if noteType == 'Glitch' then
		triggerEvent('Add Camera Zoom', '.05', '0'); -- Had to remove this from this song because it kept crashing smh
		characterPlayAnim('boyfriend', 'hurt', true);
		health = getProperty('health')
		setProperty('health', getProperty('health')-0.02);
		runTimer('bleed', 0, 0);
		characterPlayAnim('boyfriend', 'hurt', true);
    end
end



function onTimerCompleted(tag, loops, loopsLeft)
	-- A loop from a timer you called has been completed, value "tag" is it's tag
	-- loops = how many loops it will have done when it ends completely
	-- loopsLeft = how many are remaining
	if loopsLeft >= 1 then
		setProperty('health', getProperty('health')-0.0);
		if getProperty('health') <= 0 then
			setProperty('health', -0);
			playSound('owe', 0.8);
			setPropertyFromClass('GameOverSubstate', 'characterName', 'fuckingdead');
		end
	end
end
