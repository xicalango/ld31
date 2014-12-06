-- #LD31 - 2014 by <weldale@gmail.com>

World = class("World")

function World:initialize()
  self.entities = {}
  self.addEntities = {}
  --self:createWall()
end

function World:createWall()
  for i = 1, 10 do
    local wx, wy = self:unrasterCoordinate( i, 0 )
    self:addEntity( Wall:new( wx, wy ) )
    self:addEntity( Wall:new( wy, wx ) )
    wx, wy = self:unrasterCoordinate( i, 11 )
    self:addEntity( Wall:new( wx, wy ) )
    self:addEntity( Wall:new( wy, wx ) )
  end

  self:addEntity( Wall:new( self:unrasterCoordinate( 0, 0 ) ) )
  self:addEntity( Wall:new( self:unrasterCoordinate( 0, 11 ) ) )
  self:addEntity( Wall:new( self:unrasterCoordinate( 11, 0 ) ) )
  self:addEntity( Wall:new( self:unrasterCoordinate( 11, 11 ) ) )
end

function World:addEntity(e)
  table.insert(self.addEntities, e)
end

function World:unrasterCoordinate(x, y)
  return x * 40 + 20, y * 40 + 20
end

function World:rasterCoordinate(x, y)
  return math.floor((x - 20) / 40), math.floor((y - 20) / 40)
end

function World:update(dt)
  for i,e in ipairs(self.entities) do
    e:update(dt)

    if e.remove then
      table.remove(self.entities, i)
    end
  end

  for _,e in ipairs(self.addEntities) do
    table.insert( self.entities, e )
  end

  self.addEntities = {}
end

function World:draw()
  for i, e in ipairs(self.entities) do
    e:draw()
  end
end
