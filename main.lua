-- [[ IMPORTING SCENES ]]
-- [DECLARING GLOBAL VARIABLES]
love.graphics.setDefaultFilter("nearest", "nearest")
wW = love.graphics:getWidth()
wH = love.graphics:getHeight()

-- [FONT DECLARATION]
heading = love.graphics.newFont("assets/fonts/nihonium.ttf", 100)
subheading = love.graphics.newFont("assets/fonts/nihonium.ttf", 64)
paragraph = love.graphics.newFont("assets/fonts/nihonium.ttf", 48)
-- Input Connections 
joysticks = love.joystick.getJoysticks()
Joystick = joysticks[1] or nil
jAxes = {0, 0, 0, 0}
-- Android/Mobile 
isMobile = love.system.getOS() == "Android"

-- [INITIALIZING SCENERY]
local SceneryInit = require("src.libs.scenery")
local scenery = SceneryInit({
    path = "src.loading",
    key = "loading",
    default = true
}, {
    path = "src.loadScenes.production",
    key = "production"
    
},  {
    path = "src.loadScenes.title",
    key = "title"
    
},  {
    path = "src.cutscenes.intro",
    key = "intro"
    
}, {
    path = "src.game",
    key = "game"
})

scenery:hook(love)

-- [GLOBAL FUNCTIONS]

function dist(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 - (y2 - y1)^2)
    
end

function distRect(mx, my, x, y, width, height)
    return mx > x and mx < x + width and my > y and my < y + height 
end