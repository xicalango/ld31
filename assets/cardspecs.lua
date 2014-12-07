
local cardspecs = {}

local unknownImage = love.graphics.newImage("assets/unknown.png")

-- mobs

cardspecs.king = MobCardSpec:new( "The King", "A tough enemy.", love.graphics.newImage("assets/mob_king.png"), { mobName="king"} )
cardspecs.pawn = MobCardSpec:new( "The Pawn", "An easy enemy.", love.graphics.newImage("assets/mob_pawn.png"), { mobName="pawn", numRange={1,5} } )

-- weapons

cardspecs.snowballMg = CardSpec:new( "Snowball MG", "weapon", "A MG that shoots snowballs", love.graphics.newImage("assets/crossed_swords.png") )


-- goals

cardspecs.goalEndurance = CardSpec:new( "Endurance", "goal", "Endure 10 rounds after this card was layed out", unknownImage )

function cardspecs.goalEndurance:onActivation(card, state)
  card.finishedRounds = 0
end

function cardspecs.goalEndurance:onRoundExit(card, state)
  card.finishedRounds = card.finishedRounds + 1
end

function cardspecs.goalEndurance:checkGoalCondition(card, state)
  return card.finishedRounds >= 10 
end


cardspecs.goalMassacre = CardSpec:new( "Massacre", "goal", "Kill 100 enemys since the beginning of time", unknownImage )


cardspecs.goalCollateralDamage = CardSpec:new( "Collateral Damage", "goal", "Kill 50 pawns after this card was layed out", unknownImage )


cardspecs.goalKingMurderer = CardSpec:new( "King murderer", "goal", "Kill the King. But: Every king is now a champion", unknownImage )


return cardspecs
