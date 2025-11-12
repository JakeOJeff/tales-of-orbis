-- [[ IMPORTING SCENES ]]
-- [DECLARING GLOBAL VARIABLES]
love.graphics.setDefaultFilter("nearest", "nearest")

baseW = 1280
baseH = 720

-- Android/Mobile 
IsMobile = false

wW = love.graphics.getWidth()
wH = love.graphics.getHeight()

-- Global Libs
Baton = require "src.libs.baton"

-- Setting LOVE
LG = love.graphics
LK = love.keyboard
LM = love.mouse
LA = love.audio

-- Set fullscreen for mobile and trigger resize logic
-- if IsMobile and not love.window.getFullscreen() then
--     love.window.setFullscreen(true, "desktop")
-- end

-- Use the minimum scale that fits the full base resolution in screen
scale = math.min(wW / baseW, wH / baseH)

-- Get the scaled screen dimensions
local scaledW = wW / scale
local scaledH = wH / scale

-- Center the base resolution in the scaled screen
cenW = (scaledW - baseW) / 2
cenH = (scaledH - baseH) / 2

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
function scaleGame()
    if game and camera then
        game.scale = scale * 3
        camera:zoomTo(game.scale)
    end
end

function updateFontSize()
    heading = love.graphics.newFont("assets/fonts/nihonium.ttf", 90 * scale)
    subheading = love.graphics.newFont("assets/fonts/nihonium.ttf", 64* scale)
    paragraph = love.graphics.newFont("assets/fonts/nihonium.ttf", 48 * scale)  
    tag = love.graphics.newFont("assets/fonts/nihonium.ttf", 18 * scale)  
end
-- [FONT DECLARATION]
heading = nil
subheading = nil
paragraph = nil
tag = nil
updateFontSize()
-- Input Connections 
Input = Baton.new {
    controls = {
        left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
        right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
        jump = {'key:up', 'key:w', 'key:space', 'axis:lefty-', 'button:dpup'},
        dive = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
        boost = {'key:x', 'key:lshift', 'button:a'},
    },
    joystick = love.joystick.getJoysticks()[1]
}

joysticks = love.joystick.getJoysticks()
Joystick = joysticks[1] or nil
jAxes = {0, 0, 0, 0}

paused = false

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
    key = "a1s1"
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

    --
    -- if wW/wH > 1 then
        scaleGame()
    -- end
    -- camera = Camera(Player.x, Player.y, game.scale)

    -- Reload GUI elements if necessary
    if GUI then
        GUI:load()
        updateFontSize()
    end
end


