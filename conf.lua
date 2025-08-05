function love.conf(t)
    t.window.width = 1280
    t.window.height = 720
    t.window.fullscreen = love.system.getOS() == "Android"
    t.window.fullscreentype = "exclusive" -- Or "desktop" if you want it windowed fullscreen
    t.console = false
    -- t.window.resizable = true
    t.window.usedpiscale = false
    t.externalstorage = true
end
