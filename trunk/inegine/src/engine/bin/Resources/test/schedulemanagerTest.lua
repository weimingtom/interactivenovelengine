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
	assertEquals(0.99, schedule:GetJobRate(0.60, 201, 41, 49));
	assertEquals(0.76, schedule:GetJobRate(0.60, 50, 1, 20));
	assertEquals(0.25, schedule:GetJobRate(0.60, 50, 5, 95));
end

function TestScheduleManager:testCopyEffect()
	local schedule = self.schedule;
	target = {};
	source = {};
	
	source.stress = 100;
	source.sta = 100;
	
	schedule:SaveEffect(target, source);
	
	assertEquals(100, target.stress);
	assertEquals(100, target.sta);
	
	schedule:SaveEffect(source, source);
	
	assertEquals(200, source.stress);
	assertEquals(200, source.sta);
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
