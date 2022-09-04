function onCreate()
	x = 0
	y = -100
	makeLuaSprite('sky1','purgatory/neo/sky1',x,y)
	addLuaSprite('sky1')
	makeLuaSprite('sky2','purgatory/neo/sky2',x,y)
	addLuaSprite('sky2')
	makeLuaSprite('building1','purgatory/neo/buildings1',x,y)
	addLuaSprite('building1')
	makeLuaSprite('building2','purgatory/neo/buildings2',x,y)
	addLuaSprite('building2')
	makeLuaSprite('stage1','purgatory/neo/djstage1',x,y)
	addLuaSprite('stage1')
	makeLuaSprite('stage2','purgatory/neo/djstage2',x,y)
	addLuaSprite('stage2')
end
function onBeatHit()
	setProperty('sky2.visible', curBeat % 2 == 0)
	setProperty('building2.visible', curBeat % 2 == 0)
	setProperty('stage2.visible', curBeat % 2 == 0)
end