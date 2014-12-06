
local cardspecs = {}

cardspecs.king = CardSpec:new( "King", "mob", "A tough enemy.", {prob = 75} )
cardspecs.pawn = CardSpec:new( "Pawn", "mob", "An easy enemy." )

cardspecs.snowballMg = CardSpec:new( "Snowball MG", "weapon", "A MG that shoots snowballs" )

local images = {}

images.king = Graphics:new("assets/mob_king.png", 20, 20)
images.pawn = Graphics:new("assets/mob_pawn.png", 20, 20)
images.snowballMg = Graphics:new("assets/crossed_swords.png", 20, 20)

return cardspecs, images
