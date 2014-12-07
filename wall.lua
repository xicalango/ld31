-- #LD31 - 2014 by <weldale@gmail.com>

Wall = Entity:subclass("Wall")

function Wall:initialize(x, y)
  Entity.initialize( self, x, y )

  self.graphics = Graphics:new("assets/wall.png")
  self.graphics.offset = {20, 20}

  self.hitbox.left = 17
  self.hitbox.right = 17
  self.hitbox.top = 17
  self.hitbox.bottom = 17

  self.isWall = true
end


