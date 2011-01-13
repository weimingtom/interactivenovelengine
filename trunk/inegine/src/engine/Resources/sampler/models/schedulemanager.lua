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
    for i=0, self.csv.ColumnCount-1 do
        local c = self.csv:GetColumn(i);
        Trace("c == " .. c);
        if c == "category" then self.categoryIndex = i;
        elseif c == "id" then self.idIndex = i;
        elseif c == "name" then self.nameIndex = i;
        elseif c == "price" then self.priceIndex = i;
        elseif c == "icon" then self.iconIndex = i;
        elseif c == "desc" then self.descIndex = i;
        elseif c == "successani" then self.successIndex = i;
        elseif c == "failureani" then self.failureIndex = i;
        else 
            Trace(c .. " does not match anything");
        end
    end
end

function ScheduleManager:GetItemCount(category)
	local count = 0;
	for i=0, self.csv.Count-1 do
        local c = self.csv:GetString(i, self.categoryIndex);
        if (category == c) then count = count + 1;
        end
    end
    return count;
end

function ScheduleManager:ExtractItem(i)
    local item = {};
    item.category = self.csv:GetString(i, self.categoryIndex);
    item.id = self.csv:GetString(i, self.idIndex);
    item.text = self.csv:GetString(i, self.nameIndex);
    item.price = self.csv:GetString(i, self.priceIndex);
    item.icon = self.csv:GetString(i, self.iconIndex);
    item.desc = self.csv:GetString(i, self.descIndex);
    item.successani = self.csv:GetString(i, self.successIndex);
    item.failureani = self.csv:GetString(i, self.failureIndex);
    return item;
end

function ScheduleManager:GetItems(category)
	local scheduleList = {};
    for i=0, self.csv.Count-1 do
        if (category == self.csv:GetString(i, self.categoryIndex)) then
			table.insert(scheduleList, self:ExtractItem(i));
        end
    end
	return scheduleList;
end

function ScheduleManager:GetItem(id)
    for i=0, self.csv.Count-1 do
        if (id == self.csv:GetString(i, self.idIndex)) then
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
