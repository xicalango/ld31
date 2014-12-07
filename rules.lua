-- #LD31 - 2014 by <weldale@gmail.com>

Rules = class("Rules")

function Rules:initialize()
  self.drawCards = 1
  self.playCards = 4

  self.goals = {}
  self.numGoals = 1

  self.modifiers = {}
end

function Rules:addGoal(goal)
  table.insert(self.goals, goal)
  if #self.goals > self.numGoals then
    self.goals[1]:onDeactivation()
    table.remove(self.goals, 1)
  end

  goal:onActivation()
end

function Rules:addModifier(modifier)
  table.insert(self.modifiers, modifier)
  
  modifier:onActivation()
end

function Rules:removeModifier(modifier)
  for i,v in ipairs(self.modifiers) do
    if v == modifier then
      v:onDeactivation()
      table.remove(self.modifiers, i)
      break
    end
  end
end

function Rules:checkGoals()
  for _, g in ipairs(self.goals) do
    if g:checkGoalCondition() then
      return true 
    end
  end

  return false
end

function Rules:onRoundEnter()
  for i,v in ipairs(self.goals) do
    v:onRoundEnter()
  end

  for i,v in ipairs(self.modifiers) do
    v:onRoundEnter()
  end
end

function Rules:onRoundExit()
  for i,v in ipairs(self.goals) do
    v:onRoundExit()
  end

  for i,v in ipairs(self.modifiers) do
    v:onRoundExit()
  end
end
