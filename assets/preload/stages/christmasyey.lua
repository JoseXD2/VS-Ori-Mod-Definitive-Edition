function onCreate()
	x = 0
	y = -100

	makeAnimatedLuaSprite('snowww', 'nibel/OH BOI ITS CHRISTMAS/snowstorm', x+1500, y+500)
	addAnimationByPrefix('snowww', 'snowin', 'snowstorm groove', 500, true)
	setProperty('snowww.angle', -30)
	setProperty('snowww.scale.x', 2);
	setProperty('snowww.scale.y', 2);
	addLuaSprite('snowww', true)

	makeLuaSprite('bg','nibel/v5/bg',x,y)
	setProperty('bg.scale.x', 2);
	setProperty('bg.scale.y', 2);

	makeLuaSprite('clouds','nibel/v5/clouds',x,y+300)
	setProperty('clouds.scale.x', 2);
	setProperty('clouds.scale.y', 2);

	makeLuaSprite('thing','nibel/v5/tinythingintheback',x-100,y-100)
	setProperty('thing.scale.x', 2);
	setProperty('thing.scale.y', 2);

	makeLuaSprite('mountains','nibel/v5/mountains',x-100,y+300)
	setProperty('mountains.scale.x', 2);
	setProperty('mountains.scale.y', 2);

	makeLuaSprite('tree','nibel/forest/OH BOI ITS CHRISTMAS/tree',x+700,y+50)
	setProperty('tree.scale.x', 2);
	setProperty('tree.scale.y', 2);
	
	makeLuaSprite('treeglow','nibel/v5/treeglow',x,y)
	setProperty('treeglow.scale.x', 2);
	setProperty('treeglow.scale.y', 2);
	
	makeLuaSprite('bushes','nibel/forest/OH BOI ITS CHRISTMAS/bushes day',x,y+500)
	setProperty('bushes.scale.x', 2);
	setProperty('bushes.scale.y', 2);

	makeLuaSprite('grass','nibel/forest/OH BOI ITS CHRISTMAS/gss',x,y+100)
	setProperty('grass.scale.x', 2);
	setProperty('grass.scale.y', 2);


	makeLuaSprite('treeeees','nibel/v5/trees',100,300)
	setProperty('treeeees.scale.x', 2);
	setProperty('treeeees.scale.y', 2);


	--haha you thought there would be a secret here

	addLuaSprite('bg',false)
	addLuaSprite('clouds',false)
	addLuaSprite('thing',false)
	addLuaSprite('mountains',false)
	addLuaSprite('tree',false)
	addLuaSprite('treeglow',false)
	addLuaSprite('bushes',false)
	addLuaSprite('grass',false)

	addLuaSprite('treeeees',true)

	setScrollFactor('treeeees', 1.2, 1.2);
	setScrollFactor('bg', 0.05, 0.05);
	setScrollFactor('clouds', 0.06, 0.06);
	setScrollFactor('thing', 0.1, 0.1);
	setScrollFactor('mountains', 0.1, 0.1);
	setScrollFactor('tree', 0.15, 0.15);
	setScrollFactor('treeglow', 0.15, 0.15);
	setScrollFactor('bushes', 0.75, 0.75);

end
function onCreatePost()
	objectPlayAnimation('snowww', 'snowin')
end

