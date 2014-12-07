-- #LD31 - 2014 by <weldale@gmail.com>

local images = {
  tower = love.graphics.newImage("assets/mob_tower.png"),
  king = love.graphics.newImage("assets/mob_king.png"),
  kingChamp = love.graphics.newImage("assets/mob_kingChamp.png"),
  queen = love.graphics.newImage("assets/mob_queen.png"),
  bishop = love.graphics.newImage("assets/mob_bishop.png"),
  knight = love.graphics.newImage("assets/mob_knight.png"),
  pawn = love.graphics.newImage("assets/mob_pawn.png"),
}

MobSpec = class("MobSpec")

function MobSpec:initialize( name, speed, health )
  self.name = name
  self.speed = speed
  self.health = health
  self.touchDamage = 1
  self.defaultTint = {0, 0, 0, 255}
  self.size = 1
end

function MobSpec:setup(mob)
end

function MobSpec:update(mob, dt)
end

function MobSpec:hitSnowman(mob, snowman)
end

local mobspecs = require("assets/mobspecs")

Mob = Entity:subclass("Mob")

function Mob:initialize(x, y, name, size, weaken)
  Entity.initialize( self, x, y )
  self.mobspec = mobspecs[name]

  self.size = size or self.mobspec.size 
  self.weaken = weaken or 1

  self:initGraphics(self.mobspec.name)

  self.speed = self.mobspec.speed
  self.health = math.max( math.floor( self.mobspec.health * self.weaken ), 1 )
  self.touchDamage = math.max( math.floor( 2 * self.mobspec.touchDamage * self.weaken ) / 2, .5 )
  self.isMob = true

  self.state = "stand"

  self.mobspec:setup(self)

  self.hitAnimationTimer = 0
end

function Mob:initGraphics(name)
  self.graphics = Graphics:new(images[name], 20, 20)
  self.graphics.scale = {self.size, self.size}
  self:graphicOffsetToHitbox()
 
  self.graphics.tint = {}
  for i,v in ipairs(self.mobspec.defaultTint) do
    self.graphics.tint[i] = v
  end
end

function Mob:update(dt)
  Entity.update(self, dt)

  if self.state == "stand" then
    self.vx, self.vy = 0, 0
  elseif self.state == "chase" then
    local _, phi = self:dirTo( state.snowman )
    self.vx, self.vy = toCart( 1, phi )
  elseif self.state == "shoot" then
    
    if self.mobspec.ballpars then
      if self.mobspec.ballpars.chasing then
        local _, phi = self:dirTo( state.snowman )
        state:shoot( self, self.mobspec.ballpars, toCart( 1, phi ) ) 
      elseif self.mobspec.ballpars.pattern then
      
        self.mobspec.ballpars.pattern(self, state)

      else
        local phi = love.math.random() * 2 * math.pi
        state:shoot( self, self.mobspec.ballpars, toCart( 1, phi ) )
      end
    end
	
	enemyShootSound:play()

  end

  if self.hitAnimationTimer > 0 then
    self.hitAnimationTimer = self.hitAnimationTimer - dt
  end

  self.mobspec:update(self, dt)
end

function Mob:split()
  
  local x1,y1,x2,y2 = self:getHitRectangle()

  state.world:addEntity( Mob:new( x1 + self.hitbox.left / 2 , y1 + self.hitbox.top / 2, self.mobspec.name, self.size * .5, self.weaken * .5 ) )
  state.world:addEntity( Mob:new( x2 - self.hitbox.right / 2, y2 - self.hitbox.bottom / 2, self.mobspec.name, self.size * .5, self.weaken * .5 ) )

  self.remove = true
end

function Mob:draw()

  if self.hitAnimationTimer > 0 then
    local oldTint = self.graphics.tint[1]
    self.graphics.tint[1] = self.hitAnimationTimer * 255
    Entity.draw(self)
    self.graphics.tint[1] = oldTint
  else
    Entity.draw(self)
  end
  
end

function Mob:die()
  state:addKilledMob(self)
  Entity.die(self)
end

function Mob:onHit(shot)
  if not shot.owner.isMob then
    Entity.onHit(self, shot)
    self.health = self.health - shot.pars.dmg

    self.hitAnimationTimer = 1

    if self.health <= 0 then
      self:die()
    end
  end
end

function Mob:blocks(e)
	return e.isMob or Entity.blocks(self,e)
end

function Mob:onCollideWith(e)
  if e == state.snowman then
    state.snowman:onHit(self)
    self.mobspec:hitSnowman(self, e)
  end
end

