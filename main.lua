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
require("carddeck")
require("rules")

cardSpecs = require("assets/cardspecs")

require("entity")
require("snowman")
require("wall")
require("ball")
require("mob")

require("state_ingame")

debug = {
  drawHitboxes = false
}

global = {
  takeScreenshot = false,
  fullscreen = false
}

function love.load()
  gameStateManager = GameStateManager:new()
  gameStateManager:registerState(InGameState)

  gameStateManager:changeState(InGameState)
  
  roundRng = love.math.newRandomGenerator()
end

function love.draw()
  gameStateManager:draw()

  if global.takeScreenshot then
    local screenshot = love.graphics.newScreenshot()
		screenshot:encode( "ld31_" .. love.timer.getTime() .. ".png" )
    global.takeScreenshot = false
  end
end

function love.update(dt)
  gameStateManager:update(dt)
end

function love.keypressed(key)
  if key == "f12" then
    global.takeScreenshot = true
    elseif key == "f5" then
      if love.window.setFullscreen(not global.fullscreen, "desktop") then
      global.fullscreen = not global.fullscreen
    end
  elseif key == "escape" then
    love.event.push('quit')
  end

  gameStateManager:keypressed(key)
end

function love.keyreleased(key)
  gameStateManager:keyreleased(key)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

