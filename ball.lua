-- #LD31 - 2014 by <weldale@gmail.com>

BallParameters = class("BallParameters")

function BallParameters:initialize()
  self.size = 1
  self.dmg = 1
  self.reload = .7
  self.speed = 250
  self.lifeTime = 1
end

Ball = Entity:subclass("Ball")

local ballGraphics = Graphics:new("assets/ball.png")

function Ball:initialize(owner, x, y, vx, vy, pars)
  Entity.initialize(self, x, y)

  self.startX = x
  self.startY = y

  self.pars = pars

  self.graphics = ballGraphics

  self:initGraphicsAndHitbox()

  self.owner = owner

  self.vx = vx
  self.vy = vy

  self.speed = pars.speed

  self.lifeTime = pars.lifeTime

  self.isShot = true
end

function Ball:initGraphicsAndHitbox()
  self.graphics.scale = {self.pars.size/2, self.pars.size/2}
  self.graphics.offset = {20, 20}
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

