function onCreate()

	
	makeLuaSprite('dieforest','niwen/decay legacy/sauce',100,-1500)
	setProperty('dieforest.scale.x', getProperty('dieforest.scale.x') + 4.5);
	setProperty('dieforest.scale.y', getProperty('dieforest.scale.y') + 4.5);

	

	makeLuaSprite('treeeees','niwen/decay legacy/extradip',100,-1500)
	setProperty('treeeees.scale.x', getProperty('treeeees.scale.x') + 4.5);
	setProperty('treeeees.scale.y', getProperty('treeeees.scale.y') + 4.5);
	
		
	addLuaSprite('dieforest',false)
	addLuaSprite('treeeees',false)
	setScrollFactor('treeeees', 1.1, 1.1);
	
	

end