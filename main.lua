-- [[ IMPORTING SCENES ]]
-- [DECLARING GLOBAL VARIABLES]
love.graphics.setDefaultFilter("nearest", "nearest")

baseW = 1280
baseH = 720

-- Android/Mobile 
isMobile = love.system.getOS() == "Android"

wW = love.graphics.getWidth()
wH = love.graphics.getHeight()

-- Set fullscreen for mobile and trigger resize logic
if isMobile and not love.window.getFullscreen() then
    love.window.setFullscreen(true, "exclusive")
end

-- Use the minimum scale that fits the full base resolution in screen
scale = math.min(wW / baseW, wH / baseH)

-- Get the scaled screen dimensions
local scaledW = wW / scale
local scaledH = wH / scale

-- Center the base resolution in the scaled screen
cenW = (scaledW - baseW) / 2
cenH = (scaledH - baseH) / 2

-- [FONT DECLARATION]
heading = love.graphics.newFont("assets/fonts/nihonium.ttf", 90 * scale)
subheading = love.graphics.newFont("assets/fonts/nihonium.ttf", 64* scale)
paragraph = love.graphics.newFont("assets/fonts/nihonium.ttf", 48 * scale)
-- Input Connections 
joysticks = love.joystick.getJoysticks()
Joystick = joysticks[1] or nil
jAxes = {0, 0, 0, 0}

paused = false

-- if isMobile then
--         love.window.setFullscreen(true)
-- end

-- Manually call resize logic for correct GUI and canvas scaling
if love.resize then
    love.resize(wW, wH)
end

-- [INITIALIZING SCENERY]
local SceneryInit = require("src.libs.scenery")
local scenery = SceneryInit({
    path = "src.loading",
    key = "loading"
}, {
    path = "src.loadScenes.production",
    key = "production"

}, {
    path = "src.loadScenes.title",
    key = "title"

}, {
    path = "src.cutscenes.intro",
    key = "intro"

}, {
    path = "src.game",
    key = "game",
    default = true
}, 

{
    path = "src.cutscenes.act1_scene1",
    key = "act1_scene1"
}
)

scenery:hook(love)

function love.resize(w, h)
    wW = w
    wH = h
    scale = math.min(wW / baseW, wH / baseH)
    scaledW = wW / scale
    scaledH = wH / scale
    cenW = (scaledW - baseW) / 2
    cenH = (scaledH - baseH) / 2

    -- Reload GUI elements if necessary
    if GUI then
        GUI:load()
    end
end

-- [GLOBAL FUNCTIONS]

function dist(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 - (y2 - y1) ^ 2)

end

function distRect(mx, my, x, y, width, height)
    return mx > x and mx < x + width and my > y and my < y + height
end
function normalizeCoords(x, y)
    return (x / scale) - cenW / scale, (y / scale) - cenH / scale
end
function lerp(a, b, t)
    return a + (b - a) * t
end
