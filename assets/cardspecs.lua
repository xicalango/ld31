
local cardspecs = {}

local unknownImage = love.graphics.newImage("assets/unknown.png")

-- rules/actions

for i = 1, 4 do
  cardspecs["draw" .. tostring(i)] = DrawCardSpec:new( i, { count = 4 } )
  cardspecs["play" .. tostring(i)] = PlayCardSpec:new( i, { count = 4 } )
end

cardspecs.hpup = CardSpec:new( "The Heart++", "action", "Increases maximum hitpoints by one.", love.graphics.newImage("assets/heart_plus.png"), { count = 3 } )

function cardspecs.hpup:onActivation(card, state)
  state.snowman.maxHealth = state.snowman.maxHealth + 1
end

cardspecs.heal = CardSpec:new( "The Heart", "action", "Heals you fully.", love.graphics.newImage("assets/heart_big.png"), { count = 4 } )

function cardspecs.heal:onActivation(card, state)
  state.snowman.health = state.snowman.maxHealth
end

cardspecs.hpdown = CardSpec:new( "Radioactive waste", "action", "Decreases maximum hitpoints by one.", love.graphics.newImage("assets/radioactive.png"), { count = 3 } )

function cardspecs.hpdown:onActivation(card, state)
  state.snowman.maxHealth = math.max(state.snowman.maxHealth - 1, 1)
  if state.snowman.health > state.snowman.maxHealth then
    state.snowman.health = state.snowman.maxHealth
  end
end

cardspecs.damage = CardSpec:new( "Biological waste", "action", "Deals one damage to you.", love.graphics.newImage("assets/biohazard.png"), { count = 4 } )

function cardspecs.heal:onActivation(card, state)
  state.snowman.health = math.max(state.snowman.health - 1, .5)
end

cardspecs.wall = CardSpec:new( "The Wall", "action", "Builds 1 to 4 random walls.", love.graphics.newImage("assets/wall.png"), { count = 4 } )

function cardspecs.wall:onActivation(card, state)
  local num = love.math.random(1,4)

  for i = 1, num do
    local px, py = state.world:getNewLocation()
    state.world:addEntityRaw( Wall:new( px, py ) )
  end
end

-- modifier

cardspecs.split = CardSpec:new( "Gemini", "modifier", "Splits all enemies in half.", love.graphics.newImage("assets/gemini.png"), { count = 4 } )

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

cardspecs.dualShot = CardSpec:new( "Cancer", "modifier", "Dual shot.", love.graphics.newImage("assets/cancer.png"), { count = 4 } )

function cardspecs.dualShot:onActivation(card, state)
  state.snowman.dualShot = true
end

function cardspecs.dualShot:onDeactivation(card, state)
  state.snowman.dualShot = false
end

function cardspecs.dualShot:onRoundExit(card, state)
  card.remove = true
end

-- mobs

cardspecs.king = MobCardSpec:new( "The King", "Spawns King Douche.", love.graphics.newImage("assets/mob_king.png"), { mobName="king", count = 4 } )
cardspecs.queen = MobCardSpec:new( "The Queen", "Spawns Queen Douche.", love.graphics.newImage("assets/mob_queen.png"), { mobName="queen", count = 4 }  )
cardspecs.pawn = MobCardSpec:new( "The Pawn", "Spawns 1 to 5 pawns.", love.graphics.newImage("assets/mob_pawn.png"), { mobName="pawn", numRange={1,5}, count = 6 } )
cardspecs.tower = MobCardSpec:new( "The Tower", "Spawns 1 or 2 towers.", love.graphics.newImage("assets/mob_tower.png"), { mobName="tower", numRange={1,2}, count = 5 } )
cardspecs.bishop = MobCardSpec:new( "The Bishop", "Spawns 1 to 3 bishops.", love.graphics.newImage("assets/mob_bishop.png"), { mobName="bishop", numRange={1,3}, count = 5 } )
cardspecs.knight = MobCardSpec:new( "The Knight", "Spawns 1 or 2 knights.", love.graphics.newImage("assets/mob_knight.png"), { mobName="knight", numRange={1,2}, count = 5 } )

-- weapons

cardspecs.snowballMg = WeaponCardSpec:new( "Snowball MG", "Rapid fire!", unknownImage ) 

cardspecs.snowballMg.ballPars.size = .5
cardspecs.snowballMg.ballPars.dmg = .2
cardspecs.snowballMg.ballPars.reload = .1
cardspecs.snowballMg.ballPars.speed = 300

cardspecs.yellowSnow = WeaponCardSpec:new( "Yellow snow", "Never eat it!", unknownImage ) 

cardspecs.yellowSnow.ballPars.size = 1.2
cardspecs.yellowSnow.ballPars.dmg = 1
cardspecs.yellowSnow.ballPars.reload = 1.3
cardspecs.yellowSnow.ballPars.speed = 300
cardspecs.yellowSnow.ballPars.tint = { 255, 255, 0, 255 }

