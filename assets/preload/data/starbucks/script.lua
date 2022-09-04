function onCreate()
	if not downscroll then
		mokiy = 400
		gumoy = 0
		kuy = 700
		kugoto = 350
	else
		mokiy = 300
		gumoy = -200
		kuy = -400
		kugoto = -100
	end
	makeAnimatedLuaSprite('moki', 'purgatory/fuckdrawingbackgrounds/stargang', 1000, mokiy);
	addAnimationByPrefix('moki', 'peek', 'stargang moki peek', 24, false);
	addAnimationByPrefix('moki', 'hold', 'stargang moki hold', 24, false);
	addAnimationByPrefix('moki', 'laugh', 'stargang moki laugh', 24, false);
	addAnimationByPrefix('moki', 'wheeze', 'stargang moki wheeze', 24, false);
	addAnimationByPrefix('moki', 'dies', 'stargang moki dies', 1, false);
	addAnimationByPrefix('moki', 'corner', 'stargang moki corner', 24, false);
	addAnimationByPrefix('moki', 'cryin', 'stargang moki cryin', 24, false);
	setObjectCamera('moki','Hud')
	scaleObject('moki', 0.5, 0.5)
	addLuaSprite('moki')

	makeAnimatedLuaSprite('gumo', 'purgatory/fuckdrawingbackgrounds/stargang', 800, gumoy);
	addAnimationByPrefix('gumo', 'dip', 'stargang gumo dip', 24, false);
	addAnimationByPrefix('gumo', 'store', 'stargang gumo store', 24, false);
	setObjectCamera('gumo','Hud')
	addLuaSprite('gumo')

	makeAnimatedLuaSprite('ku', 'purgatory/fuckdrawingbackgrounds/stargang', -200, kuy);
	addAnimationByPrefix('ku', 'store', 'stargang ku exist', 24, false);
	setObjectCamera('ku','Hud')
	scaleObject('ku', 0.5, 0.5)
	addLuaSprite('ku')

	makeAnimatedLuaSprite('naru', 'purgatory/fuckdrawingbackgrounds/stargang', 0, 690);
	addAnimationByPrefix('naru', 'exist', 'stargang naru exist', 24, false);
	addAnimationByPrefix('naru', 'confused', 'stargang naru confused', 24, false);
	addAnimationByPrefix('naru', 'what', 'stargang naru what', 24, false);
	addAnimationByPrefix('naru', 'hold', 'stargang naru hold', 24, false);
	addAnimationByPrefix('naru', 'really', 'stargang naru really', 24, false);
	setProperty('naru.visible', false)
	addLuaSprite('naru')
end	
function onStepHit()
	if curStep == 59 then
		doTweenX('mokienter', 'moki', 700, 1, 'cubeOut')
	end
	if curStep == 389 then
		doTweenY('kuenter', 'ku', kugoto, 1, 'cubeOut')
	end
	if curStep == 397 then
		setProperty('ku.flipX', true)
		setProperty('ku.x', -400)
	end
	if curStep == 583 then
		setProperty('naru.visible', true)
	end
	if curStep == 751 then
		setProperty('naru.scale.x', 1.2)
		setProperty('naru.scale.y', 1.2)
	end
	if curStep == 853 then
		setProperty('naru.scale.x', 1.4)
		setProperty('naru.scale.y', 1.4)
	end
	if curStep == 855 then
		doTweenX('gumoenter', 'gumo', 300, 1, 'cubeOut')
	end
	if curStep == 1105 then
		setProperty('naru.scale.x', 1.6)
		setProperty('naru.scale.y', 1.6)
		doTweenX('narushrink1', 'naru.scale', 0.2, 1)
		doTweenY('narushrink2', 'naru.scale', 0.2, 1)
	end
end