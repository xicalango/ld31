-- #LD31 - 2014 by <weldale@gmail.com>

Entity = class("Entity")

function Entity:initialize(x, y)
  self.x = x or 0
  self.y = y or 0

  self.graphics = nil

  self.vx = 0
  self.vy = 0

  self.speed = 200

  self.hitbox = {left = 0, top = 0, right = 0, bottom = 0} 
  
  self.remove = false

  self.isWall = false
  self.isShot = false
end

function Entity:graphicOffsetToHitbox()
  self.hitbox.left = self.graphics.offset[1]
  self.hitbox.right = self.graphics.offset[1]
  self.hitbox.top = self.graphics.offset[2]
  self.hitbox.bottom = self.graphics.offset[2]
end

function Entity:update(dt)

  if vlen(self.vx, self.vy) > 0.01 then
    
    local oldX, oldY = self.x, self.y

    local newX = self.x + (self.vx * self.speed * dt)
    local newY = self.y + (self.vy * self.speed * dt)

    local isObstacle, e = state:isObstacleFor( self, newX, newY )
      
    if not isObstacle then -- this looks ugly as hell..
      self.x = newX
      self.y = newY
    else
      if state:isObstacleFor( self, oldX, newY ) then

        if not state:isObstacleFor( self, newX, oldY ) then
          self.x = newX
          self.y = oldY
        end

      else
        self.x = oldX
        self.y = newY
      end
    end

    local hitting = state:hitsEntityOn( self )

    if hitting then
      self:onCollideWith( hitting )
    end


  end

  

end

function Entity:getHitRectangle(ox, oy)
  ox = ox or self.x
  oy = oy or self.y
  return 
    ox - self.hitbox.left, 
    oy - self.hitbox.top, 
    ox + self.hitbox.right, 
    oy + self.hitbox.bottom
end

function Entity:collidesWith(entity, ox, oy)
  local sx1, sy1, sx2, sy2 = self:getHitRectangle(ox, oy)
  local ox1, oy1, ox2, oy2 = entity:getHitRectangle()

  return intersectRect( sx1, sy1, sx2, sy2, ox1, oy1, ox2, oy2 )
end

function Entity:blocks(e)
  return self.isWall
end

function Entity:onCollideWith( obj )
end

function Entity:onHit(shot)
  self.remove = true
end

function Entity:draw()
  if debug.drawHitboxes then
    local x1, y1, x2, y2 = self:getHitRectangle()
    withColor( {255, 0, 0}, function()
      love.graphics.rectangle( "fill", x1, y1, x2-x1, y2-y1 )
    end)
  end
  
  if self.graphics then
    self.graphics:draw(self.x, self.y)
  end

end

