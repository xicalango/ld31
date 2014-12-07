
local cardspecs = {}

local unknownImage = love.graphics.newImage("assets/unknown.png")

-- rules

for i = 1, 4 do
  cardspecs["draw" .. tostring(i)] = DrawCardSpec:new( i, { count = 2 } )
  cardspecs["play" .. tostring(i)] = PlayCardSpec:new( i, { count = 2 } )
end

-- modifier

cardspecs.split = CardSpec:new( "Split", "modifier", "Splits all enemies in half.", unknownImage, { count = 2 } )

function cardspecs.split:onRoundEnter(card, state)
  for _, e in ipairs(state.world.entities) do
    if e.isMob then
      e:split()
    end
  end
end

function cardspecs.split:onRoundExit(card, state)
  card.remove = true
end

-- mobs

cardspecs.king = MobCardSpec:new( "The King", "A tough enemy.", love.graphics.newImage("assets/mob_king.png"), { mobName="king"} )
cardspecs.pawn = MobCardSpec:new( "The Pawn", "An easy enemy.", love.graphics.newImage("assets/mob_pawn.png"), { mobName="pawn", numRange={1,5} } )

-- weapons

--cardspecs.snowballMg = CardSpec:new( "Snowball MG", "weapon", "A MG that shoots snowballs", love.graphics.newImage("assets/crossed_swords.png") )


-- goals

cardspecs.goalEndurance = CardSpec:new( "Endurance", "goal", "Endure 20 rounds after this card was layed out", unknownImage, { count = 4 } )
cardspecs.goalEndurance.NUM_ROUNDS = 20

function cardspecs.goalEndurance:onActivation(card, state)
  card.finishedRounds = 0
end

function cardspecs.goalEndurance:onRoundExit(card, state)
  card.finishedRounds = card.finishedRounds + 1
end

function cardspecs.goalEndurance:checkGoalCondition(card, state)
  return card.finishedRounds >= cardspecs.goalEndurance.NUM_ROUNDS
end

function cardspecs.goalEndurance:extraText(card, state)
  return tostring(card.finishedRounds) .. " / " .. tostring(cardspecs.goalEndurance.NUM_ROUNDS)
end

cardspecs.goalMassacre = CardSpec:new( "Massacre", "goal", "Kill 100 enemys since the beginning of time", unknownImage, { count = 4 } )

cardspecs.goalMassacre.NUM_KILLS = 100

function cardspecs.goalMassacre:checkGoalCondition(card, state)
  return state.killedMobs >= cardspecs.goalMassacre.NUM_KILLS
end

function cardspecs.goalMassacre:extraText(card, state)
  return tostring(state.killedMobs) .. " / " .. tostring(cardspecs.goalMassacre.NUM_KILLS)
end

cardspecs.goalCollateralDamage = CardSpec:new( "Collateral Damage", "goal", "Kill 50 pawns after this card was layed out", unknownImage, {count = 4}  )
cardspecs.goalCollateralDamage.NUM_PAWNS = 50

function cardspecs.goalCollateralDamage:onActivation(card, state)
  card.killedPawns = 0
end

function cardspecs.goalCollateralDamage:onRoundEnter(card, state)
  card.roundPawns = 0
  for i,m in ipairs(state.world.entities) do
    if m.isMob and m.mobspec.name == "pawn" then
      card.roundPawns = card.roundPawns + 1
    end
  end
end

function cardspecs.goalCollateralDamage:onRoundExit(card, state)
  card.killedPawns = card.killedPawns + card.roundPawns
end

function cardspecs.goalCollateralDamage:checkGoalCondition(card, state)
  return card.killedPawns >= cardspecs.goalCollateralDamage.NUM_PAWNS
end

function cardspecs.goalCollateralDamage:extraText(card, state)
  return tostring(card.killedPawns) .. " / " .. tostring(cardspecs.goalCollateralDamage.NUM_PAWNS)
end

cardspecs.goalKingMurderer = CardSpec:new( "King murderer", "goal", "Kill the King. But: Every king is now a champion", unknownImage, {count = 4} )

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
