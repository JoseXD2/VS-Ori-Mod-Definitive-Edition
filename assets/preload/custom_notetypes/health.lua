	function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is a Fire Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'health' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'extra/HEALnote'); --Change texture --Change note splash texture
		end
	end
end

function onUpdate()
	if noteType == 'health' then
	health = getProperty('health')
	if getProperty('health') > 0.15 then
	if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
	setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false);
	end
	else
	if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
	setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
	end
end
end
end