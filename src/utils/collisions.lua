local collision = {}

function collision:beginContact(a, b, collision) 
    Player:beginContact(a, b, collision)
end

function collision:endContact(a, b, collision) 

end

return collision