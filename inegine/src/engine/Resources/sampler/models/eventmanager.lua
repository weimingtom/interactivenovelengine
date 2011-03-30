--Import
EventManager = {}

function EventManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function EventManager:Load()
    self.csv = GetCsv("eventlist");
end

function EventManager:GetCategoryCount(category)
	local count = 0;
	for i=0, self.csv.Count-1 do
        local c = self.csv:GetString(i, "category");
        if (category == c) then count = count + 1;
        end
    end
    return count;
end

function EventManager:ExtractItem(i)
    local item = {};
    item.category = self.csv:GetString(i, "category");
    item.id = self.csv:GetString(i, "id");
    item.script = self.csv:GetString(i, "script");
    item.condition = self.csv:GetString(i, "condition");
    return item;
end

function EventManager:GetItems(category)
	local itemList = {};
    for i=0, self.csv.Count-1 do
        if (category == self.csv:GetString(i, "category")) then
			table.insert(itemList, self:ExtractItem(i));
        end
    end
	return itemList;
end

function EventManager:GetItem(id)
    for i=0, self.csv.Count-1 do
        if (id == self.csv:GetString(i, "id")) then
			return self:ExtractItem(i);
        end
    end
end

function EventManager:GetPostEvents()
	local eventList = {}
	local candidates = self:GetItems("post");
	for i,v in ipairs(candidates) do
		if (self:TestCondition(v.condition)) then
			table.insert(eventList, v)
			Trace(v.id .. " true");
		else
			Trace(v.id .. " false");
		end
	end
	return eventList;
end

function EventManager:GetMusumeEvents()
	local eventList = {}
	local candidates = self:GetItems("musume");
	for i,v in ipairs(candidates) do
		if (self:TestCondition(v.condition)) then
			table.insert(eventList, v)
			Trace(v.id .. " true");
		else
			Trace(v.id .. " false");
		end
	end
	return eventList;
end

function EventManager:GetGoddessEvents()
	local eventList = {}
	local candidates = self:GetItems("goddess");
	for i,v in ipairs(candidates) do
		if (self:TestCondition(v.condition)) then
			table.insert(eventList, v)
			Trace(v.id .. " true");
		else
			Trace(v.id .. " false");
		end
	end
	return eventList;
end

function EventManager:TestCondition(condition)
	return ConditionManager:Evaluate(condition);
end