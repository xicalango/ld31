
local mobs = {}

local function shootCooldown( pauseRange, cooldown, shotsRange )
  return function(self, mob, dt)
    if mob.state == "stand" then
      mob.pauseCounter = mob.pauseCounter - dt
      if mob.pauseCounter <= 0 then
        mob.state = "shoot"
        mob.shots = love.math.random(shotsRange[1], shotsRange[2])
      end

    elseif mob.state == "cooldown" then
      mob.cooldown = mob.cooldown - dt
      if mob.cooldown <= 0 then
        mob.state = "shoot"
      end

    elseif mob.state == "shoot" then
      mob.shots = mob.shots - 1

      if mob.shots <= 0 then
        mob.state = "stand"
        mob.pauseCounter = love.math.random(pauseRange[1], pauseRange[2])
      else
        mob.cooldown = cooldown
        mob.state = "cooldown"
      end
    end
  end
end

local function shootCooldownChase( pauseRange, cooldown, shotsRange, chaseProb )
  return function(self, mob, dt)
    if mob.state == "stand" then
      mob.pauseCounter = mob.pauseCounter - dt
      if mob.pauseCounter <= 0 then
        if love.math.random() >= chaseProb then
          mob.state = "shoot"
          mob.shots = love.math.random(shotsRange[1], shotsRange[2])
        else
          mob.state = "chase"
          mob.pauseCounter = love.math.random(pauseRange[1], pauseRange[2])
        end
      end

    elseif mob.state == "chase" then
      mob.pauseCounter = mob.pauseCounter - dt
      if mob.pauseCounter <= 0 then
        mob.pauseCounter = love.math.random(pauseRange[1], pauseRange[2])
        mob.state = "stand"
      end

    elseif mob.state == "cooldown" then
      mob.cooldown = mob.cooldown - dt
      if mob.cooldown <= 0 then
        mob.state = "shoot"
      end

    elseif mob.state == "shoot" then
      mob.shots = mob.shots - 1

      if mob.shots <= 0 then
        mob.state = "stand"
        mob.pauseCounter = love.math.random(pauseRange[1], pauseRange[2])
      else
        mob.cooldown = cooldown
        mob.state = "cooldown"
      end
    end
  end
end

mobs.tower = MobSpec:new( "tower", 0, 3 )

mobs.tower.updateFn = shootCooldown( {2,6}, .5, {3,3} )
mobs.tower.ballpars = BallParameters:new(true)
mobs.tower.ballpars.chasing = true

function mobs.tower:setup(mob)
  mob.pauseCounter = love.math.random(1,3)
  mob.isWall = true
end

function mobs.tower:update(mob, dt)
  self:updateFn(mob, dt)
end

mobs.king = MobSpec:new( "king", 150, 2 )
mobs.king.updateFn = shootCooldownChase( {1,3}, .4, {3, 4}, .5 )
mobs.king.touchDamage = 1
mobs.king.ballpars = BallParameters:new(true)
mobs.king.ballpars.pattern = function(mob, state)
  local phi
  for i = 1, 4 do
    phi = i / 4 * 2 * math.pi
    state:shoot( mob, mob.mobspec.ballpars, toCart( 1, phi ) )
  end
end

function mobs.king:setup(mob)
  mob.pauseCounter = love.math.random(1,1)
end

function mobs.king:update(mob, dt)
  self:updateFn(mob,dt)
end

mobs.kingChamp = MobSpec:new( "kingChamp", 200, 5 )
mobs.kingChamp.defaultTint = { 0, 0, 255, 255 }
mobs.kingChamp.size = 1.5
mobs.kingChamp.updateFn = shootCooldownChase( {.5, 1}, .3, {3, 6}, .5 )
mobs.kingChamp.touchDamage = 1
mobs.kingChamp.ballpars = BallParameters:new(true)
mobs.kingChamp.ballpars.speed = 300
mobs.kingChamp.ballpars.pattern = function(mob, state)
  local phi
  for i = 1, 12 do
    phi = i / 12 * 2 * math.pi
    state:shoot( mob, mob.mobspec.ballpars, toCart( 1, phi ) )
  end
end

function mobs.kingChamp:setup(mob)
  mob.pauseCounter = love.math.random(1,1)
end

function mobs.kingChamp:update(mob, dt)
  self:updateFn(mob,dt)
  self.ballpars.chasing = not self.ballpars.chasing
end

mobs.queen = MobSpec:new( "queen", 200, 3 )
mobs.queen.updateFn = shootCooldownChase( {1,3}, .4, {3, 4}, .5 )
mobs.queen.touchDamage = 1
mobs.queen.ballpars = BallParameters:new(true)
mobs.queen.ballpars.pattern = function(mob, state)
  local phi
  for i = 1, 12 do
    phi = i / 12 * 2 * math.pi
    state:shoot( mob, mob.mobspec.ballpars, toCart( 1, phi ) )
  end
end

function mobs.queen:setup(mob)
  mob.pauseCounter = love.math.random(1,1)
end

function mobs.queen:update(mob, dt)
  self:updateFn(mob,dt)
end

mobs.bishop = MobSpec:new( "bishop", 75, 3 )
mobs.bishop.ballpars = BallParameters:new(true)

function mobs.bishop:setup(mob)
  mob.pauseCounter = love.math.random(1,3)
end

function mobs.bishop:update(mob, dt)
  if mob.state == "stand" then
    mob.state = "chase"

  elseif mob.state == "chase" then
    mob.pauseCounter = mob.pauseCounter - dt
    if mob.pauseCounter <= 0 then
      mob.state = "shoot"
    end

  elseif mob.state == "shoot" then
    mob.pauseCounter = love.math.random(1,3)
    mob.state = "chase"
  end
end

mobs.knight = MobSpec:new( "knight", 100, 2 )

function mobs.knight:setup(mob)
  mob.state = "chase"
end

mobs.pawn = MobSpec:new( "pawn", 50, 1 )
mobs.pawn.touchDamage = .5

function mobs.pawn:setup(mob)
  mob.state = "chase"
end

function mobs.pawn:hitSnowman(mob, snowman)
  mob:die()
end


return mobs
