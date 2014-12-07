-- #LD31 - 2014 by <weldale@gmail.com>

TitleState = GameState:subclass("TitleState")

function TitleState:initialize()
	self.htw_logo = love.graphics.newImage("assets/huntTheWumpus_logo.png")
	self.svc_logo = love.graphics.newImage("assets/svc_logo.png")
end

function TitleState:draw()
	love.graphics.draw( self.svc_logo, 16, 16 )
	love.graphics.draw( self.htw_logo, 430, 340 )
	
	
end

function TitleState:keypressed(key)
	if key == " " then
		setupNewGame()
	end
end


