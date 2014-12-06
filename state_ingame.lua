-- #LD31 - 2014 by <weldale@gmail.com>

InGameState = GameState:subclass("InGameState")

function InGameState:initialize()
  self.camera = Camera:new(0, 0, 480, 480)
  self.camera.bgColor = {255, 255, 255}
  self.viewport = Viewport:new(160, 0, 480, 480)

  self.snowman = Snowman:new( 240, 240 )

  self.world = World:new()
  self.world:addEntity( self.snowman )
end

function InGameState:onActivation()
  state = self
end

function InGameState:update(dt)
  self.world:update(dt)
end

function InGameState:draw()
  self.camera:draw( self.viewport, self.world )
end

function InGameState:mousepressed(x, y, button)
   
end

function InGameState:mousereleased(x, y, button)
end

function InGameState:keypressed(key)
  self.snowman:keypressed(key)
end

function InGameState:keyreleased(key)
  self.snowman:keyreleased(key)
end

function InGameState:isObstacleFor( entity, x, y )

  local ex1, ey1, ex2, ey2 = entity:getHitRectangle( x, y ) 
  if not intersectRect( ex1, ey1, ex2, ey2, 40, 40, 440, 440 ) then
    return true, "boundaries"
  end

  for i,e in ipairs(self.world.entities) do
    if e ~= entity then -- don't collide with self

     if entity:collidesWith( e, x, y ) then
      return true, e
     end

    end
  end
  
  return false
end
