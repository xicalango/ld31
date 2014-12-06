-- #LD31 - 2014 by <weldale@gmail.com>

Wall = Entity:subclass("Wall")

function Wall:initialize(x, y)
  Entity.initialize( self, x, y )

  self.graphics = Graphics:new("assets/wall.png")
  self.graphics.offset = {20, 20}

  self:graphicOffsetToHitbox()

  self.isWall = true
end


