local collisions = {}

function collisions:beginContact(a, b, collision) 
    if Fire.beginContact(a, b, collision) then return end
    if Blackhole.beginContact(a, b, collision) then return end
        if Relic.beginContact(a, b, collision) then return end
    Player:beginContact(a, b, collision)
end

function collisions:endContact(a, b, collision) 
    Player:endContact(a, b, collision)
end

return collisions