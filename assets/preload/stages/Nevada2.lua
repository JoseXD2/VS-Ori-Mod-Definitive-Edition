colorchange = '963147'
tweentime = 0.01
function onCreate()
	makeLuaSprite('gloweffect','nibel/origlow',700,1000)
	
	makeLuaSprite('diebitch','purgatory/hellniwen/hell',100,-1500)
	setProperty('diebitch.scale.x', getProperty('diebitch.scale.x') + 4.5);
	setProperty('diebitch.scale.y', getProperty('diebitch.scale.y') + 4.5);
	
	makeLuaSprite('treeeees','purgatory/hellniwen/extradip',100,-1500)
	setProperty('treeeees.scale.x', getProperty('treeeees.scale.x') + 4.5);
	setProperty('treeeees.scale.y', getProperty('treeeees.scale.y') + 4.5);
	
	addLuaSprite('diebitch',false)
	addLuaSprite('gloweffect',false)
	addLuaSprite('treeeees',false)
	setScrollFactor('treeeees', 1.1, 1.1);

end
function onCreatePost() --psych engine you suck
	doTweenColor('diebitch','diebitch',colorchange,tweentime);
	doTweenColor('treeeees','treeeees',colorchange,tweentime);
	doTweenColor('gf', 'gf',colorchange,tweentime);
	doTweenColor('dad', 'dad',colorchange,tweentime);
end