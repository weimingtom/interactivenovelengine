--Import
ScheduleManager = {}

function ScheduleManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function ScheduleManager:Load()
    self.csv = GetCsv("scheduledata");
end

function ScheduleManager:GetItemCount(category)
	local count = 0;
	for i=0, self.csv.Count-1 do
        local c = self.csv:GetString(i, "category");
        if (category == c) then count = count + 1;
        end
    end
    return count;
end

function ScheduleManager:ExtractItem(i)
    local item = {};
    item.category = self.csv:GetString(i, "category");
    item.id = self.csv:GetString(i, "id");
    item.text = self.csv:GetString(i, "name");
    item.price = self.csv:GetString(i, "price");
    item.icon = self.csv:GetString(i, "icon");
    item.desc = self.csv:GetString(i, "desc");
    item.successani = self.csv:GetString(i, "successani");
    item.failureani = self.csv:GetString(i, "failureani");
    return item;
end

function ScheduleManager:GetItems(category)
	local scheduleList = {};
    for i=0, self.csv.Count-1 do
        if (category == self.csv:GetString(i, "category")) then
			table.insert(scheduleList, self:ExtractItem(i));
        end
    end
	return scheduleList;
end

function ScheduleManager:GetItem(id)
    for i=0, self.csv.Count-1 do
        if (id == self.csv:GetString(i, "id")) then
            local schedule = {};
			return self:ExtractItem(i);
        end
    end
end

function ScheduleManager:SetSelectedSchedules(selectedSchedules)
    self.selectedSchedules = selectedSchedules;
end

function ScheduleManager:GetSelectedSchedules()
    return self.selectedSchedules;
end

function ScheduleManager:ProcessSchedule(id)
    local schedule = self:GetItem(id);
    local result = "";
    local success = false;
    local animation = "";
    if (math.random() > 0.5) then
        success = true;
		result = "GOLD +5,400\nSTR +10, DEX +10, CON + 10";
        animation = schedule.successani;
    else
        success = false;
		result = "GOLD +0\nSTR +0, DEX +0, CON + 0";
        animation = schedule.failureani;
    end    
    return schedule.text, success, result, animation;
end
