-- #LD31 - 2014 by <weldale@gmail.com>

InGameState = GameState:subclass("InGameState")

function InGameState:initialize()
  self.camera = Camera:new(0, 0, 480, 480)
  self.camera.bgColor = {255, 255, 255}
  self.viewport = Viewport:new(160, 0, 480, 480)

  self.snowman = Snowman:new( 240, 240 )

  self.world = World:new()
  self.world:addEntity( self.snowman )

  self.gui = Gui:new()

  self.testMob = Mob:new( 160, 160, temp_mobspecs["king"] )
  self.world:addEntity( self.testMob )
end

function InGameState:onActivation()
  state = self
end

function InGameState:update(dt)
  self.world:update(dt)
end

function InGameState:draw()
  self.camera:draw( self.viewport, self.world )
  self.gui:draw()
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
  if ex1 < 0 or ex2 > 480 or ey1 < 0 or ey2 > 480 then
    return true, "boundaries"
  end

  for i,e in ipairs(self.world.entities) do
    if e ~= entity then -- don't collide with self

     if entity:collidesWith( e, x, y ) then
      return e:blocks(entity), e
     end

    end
  end
  
  return false
end

function InGameState:hitsEntityOn( entity, x, y )
  for i,e in ipairs(self.world.entities) do
    if e ~= entity then
      if entity:collidesWith( e, x, y ) then
        return e
      end
    end
  end
  return nil
end

function InGameState:shoot( e, pars, sx, sy )
  self.world:addEntity( Ball:new( e, e.x, e.y, sx, sy, pars, pars ) )
end
