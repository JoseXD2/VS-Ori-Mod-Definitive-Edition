function onCreate()

	
	makeLuaSprite('fuckingpizza','purgatory/cesar house/CEEZARS PIZZA BG',100,100)
	setProperty('fuckingpizza.scale.x', getProperty('fuckingpizza.scale.x') + 1);
	setProperty('fuckingpizza.scale.y', getProperty('fuckingpizza.scale.y') + 1);
	
		
	addLuaSprite('fuckingpizza',false)
	makeLuaSprite('flash', '', 0, 0);
	makeGraphic('flash',1280,720,'ffffff')
	addLuaSprite('flash', true);
	setLuaSpriteScrollFactor('flash',0,0)
	setProperty('flash.scale.x',1.2)
	setProperty('flash.scale.y',1.2)
	setProperty('flash.alpha',0)

end
