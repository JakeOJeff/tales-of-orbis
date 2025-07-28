-- [[ IMPORTING SCENES ]]

-- [INITIALIZING SCENERY]
local SceneryInit = require("libs.scenery")
local scenery = SceneryInit(
    {path = "scenes.loading", key = "loading", default = true},
    {path = "scenes.cutscene", key = "cutscene"},
    {path = "scenes.game", key = "game"}
)
scenery:hook(love)

