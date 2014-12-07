-- #LD31 - 2014 by <weldale@gmail.com>

GameOverState = GameState:subclass("GameOverState")

function GameOverState:initialize()
	self.snow_vic = love.graphics.newImage("assets/vic_snow.png")
	self.chess_vic = love.graphics.newImage("assets/vic_chess.png")
end

function GameOverState:draw()
	state:draw()
	
	love.graphics.push()
	
	love.graphics.translate( 80, 80 )
	
	love.graphics.setColor( 255, 255, 255 , 255 )
	love.graphics.rectangle( "fill", 0, 0, 480, 320 )
	
	love.graphics.setColor( 0, 0, 0 , 255 )
	love.graphics.rectangle( "line", 0, 0, 480, 320 )

	love.graphics.setColor( 255, 255, 255 , 255 )
	
	if state.won then
		love.graphics.draw( self.snow_vic, 0, 0 )
	else
		love.graphics.draw( self.chess_vic, 0, 0 )
	end
	
	love.graphics.setColor( 0, 0, 0, 255 )
	love.graphics.printf( "Killed enemies: " .. tostring(state.killedMobs), 70, 200, 360 )
	love.graphics.printf( "Survived rounds: " .. tostring(state.survivedRounds - 1), 70, 230, 360 )
	love.graphics.printf( "To play again press [return]", 70, 260, 360 )
	love.graphics.printf( "To exit press [ESC]", 70, 290, 360 )
	
	love.graphics.pop()
end

function GameOverState:update(dt)

end

function GameOverState:keypressed(key)
	if key == keyconfig.player.esc then
		-- quit
	elseif key == keyconfig.player.accept then
		gameStateManager:changeState(InGameState)
	end
end


