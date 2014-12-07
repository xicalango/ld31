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
  self.weapons = { 
    { reloadTimer = 0, pars = BallParameters:new()} 
  }

  self.maxHealth = 3
  self.health = 3

  self.invincible = false
  self.invincibilityTimer = 0

  self.dualShot = false
end

function Snowman:update(dt)
  Entity.update(self, dt)

  if self.shooting then
    for i,w in ipairs(self.weapons) do
      if w.reloadTimer <= 0 then
        local sx, sy = dirToCart( self.shooting )
        if self.dualShot then
          if self.shooting == "left" then
            state:shoot( self, w.pars, sx, sy, 0, -5 )
            state:shoot( self, w.pars, sx, sy, 0, 5 ) 
          elseif self.shooting == "right" then
            state:shoot( self, w.pars, sx, sy, 0, -5 )
            state:shoot( self, w.pars, sx, sy, 0, 5 ) 
          elseif self.shooting == "up" then
            state:shoot( self, w.pars, sx, sy, -5, 0 )
            state:shoot( self, w.pars, sx, sy, 5, 0 ) 
          elseif self.shooting == "down" then
            state:shoot( self, w.pars, sx, sy, -5, 0 )
            state:shoot( self, w.pars, sx, sy, 5, 0 ) 
          end
        else
          state:shoot( self, w.pars, sx, sy )
        end
		
		shootSound:play()

        w.reloadTimer = w.pars.reload
      end
    end
  end

  if self.invincibilityTimer > 0 then
    self.invincibilityTimer = self.invincibilityTimer - dt
    if self.invincibilityTimer <= 0 then
      self.invincible = false
    end
  end

  for i,w in ipairs(self.weapons) do
    if w.reloadTimer > 0 then
      w.reloadTimer = w.reloadTimer - dt
    end
  end
end

function Snowman:draw()
  if self.invincible then
    if math.floor(self.invincibilityTimer * 10) % 2 == 0 then
      Entity.draw(self)
    end
  else
    Entity.draw(self)
  end
end

function Snowman:keypressed(key)

  local handled = false

  if key == keyconfig.player.up then
    self.goto.up = true
    handled = true
  elseif key == keyconfig.player.down then
    self.goto.down = true
    handled = true
  elseif key == keyconfig.player.left then
    self.goto.left = true
    handled = true
  elseif key == keyconfig.player.right then
    self.goto.right = true
    handled = true
  elseif key == keyconfig.player.sup then
    self.shoot.up = true
    handled = true
  elseif key == keyconfig.player.sdown then
    self.shoot.down = true
    handled = true
  elseif key == keyconfig.player.sleft then
    self.shoot.left = true
    handled = true
  elseif key == keyconfig.player.sright then
    self.shoot.right = true
    handled = true
  end

  self:updateGotoState()
  self:updateShootingState()

  return handled
end

function Snowman:keyreleased(key)
 
  local handled = false

  if key == keyconfig.player.up then
    self.goto.up = false
    handled = true
  elseif key == keyconfig.player.down then
    self.goto.down = false
    handled = true
  elseif key == keyconfig.player.left then
    self.goto.left = false
    handled = true
  elseif key == keyconfig.player.right then
    self.goto.right = false
    handled = true
  elseif key == keyconfig.player.sup then
    self.shoot.up = false
    handled = true
  elseif key == keyconfig.player.sdown then
    self.shoot.down = false
    handled = true
  elseif key == keyconfig.player.sleft then
    self.shoot.left = false 
    handled = true
  elseif key == keyconfig.player.sright then
    self.shoot.right = false 
    handled = true
  end

  self:updateGotoState()
  self:updateShootingState()

  return handled
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

function Snowman:onHit(e)
  if self.invincible then
    return
  end

  Entity.onHit(self, e)

  self:decreaseHealth(e.touchDamage)
end

function Snowman:decreaseHealth(amt)
    self.health = self.health - amt

    if self.health <= 0 then
      state:gameOver(false)
    end

    self.invincibilityTimer = 1
    self.invincible = true
end
