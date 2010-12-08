dofile "../sampler/models/schedulemanager.lua"
require('luaunit')

TestScheduleManager = {}

function TestScheduleManager:setUp()
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
