function onCreate()

	
	makeLuaSprite('house','nibel/orihouse',x,y)
	setProperty('house.scale.x', getProperty('house.scale.x') + 1);
	setProperty('house.scale.y', getProperty('house.scale.y') + 1);
	
	makeLuaSprite('lightinshit','nibel/orihouselighting',x,y)
	setProperty('lightinshit.scale.x', getProperty('lightinshit.scale.x') + 1);
	setProperty('lightinshit.scale.y', getProperty('lightinshit.scale.y') + 1);
	
	addLuaSprite('house',false)
	addLuaSprite('lightinshit',false)

	if not lowQuality then
		makeAnimatedLuaSprite('gang', 'nibel/forest/thegang', 600, 380); 
		addAnimationByPrefix('gang', 'bop', 'thegang idle', 12, false)
		addAnimationByPrefix('gang', 'hey', 'thegang hey', 12, false)
		addLuaSprite('gang', false);
		makeAnimationList();
	end

end

function onStepHit()
	if curStep == 516 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 524 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 532 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 540 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 548 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 556 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 564 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 572 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 580 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 588 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 596 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 604 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 612 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 620 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 628 then
		objectPlayAnimation('gang', 'hey', true);
	end
	if curStep == 636 then
		objectPlayAnimation('gang', 'hey', true);
	end
end

function onBeatHit()
	if curBeat % 1 == 0 then
		--makes the gang bop to the beat
		objectPlayAnimation('gang', 'bop', true);
	end
--   	if curBeat >= 129 and curBeat <= 147 and curBeat % 2 ~= 0 then
--  	     objectPlayAnimation('gang', 'hey', true);
--  	end
end