-- #LD31 - 2014 by <weldale@gmail.com>

CardSpec = class("CardSpec")

CardSpec.UNKNOWN_IMAGE = love.graphics.newImage("assets/unknown.png")

function CardSpec:initialize( name, category, desc, img, initPars )
  initPars = initPars or {}
  self.name = name
  self.category = category
  self.img = img
  self.desc = desc or "A random thingy thing"
  self.count = initPars.count or 10
  self.effectTime = initPars.effectTime or "room"
end

function CardSpec:setup(card, state)
end

function CardSpec:onActivation(card, state)
end

function CardSpec:onDeactivation(card, state)
end

function CardSpec:onRoundEnter(card, state)
end

function CardSpec:onRoundExit(card, state)
end

function CardSpec:checkGoalCondition(card, state)
end

function CardSpec:extraText(card, state)
  return ""
end

DrawCardSpec = CardSpec:subclass("DrawCardSpec")

function DrawCardSpec:initialize( num, initpars )
  CardSpec.initialize( self, "Draw " .. tostring(num), "rule", "Draw " .. tostring(num) .. " cards at the beginning of the round.", preloadedImages[num], initpars )
  self.num = num
end

function DrawCardSpec:onActivation( card, state )
  state.rules.drawCards = self.num
end

PlayCardSpec = CardSpec:subclass("PlayCardSpec")

function PlayCardSpec:initialize( num, initpars )
  CardSpec.initialize( self, "Play " .. tostring(num), "rule", "Play " .. tostring(num) .. " cards at the beginning of the round.", preloadedImages[num], initpars )
  self.num = num
end

function PlayCardSpec:onActivation( card, state )
  state.rules.playCards = self.num
end

MobCardSpec = CardSpec:subclass("MobCardSpec")

function MobCardSpec:initialize( name, desc, img, initPars )
  CardSpec.initialize( self, name, "mob", desc, img, initPars )

  self.mobName = initPars.mobName
  self.numRange = initPars.numRange or {1, 1}
end

function MobCardSpec:onActivation(card, state)
  local num = love.math.random( self.numRange[1], self.numRange[2] )
  local cx, cy

  --hacky hack

  local mobName = self.mobName
  
  print(state.kingChamps)

  if self.mobName == "king" and state.kingChamps then
    mobName = "kingChamp"
  end

  for i = 1, num do
    cx, cy = state.world:getNewLocation()
    state.world:addEntityRaw( Mob:new( cx, cy, mobName ) )
  end
end

Card = class("Card")

function Card:initialize(cardSpecName)
  self.name = cardSpecName
  self.cardSpec = cardSpecs[cardSpecName]
  self.cardSpec:setup(self, state)
  self.removeFromHand = false
  self.remove = false
end

function Card:onActivation()
  self.cardSpec:onActivation(self, state)
end

function Card:onDeactivation()
  self.cardSpec:onDeactivation(self, state)
end

function Card:onRoundEnter()
  self.cardSpec:onRoundEnter(self, state)
end

function Card:onRoundExit()
  self.cardSpec:onRoundExit(self, state)
end

function Card:checkGoalCondition()
  return self.cardSpec:checkGoalCondition(self, state)
end

function Card:extraText()
  return self.cardSpec:extraText( self, state )
end
