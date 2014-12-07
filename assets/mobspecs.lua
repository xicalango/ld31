
local mobs = {}

mobs.tower = MobSpec:new( "tower", 0, 3 )

mobs.king = MobSpec:new( "king", 150, 2 )

mobs.queen = MobSpec:new( "queen", 200, 3 )

mobs.bishop = MobSpec:new( "bishop", 200, 3 )

mobs.knight = MobSpec:new( "knight", 250, 2 )

mobs.pawn = MobSpec:new( "pawn", 50, 1 )
mobs.pawn.touchDamage = .5

function mobs.pawn:setup(mob)
  mob.state = "chase"
end


return mobs
