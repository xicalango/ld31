-- #LD31 - 2014 by <weldale@gmail.com>

Viewport = class("Viewport")

function Viewport:initialize(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h

  self.bgColor = {0, 0, 0}
end

Camera = class("Camera")

function Camera:initialize(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
end

function Camera:draw( viewport, drawable )

  local scaleX = viewport.w / self.w
  local scaleY = viewport.h / self.h

  love.graphics.push()

  love.graphics.scale( scaleX, scaleY )
  
  love.graphics.translate( -self.x, -self.y )
  love.graphics.translate( viewport.x, viewport.y )

  withColor(self.bgColor, function()
    love.graphics.rectangle( "fill", 0, 0, self.w, self.h )
  end)

  drawable:draw()

  love.graphics.pop()

end
