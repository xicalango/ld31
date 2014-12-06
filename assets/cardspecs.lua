
local cardspecs = {}

local unknownImage = love.graphics.newImage("assets/unknown.png")

cardspecs.king = CardSpec:new( "The King", "mob", "A tough enemy.", love.graphics.newImage("assets/mob_king.png"),  {prob = 75} )
cardspecs.pawn = CardSpec:new( "The Pawn", "mob", "An easy enemy.", love.graphics.newImage("assets/mob_pawn.png") )

cardspecs.snowballMg = CardSpec:new( "Snowball MG", "weapon", "A MG that shoots snowballs", love.graphics.newImage("assets/crossed_swords.png") )


cardspecs.goalEndurance = CardSpec:new( "Endurance", "goal", "Endure 10 rounds", unknownImage )
cardspecs.goalMassacre = CardSpec:new( "Massacre", "goal", "Kill 100 enemys.", unknownImage )
cardspecs.goalCollateralDamage = CardSpec:new( "Collateral Damage", "goal", "Kill 50 pawns.", unknownImage )
cardspecs.goalKingMurderer = CardSpec:new( "King murderer", "goal", "Kill the King. But: Every king is now a champion", unknownImage )


return cardspecs
