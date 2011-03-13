ConditionManager = {}

function ConditionManager:Evaluate(condition)	--M = month, S = affinity
	local conditionString = "local M, S = ...;\n" 
	conditionString = conditionString .. "return " .. condition;
	local conditionFunction = assert(loadstring(conditionString));
	
	--TODO: temporary
	local affinityTable = {};
	affinityTable.lucy = 80;
	
	return conditionFunction(calendar:GetMonth(), affinityTable);
end