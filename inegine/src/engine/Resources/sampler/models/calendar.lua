--Import
Calendar = {}
-- 2012³âÀÌ À°¼º 0³â, ¿Õ±¹·Â 314³â
function Calendar:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.year = 0;
	self.month = 0;
	self.day = 0;

    self.modifier = 0;
    self.weekLength = 7;
    self.weekNumber = 4;

	return o
end

function Calendar:SetModifier(modifier)
    self.modifier = modifier;
end

function Calendar:SetWeekLength(days)
    self.weekLength = days;
end

function Calendar:SetWeekNumber(weeks)
    self.weekNumber = weeks;
end

function Calendar:SetDate(year, month, day)
    self.year = year;
    self.month = month;
    self.day = day;
end

function Calendar:GetYear()
	return self.year;
end

function Calendar:GetWordMonth()
	return self.month;
end

function Calendar:GetMonth()
	return self.month;
end

function Calendar:GetDay()
	return self.day;
end

function Calendar:GetWeek()
    return math.min(self.weekNumber, math.ceil(self.day/self.weekLength));
end

function Calendar:SetWeek(week)
    self.day = self:GetWeekDay(week);
end

function Calendar:GetWeekDay(week)
    return (math.min(self.weekNumber, week) - 1) * self.weekLength + 1;
end

function Calendar:GetWeekLength(week)
    
    if (week == nil) then week = self:GetWeek() end

    if (week < self.weekNumber) then
        return self:GetWeekDay(week + 1) - self:GetWeekDay(week); 
    else
        return self:get_days_in_month(self.month, self.year) - self:GetWeekDay(week) + 1;
    end
end

function Calendar:AdvanceWeek()
    if (self:GetWeek() < self.weekNumber) then
        self:SetWeek(self:GetWeek() + 1)
    else
        self.day = 1;
        if (self.month < 12) then
            self.month = self.month + 1;
        else
            self.year = self.year + 1;
            self.month = 1;
        end
    end
end

function Calendar:AdvanceMonth()
    if (self.month < 12) then
        self.month = self.month + 1;
    else
        self.year = self.year + 1;
        self.month = 1;
    end
end

function Calendar:get_days_in_month(month, year)
  local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }   
  local d = days_in_month[month]
   
  -- check for leap year
  if (month == 2) then
    if (math.mod(year,4) == 0) then
     if (math.mod(year,100) == 0)then                
      if (math.mod(year,400) == 0) then                    
          d = 29
      end
     else                
      d = 29
     end
    end
  end

  return d  
end