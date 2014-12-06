-- #LD31 - 2014 by <weldale@gmail.com>

CardSpec = class("CardSpec")

function CardSpec:initialize( name, category, desc, img, initPars )
  initPars = initPars or {}
  self.name = name
  self.category = category
  self.img = img
  self.desc = desc or "A random thingy thing"
  self.prob = initPars.prob or 100
  self.effectTime = initPars.effectTime or "room"
end

function CardSpec:setup(card, state)
end

function CardSpec:onActivation(card, state)
end

function CardSpec:onDeactivation(card, state)
end

function CardSpec:onRoomEnter(card, state)
end

function CardSpec:onRoomExit(card, state)
end

function CardSpec:checkGoalCondition(card, state)
end


Card = class("Card")

function Card:initialize(cardSpecName)
  self.cardSpec = cardSpecs[cardSpecName]
  self.cardSpec:setup(self, state)
end

function Card:onActivation()
  self.cardSpec:onActivation(self, state)
end

function Card:onDeactivation()
  self.cardSpec:onDeactivation(self, state)
end

function Card:onRoomEnter()
  self.cardSpec:onRoomEnter(self, state)
end

function Card:onRoomExit()
  self.cardSpec:onRoomExit(self, state)
end

function Card:checkGoalCondition(card, state)
  self.cardSpec:checkGoalCondition(self, state)
end


