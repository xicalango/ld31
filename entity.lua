-- #LD31 - 2014 by <weldale@gmail.com>

Entity = class("Entity")

function Entity:initialize(x, y)
  self.x = x or 0
  self.y = y or 0

  self.graphics = nil

  self.vx = 0
  self.vy = 0

  self.remove = false
end

function Entity:update(dt)
end

function Entity:draw()
  if self.graphics then
    self.graphics:draw(self.x, self.y)
  end
end

