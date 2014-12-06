-- #LD31 - 2014 by <weldale@gmail.com>

class = require("lib/middleclass")

require("lib/gamestate")
require("lib/graphics")
require("lib/util")

keyconfig = require("keyconfig")

require("camera")

require("world")

require("entity")
require("snowman")
require("wall")

require("state_ingame")

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

