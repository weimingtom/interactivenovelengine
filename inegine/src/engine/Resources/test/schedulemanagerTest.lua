dofile "../sampler/models/schedulemanager.lua"
require('luaunit')

TestScheduleManager = {}

function TestScheduleManager:setUp()
end

function TestScheduleManager:testSelectSchedule()
	local scheduleList = ScheduleManager:GetSchedules();
	--table.print(scheduleList);
	for i,v in ipairs(scheduleList) do 
		print(v.category); 
		print(v.text); 
		print(v.price); 
		print(v.icon);
	end
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
