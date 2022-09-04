local allowCountdown = false
function onStartCountdown()
	if not allowCountdown then --Block the first countdown
		startVideo('chiken');
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end