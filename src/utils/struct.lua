Struct = {}


function Struct:load(world)
    self.map = STI("assets/map/1.lua", { "box2d" })
    self.map:box2d_init(World)
    self.map.layers.solid.visible = false
    self.map.layers.entity.visible = false
    self.map.layers.checkpoints.visible = false
    self.map.layers.cutscene.visible = false

    local tileSetAnim = self.map.tilesets[4]
    self.animatedTiles = {}
    for i, tile in ipairs(tileSetAnim) do
        self.animatedTiles[tile.id] = tile
    end

    self.frame = 0
    self.timer = 0
    self.maxTimer = 0.1
    self.MapWidth = self.map.layers.Base.width * 32
    self.MapHeight = self.map.layers.Base.height * 32
end

function Struct:update(dt)
    if self.timer > self.maxTimer then
        self.frame = self.frame + 1
        self.timer = 0
    end
    self.timer = self.timer + dt
end

function Struct:draw()
    self.map:drawLayer(self.map.layers["BGTiles"])
    self.map:drawLayer(self.map.layers["Base"])
end

