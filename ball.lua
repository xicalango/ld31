-- #LD31 - 2014 by <weldale@gmail.com>

BallParameters = class("BallParameters")

function BallParameters:initialize(mob)
  self.size = 1
  self.dmg = .5
  self.reload = .7
  self.speed = 250
  self.lifeTime = 1
  self.chasing = false

  if mob then
    self.tint = {255, 0, 0, 255}
  else
    self.tint = {255, 255, 255, 255}
  end
end

function BallParameters:clone()
  local bp = BallParameters:new()

  for k,v in pairs(self) do
    bp[k] = v
  end

  for i,v in ipairs(bp.tint) do
    self.tint[i] = v
  end

  return bp
end

Ball = Entity:subclass("Ball")

local ballImage = love.graphics.newImage("assets/ball.png")

function Ball:initialize(owner, x, y, vx, vy, pars)
  Entity.initialize(self, x, y)

  self.startX = x
  self.startY = y

  self.pars = pars

  self.graphics = Graphics:new(ballImage)
  self:initGraphicsAndHitbox()

  self.owner = owner

  self.vx = vx
  self.vy = vy

  self.speed = pars.speed

  self.lifeTime = pars.lifeTime

  self.isShot = true

  self.touchDamage = self.pars.dmg
end

function Ball:initGraphicsAndHitbox()
  self.graphics.scale = {self.pars.size/4, self.pars.size/4}
  self.graphics.offset = {20, 20}
  self.graphics.tint = self.pars.tint
  self:graphicOffsetToHitbox()
end

function Ball:update(dt)
  Entity.update(self, dt)

  self.lifeTime = self.lifeTime - dt

  if self.lifeTime <= 0 then
    self.remove = true
  end

end

function Ball:onCollideWith(e)
  if e ~= self.owner and not e.isShot then
    if type(e) == "table" then
      e:onHit(self)
    end
    self.remove = true
  end
end

