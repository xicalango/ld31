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


require("entity")
require("snowman")
require("wall")
require("ball")
require("mob")

require("state_ingame")
require("state_title")
require("state_gameover")

debug = {
  drawHitboxes = false,
  cheats = true
}

global = {
  takeScreenshot = false,
  fullscreen = false
}


function love.load()
  preloadedImages = {}
  preloadedImages.unknownImage = love.graphics.newImage( "assets/unknown.png" )
  preloadedImages[1] = love.graphics.newImage( "assets/1.png" )
  preloadedImages[2] = love.graphics.newImage( "assets/2.png" )
  preloadedImages[3] = love.graphics.newImage( "assets/3.png" )
  preloadedImages[4] = love.graphics.newImage( "assets/4.png" )
  
  cardSpecs = require("assets/cardspecs")

  gameStateManager = GameStateManager:new()
  gameStateManager:registerState(InGameState)
  gameStateManager:registerState(TitleState)
  gameStateManager:registerState(GameOverState)

  gameStateManager:changeState(TitleState)
  
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

