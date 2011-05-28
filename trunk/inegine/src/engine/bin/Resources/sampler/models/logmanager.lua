LogManager = {}

function LogManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.logTable = {};
    self.numLines = 0;
    self.currentLine = {};
    self.state = -1;
    
    self.lineLength = 22;
    	
    self.prevYear = nil;
    self.prevMonth = nil;
    self.prevWeek = nil;

	return o
end

function LogManager:pushLine()
   
    if (self.currentLine ~=  nil) then
        if (self.state == 0 or self.state == 2) then
            self.logTable[self.numLines] = self.currentLine;
            self.numLines = self.numLines + 1;
        elseif (self.state == 1) then
        end
    end
    
    self.currentLine = {};
end

function LogManager:SetDate(year, month, week)
	if (year == nil) then
		year = calendar:GetYear();
	end

	if (month == nil) then
		month = calendar:GetMonth();
	end

	if (week == nil) then
		week = calendar:GetWeek();
	end

	--if previous date is nil or new date is different from previous date, push new date
	--otherwise do nothing

	if ((self.prevYear == nil or self.prevMonth == nil or self.prevWeek == nil) or
		(self.prevYear ~= year or self.prevMonth ~= month or self.prevWeek ~= week)) then
		self.currentLine.date = {};
		self.currentLine.date.year = year;
		self.currentLine.date.month = month;
		self.currentLine.date.week = week;
		self.state = 0;
		self:pushLine();
		
		self.prevYear = year;
		self.prevMonth = month;
		self.prevWeek = week;
    end
end

function LogManager:SetName(name, face)
    self.currentLine.name = name;
    self.currentLine.face = face;
    self.state = 1;
end

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function LogManager:SetLine(line)
	line = Replace(line, "@", "");
	line = Replace(line, "|", "");
    if (string.len(line) <= 0) then
		return;
	end
    
    if (Length(line) > self.lineLength) then
		self:SetLine_(Substring(line, 0, self.lineLength));
		self:SetLine_(Substring(line, self.lineLength, -1));
    else
		self:SetLine_(line);
    end
end

function LogManager:SetLine_(line)
    self.currentLine.line = line;
    self.state = 2;
    self:pushLine();
end

function LogManager:GetSize()
    return self.numLines;
end

--returns date, face, line
--as a tuple
--possible combinations: date, nil, nil
--nil, name, line,
--nil, nil, line
function LogManager:GetLine(line)
    return self.logTable[line];
end


function LogManager:Save(target)
    local saveString = target .. " = LogManager:New()\n";
    saveString = saveString .. "local self = " .. target .. "\n"
    for i=0, self:GetSize() - 1 do
		local line = logManager:GetLine(i);
        if (line.date ~= nil) then
            saveString = saveString .. "self:SetDate(" .. line.date.year .. "," .. 
				line.date.month .. "," .. line.date.week .. ");";
        elseif (line.name ~= nil and line.line ~= nil) then
			saveString = saveString .. "self:SetName([[" .. line.name .. "]],[[" .. 
				line.face .. "]]);";
			saveString = saveString .. "self:SetLine([[" .. line.line .. "]]);";
        elseif (line.line ~= nil) then
			saveString = saveString .. "self:SetLine([[" .. line.line .. "]]);";
        end
    end
    return saveString;
end

function table.contains(tbl, item)
	for i,v in ipairs(tbl) do
		if (item == v) then
            return true;
        end
	end
    return false;
end

function table.removeItem(tbl, item)
	for i,v in ipairs(tbl) do
		if (item == v) then
            table.remove(tbl, i)
            return;
        end
	end
end