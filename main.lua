-- [[ IMPORTING SCENES ]]
-- [DECLARING GLOBAL VARIABLES]
wW = love.graphics:getWidth()
wH = love.graphics:getHeight()

-- [INITIALIZING SCENERY]
local SceneryInit = require("src.libs.scenery")
local scenery = SceneryInit(
    {path = "src.loading", key = "loading", default = true},
    {path = "src.cutscene", key = "cutscene"},
    {path = "src.game", key = "game"}
)

scenery:hook(love)




