function onCreate()
    damage = 0.0 -- If you wanna fuck up then increase this
    maxdamage = 0.005 -- And also increase this so you don't die unless you want to die from missing and pressing glitch notes.
end

function onStepHit()
    health = getProperty('health')
    if getProperty('health') > damage + maxdamage then
        setProperty('health', health - damage);
    end
    if getProperty('health') < damage + maxdamage then
        if getProperty('health') - maxdamage > 0.4 then
            setProperty('health', maxdamage)
        end
        end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if noteType == 'decay-note' then
        damage = damage + 0.005
    end
end