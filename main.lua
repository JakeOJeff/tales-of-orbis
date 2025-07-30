-- [[ IMPORTING SCENES ]]
-- [DECLARING GLOBAL VARIABLES]
wW = love.graphics:getWidth()
wH = love.graphics:getHeight()

-- [FONT DECLARATION]
heading = love.graphics.newFont("assets/fonts/nihonium.ttf", 100)

-- [INITIALIZING SCENERY]
local SceneryInit = require("src.libs.scenery")
local scenery = SceneryInit({
    path = "src.loading",
    key = "loading"
}, {
    path = "src.loadScenes.production",
    key = "production"
    
},  {
    path = "src.loadScenes.intro",
    key = "intro",
    default = true
    
},{
    path = "src.cutscene",
    key = "cutscene"
}, {
    path = "src.game",
    key = "game"
})

scenery:hook(love)

-- [GLOBAL FUNCTIONS]

function dist(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 - (y2 - y1)^2)
    
end