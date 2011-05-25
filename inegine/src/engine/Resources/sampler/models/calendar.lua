--Import
Calendar = {}
-- 2012≥‚¿Ã ¿∞º∫ 0≥ÅE ø’±π∑¬ 314≥ÅE
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
    
	Calendar.instance = self;
	
	return o
end

function Calendar:GetInstance()
	return Calendar.instance;
end

function Calendar:SetUpdateEvent(event)
	self.updateEvent = event;
end

function Calendar:Update()
	if (self.updateEvent ~= nil) then self:updateEvent() end
end

function Calendar:SetModifier(modifier)
    self.modifier = modifier;
end

function Calendar:GetModifier()
    return self.modifier;
end

function Calendar:SetWeekLength(days)
    self.weekLength = days;
end

function Calendar:SetWeekNumber(weeks)
    self.weekNumber = weeks;
end

function Calendar:SetDate(year, month, day)
    self.year = year - self.modifier;
    self.month = month;
    self.day = day;
    self:Update();
end

function Calendar:SetYear(year)
    self.year = year - self.modifier;
    self:Update();
end

function Calendar:SetMonth(month)
    self.month = month;
    self:Update();
end

function Calendar:SetDay(day)
    self.day = day;
    self:Update();
end

function Calendar:GetYear()
	return self.year  + self.modifier;
end

function Calendar:GetUnmodifiedYear()
	return self.year;
end

function Calendar:GetWordMonth()
	local month = math.max(1, math.min(12, self.month));
	local monthNames = {};
	monthNames[1] = "Jan"
	monthNames[2] = "Feb"
	monthNames[3] = "Mar"
	monthNames[4] = "Apr"
	monthNames[5] = "May"
	monthNames[6] = "Jun"
	monthNames[7] = "Jul"
	monthNames[8] = "Aug"
	monthNames[9] = "Sep"
	monthNames[10] = "Oct"
	monthNames[11] = "Nov"
	monthNames[12] = "Dev"
	return monthNames[month];
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
    self:Update();
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
    self:Update();
end

function Calendar:AdvanceMonth()
    if (self.month < 12) then
        self.month = self.month + 1;
    else
        self.year = self.year + 1;
        self.month = 1;
    end
    self:SetWeek(1);
    self:Update();
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

function Calendar:Validate(year, month, day)
	local actualYear = year - self.modifier;
	
	if (year == nil or month == nil or day == nil) then
		return false;
	end
	
	if (month > 12 or month < 1) then
		return false;
	end
	local days = self:get_days_in_month(month, actualYear);
	if (day > days or day < 1) then
		return false;
	end
	
	return true;
end

function Calendar:Save(target)
    local saveString = target .. " = Calendar:New()\n";
    saveString = saveString .. "local self = " .. target .. "\n"
    saveString = saveString .. [[self:SetModifier(]] ..  self:GetModifier() ..  [[)]] .. "\n";  
    saveString = saveString .. [[self:SetDate(]] ..  self:GetYear() .. "," 
							..  self:GetMonth() .. "," .. self:GetDay() .. [[)]] .. "\n";    
    return saveString;
end

function SetDate(year, month, day)
	Calendar:GetInstance():SetDate(year, month, day);
end