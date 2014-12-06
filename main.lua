-- #LD31 - 2014 by <weldale@gmail.com>

class = require("lib/middleclass")

require("lib/gamestate")
require("lib/graphics")
require("lib/util")

keyconfig = require("keyconfig")

require("camera")

require("gui")

require("world")

require("card")

cardSpecs = require("assets/cardspecs")

require("entity")
require("snowman")
require("wall")
require("ball")
require("mob")

require("state_ingame")

debug = {
  drawHitboxes = true
}

function love.load()
  gameStateManager = GameStateManager:new()
  gameStateManager:registerState(InGameState)

  gameStateManager:changeState(InGameState)
end

function love.draw()
  gameStateManager:draw()
end

function love.update(dt)
  gameStateManager:update(dt)
end

function love.keypressed(key)
  gameStateManager:keypressed(key)
end

function love.keyreleased(key)
  gameStateManager:keyreleased(key)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

