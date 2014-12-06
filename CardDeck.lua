-- #LD31 - 2014 by <weldale@gmail.com>

CardDeck = class("CardDeck")

function CardDeck:initialize()

  self.drawPile = {}

  self.rubbishPile = {}

  for key, spec in pairs(cardSpecs) do
    for i = 1, spec.count do
      table.insert(self.drawPile, Card:new(key))
    end
  end

  self:shuffle()
end

function CardDeck:shuffle()
  for _ = 1, #self.drawPile * 4 do
    local nr1 = love.math.random(1, #self.drawPile)
    local nr2 = love.math.random(2, #self.drawPile)

    self.drawPile[nr1], self.drawPile[nr2] = self.drawPile[nr2], self.drawPile[nr1]
  end
end

function CardDeck:drawCards(count)
  count = count or 1

  local cards = {}

  for _ = 1, count do
    if #self.drawPile == 0 then
      if #self.rubbishPile == 0 then
        error("Paniq - fire neurons!")
      end

      self.drawPile = self.rubbishPile
      self.rubbishPile = {}
      self:shuffle()
    end

    table.insert(cards, self.drawPile[1])
    table.remove(self.drawPile, 1)
  end

  return cards
end

function CardDeck:addToRubbish(card)
  table.insert(self.rubbishPile, card)
end
