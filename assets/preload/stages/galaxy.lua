function onCreate()

	
	makeLuaSprite('space','purgatory/space/galaxy',-500,-200)
	setProperty('space.scale.x', getProperty('space.scale.x') + 0.3);
	setProperty('space.scale.y', getProperty('space.scale.y') + 0.3);
	
		
	addLuaSprite('space',false)
	setScrollFactor('space', 0.005, 0.005); -- Honestly I could've put 0 because they're so far from the galaxy.

	makeLuaSprite('flash', '', 0, 0);
	makeGraphic('flash',1280,720,'ffffff')
	addLuaSprite('flash', true);
	setLuaSpriteScrollFactor('flash',0,0)
	setProperty('flash.scale.x',1.2)
	setProperty('flash.scale.y',1.2)
	setProperty('flash.alpha',0)

end
