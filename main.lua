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
    key = "loading",
    default = true
}, {
    path = "src.loadScenes.production",
    key = "production"
    
},  {
    path = "src.loadScenes.intro",
    key = "intro"
    
},{
    path = "src.cutscene",
    key = "cutscene"
}, {
    path = "src.game",
    key = "game"
})

scenery:hook(love)

