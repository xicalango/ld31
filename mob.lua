-- #LD31 - 2014 by <weldale@gmail.com>

local graphics = {
  tower = love.graphics.newImage("assets/mob_tower.png"),
  king = love.graphics.newImage("assets/mob_king.png"),
  queen = love.graphics.newImage("assets/mob_queen.png"),
  bishop = love.graphics.newImage("assets/mob_bishop.png"),
  knight = love.graphics.newImage("assets/mob_knight.png"),
  pawn = love.graphics.newImage("assets/mob_pawn.png"),
}

local mobspecs = require("assets/mobspecs")

Mob = Entity:subclass("Mob")

function Mob:initialize(x, y, name)
  Entity.initialize( self, x, y )
  self.mobspec = mobspecs[name]

  self:initGraphics(self.mobspec.name)

  self.speed = self.mobspec.speed
  self.health = self.mobspec.health
end

function Mob:initGraphics(name)
  self.graphics = Graphics:new(graphics[name], 20, 20)
  self:graphicOffsetToHitbox()
  
  self.graphics.tint = self.mobspec.defaultTint
end

function Mob:onHit(shot)
  Entity.onHit(self, shot)
  self.health = self.health - shot.pars.dmg

  if self.health <= 0 then
    self:die()
  end
end

