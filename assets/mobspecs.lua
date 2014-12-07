
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

mobs.queen = MobSpec:new( "queen", 200, 3 )

mobs.bishop = MobSpec:new( "bishop", 200, 3 )
mobs.bishop.updateFn = shootCooldown( {2,6}, .5, {3, 6} )
mobs.bishop.ballpars = BallParameters:new(true)
mobs.bishop.chasing = false

function mobs.bishop:setup(mob)
  mob.pauseCounter = love.math.random(1,3)
end

function mobs.bishop:update(mob, dt)
  self:updateFn(mob, dt)
end

mobs.knight = MobSpec:new( "knight", 250, 2 )

mobs.pawn = MobSpec:new( "pawn", 50, 1 )
mobs.pawn.touchDamage = .5

function mobs.pawn:setup(mob)
  mob.state = "chase"
end


return mobs
