Menu = {}
Menu.__index = Menu
Menus = {}

function Menu:new()
    local self = setmetatable({}, Menu)


    table.insert(Menus, self)
    return self
end

function Menu:add(text, func)
    table.insert(self, {text = text, func = func})
end


return Menu