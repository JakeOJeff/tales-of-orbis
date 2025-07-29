
local loading = {
    imgs = {
        love.graphics.newImage("assets/vfx/loading/light_load.png"),
        love.graphics.newImage("assets/vfx/loading/night_load.png")
    },
    loaded = 0 -- In percentages
}



function loading:load()

end

function loading:update(dt)
        print("dt:", dt, "loaded:", loading.loaded)

    loading.loaded = loading.loaded + (1 * dt)

    if loading.loaded > 100 then
        loading.setScene("game")
    end
end

function loading:draw()
    love.graphics.draw(loading.imgs[1], 0, 0)

    love.graphics.setScissor(0, 0, wW, loading.loaded * wH)
    love.graphics.draw(loading.imgs[2], 0, 0)
    love.graphics.setScissor()
end

return loading