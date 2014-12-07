-- #LD31 - 2014 by <weldale@gmail.com>

TitleState = GameState:subclass("TitleState")

function TitleState:initialize()
	self.htw_logo = love.graphics.newImage("assets/huntTheWumpus_logo.png")
	self.svc_logo = love.graphics.newImage("assets/svc_logo.png")
	self.rules = love.graphics.newImage("assets/rules.png")
	self.space = love.graphics.newImage("assets/press_space.png")
	
	self.blinkTimer = 1
	self.blink = false
end

function TitleState:draw()
	love.graphics.draw( self.svc_logo, 16, 10 )
	love.graphics.draw( self.htw_logo, 430, 340 )
	love.graphics.draw( self.rules, 15, 220 )
	if not self.blink then
		love.graphics.draw( self.space, 412, 242 )
	end
	
	love.graphics.print( "by: ", 400, 345 )
end

function TitleState:update(dt)
	self.blinkTimer = self.blinkTimer - dt
	if self.blinkTimer <= 0 then
		self.blinkTimer = 1
		self.blink = not self.blink
	end
end

function TitleState:keypressed(key)
	if key == keyconfig.player.select then
		gameStateManager:changeState(InGameState)
	end
end


