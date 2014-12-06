-- #LD31 - 2014 by <weldale@gmail.com>

CardSpec = class("CardSpec")

function CardSpec:initialize( name, category, desc, img, initPars )
  initPars = initPars or {}
  self.name = name
  self.category = category
  self.img = img
  self.desc = desc or "A random thing"
  self.prob = initPars.prob or 100
  self.effectTime = initPars.effectTime or "room"
end

function CardSpec:onActivation(state)
end

function CardSpec:onDeactivation(state)
end

function CardSpec:onRoomEnter(state)
end

function CardSpec:onRoomExit(state)
end


Card = class("Card")

function Card:initialize(cardSpecName)
  self.cardSpec = cardSpecs[cardSpecName]
end



