-- #LD31 - 2014 by <weldale@gmail.com>

local Window = class("Window")

function Window:initialize(w, h, x, y)
  self.w = w
  self.h = h
  self.x = x or 0
  self.y = y or 0

  self.children = {}
  self.border = false
  self.borderColor = {255, 255, 255}
end

function Window:addChildren(child, label)
  if label == nil then
    table.insert(self.children, child)
  else
    self.children[label] = child
  end
  return child
end

function Window:getByLabel(label)
  return self.children[label]
end

function Window:draw(tx, ty)
  tx = tx or 0
  ty = ty or 0
  love.graphics.push()

  love.graphics.translate( self.x, self.y )

  for i,child in pairs(self.children) do
    child:draw(tx + self.x, ty + self.y)
  end
  
  if self.border then
    withColor( self.borderColor, function()
      love.graphics.rectangle( "line", 0, 0, self.w, self.h )
    end)
  end

  love.graphics.pop()
end

function Window:mousepressed(x, y, button)
  for i,child in pairs(self.children) do
    if child.mousepressed then
      child:mousepressed( x - self.x, y - self.y, button )
    end
  end
end

local Icon = class("Icon")

function Icon:initialize(x, y, file)
  self.x = x
  self.y = y
  self.image = love.graphics.newImage(file)
end

function Icon:draw()
  love.graphics.draw( self.image, self.x, self.y )
end

local Label = class("Label")

function Label:initialize(x, y, text)
  self.x = x
  self.y = y
  self.text = text
end

function Label:draw()
  love.graphics.print( self.text, self.x, self.y )
end

local DynamicLabel = class("Label")

function Label:initialize(x, y, textFn)
  self.x = x
  self.y = y
  self.textFn = textFn
end

function Label:draw()
  love.graphics.print( self.textFn(), self.x, self.y )
end

local CardWidget = class("CardWidget")

function CardWidget:initialize(x, y, cardspec)
  self.x = x
  self.y = y
  self.cardspec = cardspec
  self.selected = false
end

function CardWidget:draw()
  
end

Gui = class("Gui")

function Gui:initialize()
  self.window = Window:new( 160, 480, 0, 0 )

  local ballParsWindow = self.window:addChildren( Window:new( 160, 50 ), "ballPars" )

  ballParsWindow:addChildren( Icon:new(5, 5, "assets/crossed_swords.png") )
  ballParsWindow:addChildren( Label:new( 20, 5, function() return state.snowman.weapons[1].pars.dmg end, "ballPowerLabel" ) )
  ballParsWindow:addChildren( Label:new( 60, 5, function() return math.floor(state.snowman.weapons[1].pars.speed / 100) end, "ballSpeedLabel" ) )
  ballParsWindow:addChildren( Label:new( 20, 25, function() return state.snowman.weapons[1].pars.lifeTime end, "ballLifeTimeLabel" ) )
  ballParsWindow:addChildren( Label:new( 60, 25, function() return state.snowman.weapons[1].pars.reload end, "ballReloadLabel" ) )
end

function Gui:draw()
  self.window:draw() 
end

