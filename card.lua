-- #LD31 - 2014 by <weldale@gmail.com>

CardSpec = class("CardSpec")

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

MobCardSpec = CardSpec:subclass("MobCardSpec")

function MobCardSpec:initialize( name, desc, img, initPars )
  CardSpec.initialize( self, name, "mob", desc, img, initPars )

  self.mobName = initPars.mobName
  self.numRange = initPars.numRange or {1, 1}
end

function MobCardSpec:onActivation(card, state)
  local num = love.math.random( self.numRange[1], self.numRange[2] )
  local cx, cy

  for i = 1, num do
    cx, cy = state.world:getNewLocation()
    state.world:addEntity( Mob:new( cx, cy, self.mobName ) )
  end
end

Card = class("Card")

function Card:initialize(cardSpecName)
  self.name = cardSpecName
  self.cardSpec = cardSpecs[cardSpecName]
  self.cardSpec:setup(self, state)
  self.removeFromHand = false
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

function Card:checkGoalCondition(card, state)
  self.cardSpec:checkGoalCondition(self, state)
end


