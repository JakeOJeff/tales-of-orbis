
local loading = {
    imgs = {
        love.graphics.newImage("assets/vfx/loading/light_load.png"),
        love.graphics.newImage("assets/vfx/loading/night_load.png")
    }
}



function loading:load()

end

function loading:update(dt)

end

function loading:draw()
    love.graphics.draw(loading.imgs[1], 0, 0)
end

return loading