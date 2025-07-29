local loading = {
    imgs = {love.graphics.newImage("assets/vfx/loading/light_load.png"),
            love.graphics.newImage("assets/vfx/loading/night_load.png")},
    loaded = 0, -- In percentages
    text = "loading."
}

function loading:load()

end

function loading:update(dt)
    print("dt:", dt, "loaded:", loading.loaded)

    loading.loaded = loading.loaded + (5 * dt)

    if loading.loaded > 120 then
        loading.setScene("game")
    elseif loading.loaded > 100 then
        loading.text = "loaded."
    end
end

function loading:draw()
    love.graphics.draw(loading.imgs[1], 0, 0)

    love.graphics.setScissor(0, 0, wW, loading.loaded / 100 * wH)
    love.graphics.draw(loading.imgs[2], 0, 0)
    love.graphics.setScissor()

    love.graphics.setFont(heading)
    love.graphics.print(loading.text, wW/2 - heading:getWidth(loading.text)/2, wH/2 - heading:getHeight()/2)
end

return loading
