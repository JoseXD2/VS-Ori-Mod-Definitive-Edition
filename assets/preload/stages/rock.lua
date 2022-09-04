function onCreate()
	finncolor = 'FF99A1'
	salncolor = 'FF3A3D'
	colorchange = '5B5E7D'
	tweentime = 0.01

	makeLuaSprite('finngloweffect','nibel/origlow',550,370)
	makeLuaSprite('salngloweffect','nibel/origlow',-550,-300)
	setProperty('salngloweffect.scale.x', getProperty('salngloweffect.scale.x') + 2);
	setProperty('salngloweffect.scale.y', getProperty('salngloweffect.scale.y') + 2);

	makeLuaSprite('rock','purgatory/saln/rock',0,0)
	setProperty('rock.scale.x', getProperty('rock.scale.x') + 2);
	setProperty('rock.scale.y', getProperty('rock.scale.y') + 2);

	makeLuaSprite('treeeees','nibel/forest/day/trees',0,300)
	setProperty('treeeees.scale.x', 3);
	setProperty('treeeees.scale.y', 3);
		
	addLuaSprite('rock',false)
	addLuaSprite('treeeees',false)
	addLuaSprite('salngloweffect',false)
	addLuaSprite('finngloweffect',false)

	makeLuaSprite('flash', '', 0, 0);
	makeGraphic('flash',1280,720,'ffffff')
	addLuaSprite('flash', true);
	setLuaSpriteScrollFactor('flash',0,0)
	setProperty('flash.scale.x',1.2)
	setProperty('flash.scale.y',1.2)
	setProperty('flash.alpha',0)

end

function onCreatePost()
	doTweenColor('rock','rock',colorchange,tweentime);
	doTweenColor('treeeees','treeeees',colorchange,tweentime);
	doTweenColor('finngloweffect','finngloweffect',finncolor,tweentime);
	doTweenColor('salngloweffect','salngloweffect',salncolor,tweentime);
end