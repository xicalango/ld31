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

function Label:initialize(x, y, w, text)
  self.x = x
  self.y = y
  self.w = w
  self.text = text
end

function Label:draw()
  love.graphics.printf( self.text, self.x, self.y, self.w )
end

local DynamicLabel = class("Label")

function DynamicLabel:initialize(x, y, w, textFn)
  self.x = x
  self.y = y
  self.w = w
  self.textFn = textFn
end

function DynamicLabel:draw()
  love.graphics.printf( self.textFn(), self.x, self.y, self.w )
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

    if self.selectMode then

      if i == self.selection then
        if self.selectedItems[i] then
          love.graphics.setColor( 127, 255, 127, 255 )
        else
          love.graphics.setColor( 0, 255, 255, 255 )
        end

      elseif self.selectedItems[i] then
        love.graphics.setColor( 255, 255, 0, 255 )
      else
        love.graphics.setColor( 255, 255, 255, 255 )
      end

    else
      love.graphics.setColor( 255, 255, 255, 255 )
    end

    love.graphics.rectangle("fill", 0, 0, self.w - 30, 45)
    
    love.graphics.setColor( 0, 0, 0, 255 )
    love.graphics.rectangle("line", 0, 0, 45, 45)
    love.graphics.draw( c.cardSpec.img, 2, 2 )

    love.graphics.printf( c.cardSpec.name, 55, 5, 50 )

    if i == self.selection then
        love.graphics.setColor( 255, 255, 255, 255 )
        love.graphics.rectangle("fill", self.w, 0, 240, 45)
        love.graphics.setColor( 0, 0, 0, 255 )
        love.graphics.rectangle("line", self.w, 0, 240, 45)

        love.graphics.printf(c.cardSpec.desc, self.w + 5, 5, 235 )
    end

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

  if self.selectMode then
    if key == keyconfig.player.up or key == keyconfig.player.sup then -- up
      self.selection = self.selection - 1
      if self.selection <= 0 then
        self.selection = #state.cards
        self.offset = math.max(1, #state.cards - self.numCards)
      end

      if self.selection < self.offset then
        self.offset = self.selection
      end

    elseif key == keyconfig.player.down or key == keyconfig.player.sdown then -- down
      self.selection = self.selection + 1

      if self.selection > #state.cards then
        self.selection = 1
        self.offset = 1
      end

      if self.selection > self.offset + self.numCards then
        self.offset = self.selection - self.numCards
      end

    elseif key == keyconfig.player.select then -- select
      if self.selectedItems[self.selection] then
        self.selectedItems[self.selection] = nil
        self.selectedItemsCount = self.selectedItemsCount - 1
      else
        if self.selectedItemsCount == self.num then
          -- geht ned effekt
        else
          self.selectedItems[self.selection] = true
          self.selectedItemsCount = self.selectedItemsCount + 1
        end
      end
    end
  end

end

function CardView:getSelectedCards()
  local cards = {}
  for i, c in ipairs(state.cards) do
    if self.selectedItems[i] then
      table.insert( cards, c )
    end
  end
  return cards
end

function CardView:setSelectMode(mode, num)
  self.selectMode = mode
  self.num = num or 0

  if self.selectMode == true then
    self.selection = 1
    self.selectedItems = {}
    self.selectedItemsCount = 0
  end
end

Gui = class("Gui")

function Gui:initialize()
  self.window = Window:new( 160, 480, 0, 0 )

  local ballParsWindow = self.window:addChildren( Window:new( 160, 50 ), "ballPars" )

  ballParsWindow:addChildren( Icon:new(5, 5, "assets/crossed_swords.png") )
  ballParsWindow:addChildren( DynamicLabel:new( 20, 5, 20, function() return state.snowman.weapons[1].pars.dmg end, "ballPowerDynamicLabel" ) )
  ballParsWindow:addChildren( DynamicLabel:new( 60, 5, 20, function() return math.floor(state.snowman.weapons[1].pars.speed / 100) end, "ballSpeedDynamicLabel" ) )
  ballParsWindow:addChildren( DynamicLabel:new( 20, 25, 20, function() return state.snowman.weapons[1].pars.lifeTime end, "ballLifeTimeDynamicLabel" ) )
  ballParsWindow:addChildren( DynamicLabel:new( 60, 25, 20, function() return state.snowman.weapons[1].pars.reload end, "ballReloadDynamicLabel" ) )

  local cardViewWindow = self.window:addChildren( Window:new( 160, 255, 0, 50 ), "cardView" )
  cardViewWindow.border = true

  self.cardView = cardViewWindow:addChildren( CardView:new(0, 0, 160, 255) )

  local ruleWindow = self.window:addChildren( Window:new(160, 75, 0, 305) )

  ruleWindow:addChildren( DynamicLabel:new( 5, 5, 70, function() return "Draw: " .. state.rules.drawCards end ) )
  ruleWindow:addChildren( DynamicLabel:new( 75, 5, 70, function() return "Play: " .. state.rules.playCards end ) )

  ruleWindow:addChildren( DynamicLabel:new( 5, 25, 160, function() 
    if state.rules.goal then
      return "Goal: " .. state.rules.goal.cardSpec.name .. " " .. state.rules.goal:extraText()
    else
      return "Goal: none"
    end
  end) )

  ruleWindow:addChildren( DynamicLabel:new( 5, 75, 160, function() return "Killed mobs: " .. tostring(state.killedMobs) end ) )

  local messagesWindow = self.window:addChildren( Window:new( 160, 55, 0, 480 - 55 ), "messages" )
  messagesWindow.border = true
  messagesWindow:addChildren( DynamicLabel:new( 10, 10, 140, function() 
    
    if state.roundState == InGameState.ROUND_BEGIN_PLAY then
      return "Select cards: " .. tostring(self.cardView.selectedItemsCount) .. "/" .. tostring(self.cardView.num)
    elseif state.roundState == InGameState.ROUND_ROUND then
      local mobCount = state.world:mobCount()
      if mobCount == 0 then
        return "Round completed! Press [" .. keyconfig.player.accept  .. "] to end round!"
      else
        return tostring(mobCount) .. " enemies to kill!"
      end
    else
      return ""
    end

  end), "messageLabel")

end

function Gui:setSelectMode(mode, num)
  self.cardView:setSelectMode(mode, num)
end

function Gui:draw()
  self.window:draw() 
end

function Gui:keypressed(key)
  if self.cardView.selectMode then
    if key == keyconfig.player.accept then -- accept
      if self.cardView.selectedItemsCount == self.cardView.num then
        local selectedCards = self.cardView:getSelectedCards()
        self.selectedCardsCallback( selectedCards )
        self:setSelectMode(false)
      else
        -- geht ned
      end

      return true
    end
  end

  self.window:keypressed(key)
  return true
end

function Gui:keyreleased(key)
end

