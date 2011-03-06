dofile "../sampler/models/schedulemanager.lua"
require('luaunit')

TestScheduleManager = {}

function TestScheduleManager:setUp()
	self.schedule = ScheduleManager:New();
end

function TestScheduleManager:testGetRates()
	local schedule = self.schedule;
	assertEquals(0.9, schedule:GetEduRate(0.75, 65, 12))
	assertEquals(0.99, schedule:GetEduRate(0.75, 255, 16))
end



function table.contains(tbl, item)
	for i,v in ipairs(tbl) do 
		if (item == v) then
            return true;
        end
	end
    return false;
end

function table.print(tbl)
	for i,v in ipairs(tbl) do 
		print(i .. " : " .. v);
	end
end
