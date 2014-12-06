-- #LD31 - 2014 by <weldale@gmail.com>

CardSpec = class("CardSpec")

function CardSpec:initialize( name, category, desc, initPars )
  self.name = name
  self.category = category
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

local cardSpecs, cardImages = require("assets/cardspecs")

Card = class("Card")

function Card:initialize(cardSpec)
  self.cardSpec = cardSpec
end



