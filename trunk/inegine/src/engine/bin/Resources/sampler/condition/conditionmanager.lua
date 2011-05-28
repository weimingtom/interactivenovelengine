ConditionManager = {}

--condition variables
-- Y = year
-- M = month

function ConditionManager:Evaluate(condition)
	local conditionString = "return " .. condition;
	local conditionFunction = assert(loadstring(conditionString));
	return conditionFunction(calendar:GetYear(), calendar:GetMonth());
end