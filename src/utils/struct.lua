Struct = {}


function Struct:load(world)
    self.map = STI("assets/map/1.lua", { "box2d" })
    self.map:box2d_init(World)
    self.map.layers.solid.visible = false
    self.map.layers.entity.visible = false
    self.map.layers.checkpoints.visible = false
    self.map.layers.cutscene.visible = false

    self.MapWidth = self.map.layers.Base.width * 32
    self.MapHeight = self.map.layers.Base.height * 32
end

function Struct:update(dt)
    self.map:update(dt)

end

function Struct:draw()
    self.map:drawLayer(self.map.layers["BGTiles"])
    self.map:drawLayer(self.map.layers["Base"])
    -- local normalLayer = self.map.layers["TreeNormal"]
    -- if normalLayer and normalLayer.image then
    --     DarknessShader:send("normalMap", normalLayer.image)
    -- end

    -- Draw Tree layer (this one uses the shader)
    self.map:drawLayer(self.map.layers["Tree"])
end

