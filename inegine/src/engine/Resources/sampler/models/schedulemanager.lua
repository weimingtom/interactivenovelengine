--Import
ScheduleManager = {}

function ScheduleManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
    self.educationCount = 0;
    self.jobCount = 0;
    self.vacationCount = 0;
    self.descIndex = 0;
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

    for i=0, self.csv.Count-1 do
        local c = self.csv:GetString(i, self.categoryIndex);
        if ("edu" == c) then self.educationCount = self.educationCount + 1
        elseif ("job" == c) then self.jobCount = self.jobCount + 1
        elseif ("vac" == c) then self.vacationCount = self.vacationCount + 1
        end
    end
end

function ScheduleManager:GetSchedules(category)
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

function ScheduleManager:GetSchedule(id)
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