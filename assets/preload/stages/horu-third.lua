function onCreate()

	
	makeLuaSprite('dying','nibel/horu/dying-forest/bg',100,100)
	setProperty('dying.scale.x', getProperty('dying.scale.x') + 1);
	setProperty('dying.scale.y', getProperty('dying.scale.y') + 1);

	

	makeLuaSprite('treeeees','nibel/forest/night/trees',100,150)
	setProperty('treeeees.scale.x', getProperty('treeeees.scale.x') + 1);
	setProperty('treeeees.scale.y', getProperty('treeeees.scale.y') + 1);
	
		
	addLuaSprite('dying',false)
	addLuaSprite('treeeees',false)
	setScrollFactor('treeeees', 1.1, 1.1);

	makeLuaSprite('flash', '', 0, 0);
	makeGraphic('flash',1280,720,'ffffff')
	addLuaSprite('flash', true);
	setLuaSpriteScrollFactor('flash',0,0)
	setProperty('flash.scale.x',1.2)
	setProperty('flash.scale.y',1.2)
	setProperty('flash.alpha',0)

end
