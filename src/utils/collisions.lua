local collisions = {}

function collisions:beginContact(a, b, collision) 
    Player:beginContact(a, b, collision)
end

function collisions:endContact(a, b, collision) 
    Player:endContact(a, b, collision)
end

return collisions