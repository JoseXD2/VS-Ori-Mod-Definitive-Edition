colorchange = '5B5E7D'
tweentime = 80
x = 0
y = -100
function onCreate()
	makeLuaSprite('gloweffect','nibel/origlow',-100,280)



	makeLuaSprite('bg-dark','nibel/forest/night/bg-dark',x,y)
	setProperty('bg-dark.scale.x', 2);
	setProperty('bg-dark.scale.y', 2);


	makeLuaSprite('clouds-dark','nibel/forest/night/clouds-dark',x,y+300)
	setProperty('clouds-dark.scale.x', 2);
	setProperty('clouds-dark.scale.y', 2);


	makeLuaSprite('tree-dark','nibel/forest/night/tree-dark',x,y)
	setProperty('tree-dark.scale.x', 2);
	setProperty('tree-dark.scale.y', 2);


	makeLuaSprite('thing-dark','nibel/forest/night/thingyintheback-dark',x,y)
	setProperty('thing-dark.scale.x', 2);
	setProperty('thing-dark.scale.y', 2);


	makeLuaSprite('mountains-dark','nibel/forest/night/twomountains-dark',x,y)
	setProperty('mountains-dark.scale.x', 2);
	setProperty('mountains-dark.scale.y', 2);

	
	makeLuaSprite('bushes-dark','nibel/forest/night/twobushes-dark',x,y)
	setProperty('bushes-dark.scale.x', 2);
	setProperty('bushes-dark.scale.y', 2);


	makeLuaSprite('grass-dark','nibel/forest/night/gss-dark',x,y)
	setProperty('grass-dark.scale.x', 2);
	setProperty('grass-dark.scale.y', 2);


	

	makeLuaSprite('treeeees-dark','nibel/forest/night/trees-dark',150,300)
	setProperty('treeeees-dark.scale.x', 2);
	setProperty('treeeees-dark.scale.y', 2);


	
	addLuaSprite('bg-dark',false)
	if not lowQuality then
	addLuaSprite('clouds-dark',false)
	end
	addLuaSprite('tree-dark',false)
	addLuaSprite('thing-dark',false)
	addLuaSprite('mountains-dark',false)
	addLuaSprite('bushes-dark',false)
	addLuaSprite('grass-dark',false)
	if not lowQuality then
	addLuaSprite('gloweffect-dark',true)
	end
	addLuaSprite('treeeees-dark',true)
	addLuaSprite('gloweffect',true)



	setObjectOrder('treeeees-dark', 29)
	setObjectOrder('gloweffect-dark', 16)
	setObjectOrder('grass-dark', 14)
	setObjectOrder('bushes-dark', 12)
	setObjectOrder('mountains-dark', 10)
	setObjectOrder('thing-dark', 8)
	setObjectOrder('tree-dark', 5)
	setObjectOrder('clouds-dark', 3)
	setObjectOrder('bg-dark', 1)

	

	setObjectOrder('treeeees', 30)
	setObjectOrder('gloweffect', 17)
	setObjectOrder('grass', 15)
	setObjectOrder('bushes', 13)
	setObjectOrder('mountains', 11)
	setObjectOrder('thing', 9)
	setObjectOrder('treeglow', 7)
	setObjectOrder('tree', 6)
	setObjectOrder('clouds', 4)
	setObjectOrder('bg', 2)
	

	setScrollFactor('treeeees-dark', 1.2, 1.2);
	setScrollFactor('bg-dark', 0.05, 0.05);
	setScrollFactor('clouds-dark', 0.06, 0.06);
	setScrollFactor('tree-dark', 0.7, 0.7);
	setScrollFactor('thing-dark', 0.7, 0.7);
	setScrollFactor('mountains-dark', 0.8, 0.8);
	setScrollFactor('bushes-dark', 0.9, 0.9);
end
function onStepHit()
	if curStep == 1 then
		doTweenColor('bfColorTween', 'boyfriend', colorchange, tweentime);
		doTweenColor('gfColorTween', 'gf', colorchange, tweentime);
		doTweenAlpha('gloweffectTween', 'gloweffect', 1, tweentime);
		doTweenColor('gangColorTween', 'gang', colorchange, tweentime);

		doTweenAlpha('bgAlphaTween1', 'bg', 0, tweentime);
		doTweenAlpha('bgAlphaTween2', 'clouds', 0, tweentime);
		doTweenAlpha('bgAlphaTween3', 'tree', 0, tweentime);
		doTweenAlpha('bgAlphaTween4', 'thing', 0, tweentime);
		doTweenAlpha('bgAlphaTween5', 'mountains', 0, tweentime);
		doTweenAlpha('bgAlphaTween6', 'bushes', 0, tweentime);
		doTweenAlpha('bgAlphaTween7', 'grass', 0, tweentime);
		doTweenAlpha('bgAlphaTween8', 'treeeees', 0, tweentime);
end
end
function onCountdownTick(counter)
	if counter == 0 then
		doTweenColor('bfColorTween', 'boyfriend', colorchange, tweentime);
		doTweenColor('gfColorTween', 'gf', colorchange, tweentime);
		doTweenAlpha('gloweffectTween', 'gloweffect', 1, tweentime);
		doTweenColor('gangColorTween', 'gang', colorchange, tweentime);

		doTweenAlpha('bgAlphaTween1', 'bg', 0, tweentime);
		doTweenAlpha('bgAlphaTween2', 'clouds', 0, tweentime);
		doTweenAlpha('bgAlphaTween3', 'tree', 0, tweentime);
		doTweenAlpha('bgAlphaTween4', 'thing', 0, tweentime);
		doTweenAlpha('bgAlphaTween5', 'mountains', 0, tweentime);
		doTweenAlpha('bgAlphaTween6', 'bushes', 0, tweentime);
		doTweenAlpha('bgAlphaTween7', 'grass', 0, tweentime);
		doTweenAlpha('bgAlphaTween8', 'treeeees', 0, tweentime);
	end
end