cardspecs.brownSnow = WeaponCardSpec:new( "Brown snow", "Ieks!", unknownImage ) 

cardspecs.brownSnow.ballPars.size = 1.7
cardspecs.brownSnow.ballPars.dmg = 1.5
cardspecs.brownSnow.ballPars.reload = 1.7
cardspecs.brownSnow.ballPars.speed = 100
cardspecs.brownSnow.ballPars.tint = { 127, 127, 0, 255 }

-- weaponmods

cardspecs.wpnSpeedUp = WeaponModCardSpec:new( "Shot speed up", "Snowball speed up", love.graphics.newImage("assets/black_club.png"), {action = function(w) w.speed = w.speed + 25 end, count = 3} )  
cardspecs.wpnReloadDown = WeaponModCardSpec:new( "Reload down", "Snowball reload time down", love.graphics.newImage("assets/black_diamond.png"), {action = function(w) w.reload = w.reload - .1 end, count = 3} )  
cardspecs.wpnRangeUp = WeaponModCardSpec:new( "Range up", "Snowball range up", love.graphics.newImage("assets/black_spade.png"), {action = function(w) w.lifeTime = w.lifeTime + .1 end, count = 3} )  

cardspecs.wpnSpeedDown = WeaponModCardSpec:new( "Shot speed down", "Snowball speed down", love.graphics.newImage("assets/white_club.png"), {action = function(w) w.speed = w.speed - 25 end, count = 3} )  
cardspecs.wpnReloadUp = WeaponModCardSpec:new( "Reload up", "Snowball reload time up", love.graphics.newImage("assets/white_diamond.png"), {action = function(w) w.reload = w.reload + .1 end, count = 3} )  
cardspecs.wpnRangeDown = WeaponModCardSpec:new( "Range down", "Snowball range down", love.graphics.newImage("assets/white_spade.png"), {action = function(w) w.lifeTime = w.lifeTime - .1 end, count = 3} )  

-- goals

cardspecs.goalEndurance = CardSpec:new( "Endurance", "goal", "Endure 10 rounds after this card was layed out", love.graphics.newImage("assets/watch.png"), { count = 2 } )
cardspecs.goalEndurance.NUM_ROUNDS = 10

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

cardspecs.goalMassacre = CardSpec:new( "Massacre", "goal", "Kill 50 enemys since the beginning of time", love.graphics.newImage("assets/massacre.png"), { count = 2 } )

cardspecs.goalMassacre.NUM_KILLS = 50

function cardspecs.goalMassacre:checkGoalCondition(card, state)
  return state.killedMobs >= cardspecs.goalMassacre.NUM_KILLS
end

function cardspecs.goalMassacre:extraText(card, state)
  return tostring(state.killedMobs) .. " / " .. tostring(cardspecs.goalMassacre.NUM_KILLS)
end

cardspecs.goalCollateralDamage = CardSpec:new( "Collateral Damage", "goal", "Kill 25 pawns after this card was layed out", love.graphics.newImage("assets/collateralDamage.png"), {count = 2}  )
cardspecs.goalCollateralDamage.NUM_PAWNS = 25

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

cardspecs.goalKingMurderer = CardSpec:new( "King murderer", "goal", "Kill the King. But: Every king is now a champion", love.graphics.newImage("assets/kingKill.png"), {count = 2} )

function cardspecs.goalKingMurderer:onActivation(card, state)
  state.kingChamps = true
end

function cardspecs.goalKingMurderer:onDeactivation(card, state)
  state.kingChamps = false
end

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

cardspecs.goalRevolution = CardSpec:new( "Viva la revolution", "goal", "Kill the King and the Queen but no pawns.", love.graphics.newImage("assets/revolution.png"), {count = 2} )

function cardspecs.goalRevolution:onActivation(card, state)
  card.killedKing = false
  card.killedQueen = false
end

function cardspecs.goalRevolution:onRoundEnter(card, state)
  card.hasKing = false
  card.hasQueen = false
  card.hasPawns = false

  for i,m in ipairs(state.world.entities) do
    if m.isMob then
      if m.mobspec.name == "king" then
        card.hasKing = true
      elseif m.mobspec.name == "queen" then
        card.hasQueen = true
      elseif m.mobspec.name == "pawn" then
        card.hasPawns = true
      end
    end
  end

end

function cardspecs.goalRevolution:onRoundExit(card, state)
  if card.hasPawns then
    card.remove = true
  end

  if card.hasKing then
    card.killedKing = true
  end

  if card.hasQueen then
    card.killedQueen = true
  end
end

function cardspecs.goalRevolution:checkGoalCondition(card, state)
  return card.killedKing and card.killedQueen -- killed king & queen, survived round
end

function cardspecs.goalRevolution:extraText(card, state)
  local desc = "Left: "
  
  if not card.killedKing then
    desc = desc .. "King "
  end
  
  if not card.killedQueen then
    desc = desc .. "Queen "
  end
  return desc
end

return cardspecs

