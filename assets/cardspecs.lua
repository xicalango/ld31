
local cardspecs = {}

local unknownImage = love.graphics.newImage("assets/unknown.png")

-- rules

for i = 1, 4 do
  cardspecs["draw" .. tostring(i)] = DrawCardSpec:new( i, { count = 2 } )
  cardspecs["play" .. tostring(i)] = PlayCardSpec:new( i, { count = 2 } )
end

-- mobs

cardspecs.king = MobCardSpec:new( "The King", "A tough enemy.", love.graphics.newImage("assets/mob_king.png"), { mobName="king"} )
cardspecs.pawn = MobCardSpec:new( "The Pawn", "An easy enemy.", love.graphics.newImage("assets/mob_pawn.png"), { mobName="pawn", numRange={1,5} } )

-- weapons

cardspecs.snowballMg = CardSpec:new( "Snowball MG", "weapon", "A MG that shoots snowballs", love.graphics.newImage("assets/crossed_swords.png") )


-- goals

cardspecs.goalEndurance = CardSpec:new( "Endurance", "goal", "Endure 10 rounds after this card was layed out", unknownImage, { count = 2 } )

function cardspecs.goalEndurance:onActivation(card, state)
  card.finishedRounds = 0
end

function cardspecs.goalEndurance:onRoundExit(card, state)
  card.finishedRounds = card.finishedRounds + 1
end

function cardspecs.goalEndurance:checkGoalCondition(card, state)
  return card.finishedRounds >= 10 
end


cardspecs.goalMassacre = CardSpec:new( "Massacre", "goal", "Kill 100 enemys since the beginning of time", unknownImage, { count = 2 } )

function cardspecs.goalMassacre:checkGoalCondition(card, state)
  return state.killedMobs >= 100
end

cardspecs.goalCollateralDamage = CardSpec:new( "Collateral Damage", "goal", "Kill 50 pawns after this card was layed out", unknownImage, {count = 2}  )


cardspecs.goalKingMurderer = CardSpec:new( "King murderer", "goal", "Kill the King. But: Every king is now a champion", unknownImage, {count = 2} )

function cardspecs.goalKingMurderer:onRoundEnter(card, state)
  card.hasKing = false

  for i,m in ipairs(state.world.entities) do
    if m.isMob then
      if m.mobspec.name == "king" then
        card.hasKing = true
        break
      end
    end
  end
end

function cardspecs.goalKingMurderer:checkGoalCondition(card, state)
  return card.hasKing -- had king, survived round
end

return cardspecs
