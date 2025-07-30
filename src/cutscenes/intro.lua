local intro = {
    scenes = {

    },
    sceneTexts = {
        ""
    }
}


function intro:load()
    for i = 1, 8 do
        self.scenes = love.graphics.newImage("frame"..i..".png")
    end
end

function intro:update(dt)

end

function intro:draw()

end

return intro