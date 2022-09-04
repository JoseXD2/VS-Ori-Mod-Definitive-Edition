	function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is a Fire Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'GlitchCOR' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'extra/GlitchNOTE_assets'); --Change texture --Change note splash texture

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Lets Opponent's instakill notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has no penalties
			else
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false);
			end
		end
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'GlitchCOR' then
		triggerEvent('Add Camera Zoom', '.05', '0');
		characterPlayAnim('boyfriend', 'hurt', true);
		playSound('rock', 0.8);
		health = getProperty('health')
		setProperty('health', getProperty('health')-0.2);
		runTimer('bleed2', 0.1, 10);
    end
end



function onTimerCompleted(tag, loops, loopsLeft)
	-- A loop from a timer you called has been completed, value "tag" is it's tag
	-- loops = how many loops it will have done when it ends completely
	-- loopsLeft = how many are remaining
	if loopsLeft >= 1 then
		setProperty('health', getProperty('health')-0.055);
	end
end
