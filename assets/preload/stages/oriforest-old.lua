function onCreate()

	
	makeLuaSprite('oriforest','nibel/forest/legacy/forest-old',100,100)
	setProperty('oriforest.scale.x', getProperty('oriforest.scale.x') + 1);
	setProperty('oriforest.scale.y', getProperty('oriforest.scale.y') + 1);

	

	makeLuaSprite('treeeees','nibel/forest/legacy/trees',100,150)
	setProperty('treeeees.scale.x', getProperty('treeeees.scale.x') + 1);
	setProperty('treeeees.scale.y', getProperty('treeeees.scale.y') + 1);
	
		
	addLuaSprite('oriforest',false)
	addLuaSprite('treeeees',false)
	setScrollFactor('treeeees', 1.1, 1.1);
	
	
	if not lowQuality then
		makeAnimatedLuaSprite('gang', 'nibel/forest/thegang', 200, 310); 
		addAnimationByPrefix('gang', 'bop', 'thegang idle', 12, false)
		addLuaSprite('gang', false);
		makeAnimationList();
	
	end

	makeLuaSprite('flash', '', 0, 0);
	makeGraphic('flash',1280,720,'ffffff')
	addLuaSprite('flash', true);
	setLuaSpriteScrollFactor('flash',0,0)
	setProperty('flash.scale.x',1.2)
	setProperty('flash.scale.y',1.2)
	setProperty('flash.alpha',0)

end



function onBeatHit()
	if curBeat % 2 == 0 then
		objectPlayAnimation('gang', 'bop', true);
	end
end

