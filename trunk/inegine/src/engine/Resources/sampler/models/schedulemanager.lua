--Import
ScheduleManager = {}

function ScheduleManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	return o
end

function ScheduleManager:GetSchedules(category)
	local scheduleList = {};
	
	if (category == nil) then
		for i=1,10 do
			local schedule = {};
			schedule.category = "edu"
			schedule.id = "edu" .. i;
			schedule.text = "Education " .. i;
			schedule.price = 100;
			schedule.icon = "Resources/sampler/resources/icon.png";
			table.insert(scheduleList, schedule);
		end
	end
	return scheduleList;
end