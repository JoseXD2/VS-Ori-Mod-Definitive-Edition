function onStartCountdown(counter)
	cameraFlash('hud', '000000', 500, false)
end
function onSongStart()
	cameraFlash('hud', 'FFFFFF', 1, true)
end
function onBeatHit()
	if curBeat == 208 then
		cameraFlash('hud', 'FFFFFF', 1, true)
	end
	if curBeat == 416 then
		cameraFlash('hud', 'FFFFFF', 1, true)
	end
end