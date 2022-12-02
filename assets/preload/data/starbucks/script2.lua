                -- Script made by Washo789, please, if you use it or modify it, I would like you to give me credits.
			--WASHO IF YOU READ THIS SOMEHOW I HAVE A WORD FOR YOU
			-- your script kinda works and has the right idea, but you didn't scan if bf was using his normal idle or singleft alt animation... 
			--also those process things at the start did literally nothing but do calculations for no reason. I deleted it but why lol
	
local xx = 550; -- Code to change the position of the camera to the left or right for your opponent, Less = Left (They can be negative numbers), More = Right
local yy = 500; -- Code to change the position of the camera up or down for the enemy Less = Down (They can be negative numbers), More = Up
local xx2 = 1000; -- Same code as above, but for boyfriend left, right
local yy2 = 1000; -- Same code as above, but for boyfriend up, down
local ofs = 25; -- Code to adjust the intensity with which the camera moves, the more numbers, the more intense, and the fewer numbers, less intense


function onUpdate() -- The Main Code
        if mustHitSection == false then -- Code for the camera to follow the poses of your opponent
            if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
        else
                 -- Code for the camera to follow the poses of boyfriend
            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
            end
		if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx2,yy2)
            end
        end
end
