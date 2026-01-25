
function beginContact(a, b, collision)
    utils.collisions:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    utils.collisions:endContact(a, b, collision)
end

function spawnEntities(args)
    for i, v in ipairs(Struct.map.layers.entity.objects) do
        if v.name == "Fire" then
            Fire.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.name == "Torch" then
            Torch.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.name == "Blackhole" then
            Blackhole.new(v.x + v.width / 2, v.y + v.height / 2, math.random(120, 180), math.random(1, 5))
        elseif v.name == "Block" then
            Block.new(v.x + v.width / 2, v.y + v.height / 2)
        end
    end
end

function spawnOnceEntities()
    for i, v in ipairs(Struct.map.layers.entity.objects) do
        if v.name == "Relic" then
            Relic.new(v.x + v.width / 2, v.y + v.height / 2)
        end
    end
end

function deleteEntities()
    Fire.clear()
    Torch.clear()
    Blackhole.clear()
    Block.clear()
end

function hitCheckpoints()
    for i, v in ipairs(Struct.map.layers.checkpoints.objects) do
        if Player.x > v.x and Player.x < v.x + v.width and Player.y > v.y and Player.y < v.y + v.height then
            if Player.checkpointX == v.x + v.width / 2 and Player.checkpointY == v.y + v.height / 2 then
                return
            end
            GUI.msg:project()
            
            Player.checkpointX = v.x + v.width / 2
            Player.checkpointY = v.y + v.height / 2
        end
    end
end

function cutsceneManager()
    for i, v in ipairs(Struct.map.layers.cutscene.objects) do
        if Player.x > v.x and Player.x < v.x + v.width and Player.y > v.y and Player.y < v.y + v.height then
            if v.started then return end
            game.setScene(v.name)
            print(v.name)
            v.started = true
        end
    end
end