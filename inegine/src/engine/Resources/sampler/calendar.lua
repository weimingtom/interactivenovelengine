--Import
Calendar = {}

function Calendar:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.year = 0;
	self.month = 0;
	self.day = 0;
	self.week = 0;
   
	return o
end

function Calendar:GetYear()
	return self.year;
end

function Calendar:SetYear(year)
	self.year = year;
end

function Calendar:GetMonth()
	return self.month;
end

function Calendar:SetMonth(month)
	self.month = month;
end

function Calendar:GetDay()
	return self.day;
end

function Calendar:SetDay(day)
	self.day = day;
end

function Calendar:GetWeek()
	return self.week;
end

function Calendar:SetWeek(week)
	self.week = week;
end

function Calendar:AdvanceDay()
end

function Calendar:AdvanceYear()
end

function Calendar:AdvanceMonth()
end

function Calendar:AdvanceWeek()
end