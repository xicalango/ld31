-- #LD31 - 2014 by <weldale@gmail.com>

Snowman = Entity:subclass("Snowman")

function Snowman:initialize(x, y)
  Entity.initialize( self, x, y )

  self.graphics = Graphics:new("assets/snowman.png")
  self.graphics.offset = {20, 20}

  self:graphicOffsetToHitbox()

  self.goto = {left = false, right = false, up = false, down = false}
  self.shoot = {left = false, right = false, up = false, down = false}

  self.shooting = nil
  self.reloadTimer = 0
  self.ballpars = BallParameters:new()
end

function Snowman:update(dt)
  Entity.update(self, dt)

  if self.shooting then
    if self.reloadTimer <= 0 then
      local sx, sy = dirToCart( self.shooting )
      state:shoot( self, self.ballpars, sx, sy )
      self.reloadTimer = self.ballpars.reload
    end
  end

  if self.reloadTimer > 0 then
    self.reloadTimer = self.reloadTimer - dt
  end
end

function Snowman:keypressed(key)

  if key == keyconfig.player.up then
    self.goto.up = true
  elseif key == keyconfig.player.down then
    self.goto.down = true
  elseif key == keyconfig.player.left then
    self.goto.left = true
  elseif key == keyconfig.player.right then
    self.goto.right = true
  elseif key == keyconfig.player.sup then
    self.shoot.up = true
  elseif key == keyconfig.player.sdown then
    self.shoot.down = true
  elseif key == keyconfig.player.sleft then
    self.shoot.left = true
  elseif key == keyconfig.player.sright then
    self.shoot.right = true
  end

  self:updateGotoState()
  self:updateShootingState()

end

function Snowman:keyreleased(key)
  
  if key == keyconfig.player.up then
    self.goto.up = false
  elseif key == keyconfig.player.down then
    self.goto.down = false
  elseif key == keyconfig.player.left then
    self.goto.left = false
  elseif key == keyconfig.player.right then
    self.goto.right = false
  elseif key == keyconfig.player.sup then
    self.shoot.up = false
  elseif key == keyconfig.player.sdown then
    self.shoot.down = false
  elseif key == keyconfig.player.sleft then
    self.shoot.left = false 
  elseif key == keyconfig.player.sright then
    self.shoot.right = false 
  end

  self:updateGotoState()
  self:updateShootingState()

end

function Snowman:updateShootingState()
  if self.shoot.up then
    self.shooting = "up"
  elseif self.shoot.down then
    self.shooting = "down"
  elseif self.shoot.left then
    self.shooting = "left"
  elseif self.shoot.right then
    self.shooting = "right"
  else
    self.shooting = nil
  end
end

function Snowman:updateGotoState()
  if self.goto.up then
    self.vy = -1
  elseif self.goto.down then
    self.vy = 1
  else
    self.vy = 0
  end

  if self.goto.left then
    self.vx = -1
  elseif self.goto.right then
    self.vx = 1
  else
    self.vx = 0
  end
end
