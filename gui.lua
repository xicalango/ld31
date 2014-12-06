-- #LD31 - 2014 by <weldale@gmail.com>

local upArrowGraphics = love.graphics.newImage("assets/up-arrow.png")
local downArrowGraphics = love.graphics.newImage("assets/down-arrow.png")

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

function Window:keypressed(key)
  for i,child in pairs(self.children) do
    if child.keypressed then
      child:keypressed(key)
    end
  end
end

function Window:draw(tx, ty)
  tx = tx or 0
  ty = ty or 0
  love.graphics.push()

  love.graphics.translate( self.x, self.y )

  for i,child in pairs(self.children) do
    love.graphics.setColor(255,255,255,255)
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

function CardWidget:draw(ox, oy)
  love.graphics.draw(self.cardspec.img)
end

local CardView = class("CardView")

function CardView:initialize(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.numCards = math.floor(self.h / 55)
  self.offset = 1
end

function CardView:draw(ox, oy)
  local startIdx = self.offset
  local endIdx = math.min( startIdx + self.numCards, #(state.cards) )
  
  love.graphics.push()
  love.graphics.translate( 10, 5 )

  for i = startIdx, endIdx do
    local c = state.cards[i]
    love.graphics.setColor( 255, 255, 255, 255 )
    love.graphics.rectangle("fill", 0, 0, self.w - 30, 45)
    
    love.graphics.setColor( 0, 0, 0, 255 )
    love.graphics.rectangle("line", 0, 0, 45, 45)
    love.graphics.draw( c.cardSpec.img, 0, 0 )

    love.graphics.print( c.cardSpec.name, 55, 15 )

    love.graphics.translate( 0, 50 ) 
  end

  love.graphics.pop()

  if self.offset > 1 then
    love.graphics.setColor( 255, 255, 255, 255 )
    love.graphics.draw( upArrowGraphics, 145, 5 ) 
  end
  if self.offset + self.numCards < #state.cards then
    love.graphics.setColor( 255, 255, 255, 255 )
    love.graphics.draw( downArrowGraphics, 145, self.h - 18 ) 
  end

end

function CardView:keypressed(key)
  if key == keyconfig.player.cardsDown then
    self.offset = self.offset + 1
    if self.offset > #state.cards then
      self.offset = #state.cards
    end
  elseif key == keyconfig.player.cardsUp then
    self.offset = self.offset - 1
    if self.offset == 0 then
      self.offset = 1
    end
  end

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

  local cardViewWindow = self.window:addChildren( Window:new( 160, 305, 0, 50 ), "cardView" )
  cardViewWindow.border = true

  cardViewWindow:addChildren( CardView:new(0, 0, 160, 305) )

end

function Gui:draw()
  self.window:draw() 
end

function Gui:keypressed(key)
  self.window:keypressed(key)
end

function Gui:keyreleased(key)
end

