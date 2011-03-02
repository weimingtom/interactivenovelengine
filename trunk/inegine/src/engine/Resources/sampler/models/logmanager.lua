LogManager = {}

LogManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.logTable = {};
	return o
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