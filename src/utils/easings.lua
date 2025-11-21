
function lerp(a,b,t)
    return a + (b-a)*t
end

function easeOutBack(t)
    local c1 = 1.70158
    local c3 = c1 + 1
    return 1 + c3*(t-1)^3 + c1*(t-1)^2
end

function easeInBack(t)
    local c1 = 1.70158
    local c3 = c1 + 1
    return c3*(t)^3 - c1*(t)^2
end