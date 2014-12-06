-- #LD31 - 2014 by <weldale@gmail.com>

InGameState = GameState:subclass("InGameState")

InGameState.ROUND_BEGIN_DRAW = "begin_draw"
InGameState.ROUND_BEGIN_PLAY = "begin_play"
InGameState.ROUND_ROUND = "round" -- candidate for best line
InGameState.ROUND_END = "end"

function InGameState:initialize()
  self.camera = Camera:new(0, 0, 480, 480)
  self.camera.bgColor = {255, 255, 255}
  self.viewport = Viewport:new(160, 0, 480, 480)
  self.gui = Gui:new()
  self:reset()
end

function InGameState:onActivation()
  state = self


  self:reset()
end

function InGameState:reset()
  self.snowman = Snowman:new( 240, 240 )

  self.world = World:new()
  self.world:addEntity( self.snowman )
  
  self.deck = CardDeck:new()
  self.cards = self.deck:drawCards(2)

  self.rules = Rules:new()

  self.roundState = InGameState.ROUND_BEGIN_DRAW
end

function InGameState:update(dt)

  if self.roundState == InGameState.ROUND_BEGIN_DRAW then
    local newCards = self.deck:drawCards( self.rules.drawCards )

    for _,v in ipairs(newCards) do
      table.insert( self.cards, v)
    end

    self.roundState = InGameState.ROUND_BEGIN_PLAY
  elseif self.roundState == InGameState.ROUND_BEGIN_PLAY then
    
  elseif self.roundState == InGameState.ROUND_ROUND then
    self.world:update(dt)

  elseif self.roundState == InGameState.ROUND_END then

  else
    error(self.roundState)
  end
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
  if self.roundState == InGameState.ROUND_BEGIN_PLAY then
    self.gui:keypressed(key)
    -- no player movement
  else
    if not self.snowman:keypressed(key) then -- not handled
      self.gui:keypressed(key)
    end
  end
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
