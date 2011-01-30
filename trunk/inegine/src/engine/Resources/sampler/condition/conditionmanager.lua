ConditionManager = {}

function ConditionManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	return o
end

function ConditionManager:Init(calendar, character)
	self.flagtable = {};
	self.calendar = calendar;
	self.character = character;
end

function ConditionManager:Evaluate(condition)
	return false;
end