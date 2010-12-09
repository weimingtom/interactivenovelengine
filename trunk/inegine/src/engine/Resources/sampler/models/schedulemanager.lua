--Import
ScheduleManager = {}

function ScheduleManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
    self.educationCount = 20;
    self.jobCount = 30;
    self.vacationCount = 40;
	return o
end

function ScheduleManager:GetSchedules(category)
	local scheduleList = {};
	if (category == "edu") then
		for i=1,self.educationCount do
			local schedule = {};
			schedule.category = "edu"
			schedule.id = "edu" .. i;
			schedule.text = "Education " .. i;
			schedule.price = 100;
			schedule.icon = "Resources/sampler/resources/icon.png";
			table.insert(scheduleList, schedule);
		end
	elseif (category == "job") then
		for i=1,self.jobCount do
			local schedule = {};
			schedule.category = "job"
			schedule.id = "job" .. i;
			schedule.text = "Job " .. i;
			schedule.price = 100;
			schedule.icon = "Resources/sampler/resources/icon.png";
			table.insert(scheduleList, schedule);
		end
    elseif (category == "vac") then
		for i=1,self.vacationCount do
			local schedule = {};
			schedule.category = "vac"
			schedule.id = "vac" .. i;
			schedule.text = "Vacation " .. i;
			schedule.price = 100;
			schedule.icon = "Resources/sampler/resources/icon.png";
			table.insert(scheduleList, schedule);
		end
    end
	return scheduleList;
end