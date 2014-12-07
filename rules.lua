-- #LD31 - 2014 by <weldale@gmail.com>

Rules = class("Rules")

function Rules:initialize()
  self.drawCards = 1
  self.playCards = 1

  self.goal = nil

  self.modifiers = {}
end

function Rules:addGoal(goal)
  if self.goal then
    if goal and self.goal.cardSpec == goal.cardSpec then
      return
    end

    self.goal:onDeactivation()
  end

  self.goal = goal

  if self.goal then
    self.goal:onActivation()
  end
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
  return self.goal and self.goal:checkGoalCondition()
end

function Rules:onRoundEnter()
  for i,v in ipairs(self.modifiers) do
    v:onRoundEnter()
  end

  if self.goal then
    self.goal:onRoundEnter()
  end
end

function Rules:onRoundExit()
  for i,v in ipairs(self.modifiers) do
    v:onRoundExit()

    if v.remove then
      v:onDeactivation()
      table.remove(self.modifiers, i)
    end
  end
  
  if self.goal then
    self.goal:onRoundExit()
    if self.goal.remove then
      self:addGoal(nil)
    end
  end
end
