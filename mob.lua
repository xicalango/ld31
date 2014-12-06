-- #LD31 - 2014 by <weldale@gmail.com>

local graphics = {
  king = {
    graphics = Graphics:new("assets/mob_king.png"),
    offset = {20, 20}
  }
}

temp_mobspecs = {
  king = {
    name = "king",
    speed = 100
  }
}

Mob = Entity:subclass("Mob")

function Mob:initialize(x, y, mobspec)
  Entity.initialize( self, x, y )
  self.mobspec = mobspec

  self:initGraphics(mobspec.name)

  self.speed = mobspec.speed
end

function Mob:initGraphics(name)
  local graphicsTemp = graphics[name]
  self.graphics = graphicsTemp.graphics
  self.graphics.offset = graphicsTemp.offset
  self:graphicOffsetToHitbox()
end
