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
        if c == "category" then self.categoryIndex = i;
        elseif c == "id" then self.idIndex = i;
        elseif c == "name" then self.nameIndex = i;
        elseif c == "price" then self.priceIndex = i;
        elseif c == "icon" then self.iconIndex = i;
        elseif c == "desc" then self.descIndex = i;
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

function ScheduleManager:GetItems(category)
	local scheduleList = {};
    for i=0, self.csv.Count-1 do
        if (category == self.csv:GetString(i, self.categoryIndex)) then
            local schedule = {};
            schedule.category = self.csv:GetString(i, self.categoryIndex);
            schedule.id = self.csv:GetString(i, self.idIndex);
            schedule.text = self.csv:GetString(i, self.nameIndex);
            schedule.price = self.csv:GetString(i, self.priceIndex);
            schedule.icon = self.csv:GetString(i, self.iconIndex);
            schedule.desc = self.csv:GetString(i, self.descIndex);
			table.insert(scheduleList, schedule);
        end
    end
	return scheduleList;
end

function ScheduleManager:GetItem(id)
    for i=0, self.csv.Count-1 do
        if (id == self.csv:GetString(i, self.idIndex)) then
            local schedule = {};
            schedule.category = self.csv:GetString(i, self.categoryIndex);
            schedule.id = self.csv:GetString(i, self.idIndex);
            schedule.text = self.csv:GetString(i, self.nameIndex);
            schedule.price = self.csv:GetString(i, self.priceIndex);
            schedule.icon = self.csv:GetString(i, self.iconIndex);
            schedule.desc = self.csv:GetString(i, self.descIndex);
			return schedule;
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
    local result = "GOLD +5,400\nSTR +10, DEX +10, CON + 10";
    local success = false;

    if (math.random() > 0.5) then
        success = true;
		result = "GOLD +5,400\nSTR +10, DEX +10, CON + 10";
    else
        success = false;
		result = "GOLD +0\nSTR +0, DEX +0, CON + 0";
    end    
    return schedule.text, success, result;
end
