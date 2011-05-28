--Import
TalkManager = {}

function TalkManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function TalkManager:Load()
    self.csv = GetCsv("talklist");
end

function TalkManager:GetCategoryCount(category)
	local count = 0;
	for i=0, self.csv.Count-1 do
        local c = self.csv:GetString(i, "category");
        if (category == c) then count = count + 1;
        end
    end
    return count;
end

function TalkManager:ExtractItem(i)
    local item = {};
    item.category = self.csv:GetString(i, "category");
    item.id = self.csv:GetString(i, "id");
    item.pic = self.csv:GetString(i, "pic");
    item.name = self.csv:GetString(i, "name");
    item.line = self.csv:GetString(i, "line");
    item.condition = self.csv:GetString(i, "condition");
    return item;
end

function TalkManager:GetItems(category)
	local itemList = {};
    for i=0, self.csv.Count-1 do
        if (category == self.csv:GetString(i, "category")) then
			table.insert(itemList, self:ExtractItem(i));
        end
    end
	return itemList;
end

function TalkManager:GetItem(id)
    for i=0, self.csv.Count-1 do
        if (id == self.csv:GetString(i, "id")) then
			return self:ExtractItem(i);
        end
    end
end

function TalkManager:GetMusumeLine()
	local eventList = {}
	local candidates = self:GetItems("musume");
	for i,v in ipairs(candidates) do
		if (self:TestCondition(v.condition)) then
			table.insert(eventList, v)
		end
	end
	return eventList[math.random(#eventList)];
end

function TalkManager:GetGoddessLine()
	local eventList = {}
	local candidates = self:GetItems("goddess");
	for i,v in ipairs(candidates) do
		if (self:TestCondition(v.condition)) then
			table.insert(eventList, v)
		end
	end
	return eventList[math.random(#eventList)];
end

function TalkManager:TestCondition(condition)
	return ConditionManager:Evaluate(condition);
end