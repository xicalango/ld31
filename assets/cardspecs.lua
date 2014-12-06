
local cardspecs = {}

cardspecs.king = CardSpec:new( "The King", "mob", "A tough enemy.", love.graphics.newImage("assets/mob_king.png"),  {prob = 75} )
cardspecs.pawn = CardSpec:new( "The Pawn", "mob", "An easy enemy.", love.graphics.newImage("assets/mob_pawn.png") )

cardspecs.snowballMg = CardSpec:new( "Snowball MG", "weapon", "A MG that shoots snowballs", love.graphics.newImage("assets/crossed_swords.png") )

return cardspecs
