LogManager = {}

function LogManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.logTable = {};
    self.numLines = 0;
    self.currentLine = {};
    self.state = -1;

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
    self.currentLine.date = {};
    self.currentLine.date.year = year;
    self.currentLine.date.month = month;
    self.currentLine.date.week = week;
    self.state = 0;
    self:pushLine();
end

function LogManager:SetName(name, face)
    self.currentLine.name = name;
    self.currentLine.face = face;
    self.state = 1;
end

function LogManager:SetLine(line)
	line = string.gsub(line, "@", "");
	line = string.gsub(line, "|", "");
	 
    if (string.len(line) <= 0) then
		return;
	end
    
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