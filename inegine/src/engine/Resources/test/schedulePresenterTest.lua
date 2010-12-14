dofile "../sampler/schedule/schedulepresenter.lua"
dofile "../sampler/models/schedulemanager.lua"
require('luaunit')

TestSchedule = {}

function TestSchedule:setUp()
	self.schedule = SchedulePresenter:New()
end

function TestSchedule:testSelectSchedule()
	self.schedule:SelectSchedule(0);
	assertEquals(1, self.schedule.selectedScheduleCount)
	self.schedule:SelectSchedule(1);
	assertEquals(2, self.schedule.selectedScheduleCount)
	self.schedule:SelectSchedule(2);
	assertEquals(3, self.schedule.selectedScheduleCount)
	self.schedule:SelectSchedule(3);
	assertEquals(4, self.schedule.selectedScheduleCount)
	self.schedule:SelectSchedule(4);
	assertEquals(4, self.schedule.selectedScheduleCount)

	assertEquals(true, table.contains(self.schedule.selectedSchedules, 1));
	assertEquals(0, self.schedule.selectedSchedules[1]);
	assertEquals(1, self.schedule.selectedSchedules[2]);
	assertEquals(2, self.schedule.selectedSchedules[3]);
	assertEquals(3, self.schedule.selectedSchedules[4]);
end

function TestSchedule:testDeselectSchedule()
	self.schedule:SelectSchedule(0, 0);
	self.schedule:SelectSchedule(1, 1);
	self.schedule:SelectSchedule(2, 2);
	self.schedule:SelectSchedule(3, 3);

	self.schedule:DeselectSchedule(1);
	assertEquals(false, table.contains(self.schedule.selectedSchedules, 1));
	assertEquals(nil, self.schedule.scheduleKeyMap[1]);
	assertEquals(0, self.schedule.selectedSchedules[1]);
	assertEquals(2, self.schedule.selectedSchedules[2]);
	assertEquals(3, self.schedule.selectedSchedules[3]);

	self.schedule:DeselectSchedule(0);
	assertEquals(false, table.contains(self.schedule.selectedSchedules, 0));
	assertEquals(nil, self.schedule.scheduleKeyMap[0]);
	assertEquals(2, self.schedule.selectedSchedules[1]);
	assertEquals(3, self.schedule.selectedSchedules[2]);

	self.schedule:DeselectSchedule(2);
	self.schedule:DeselectSchedule(3);
	assertEquals(false, table.contains(self.schedule.selectedSchedules, 2));
	assertEquals(false, table.contains(self.schedule.selectedSchedules, 3));
	assertEquals(nil, self.schedule.scheduleKeyMap[2]);
	assertEquals(nil, self.schedule.scheduleKeyMap[3]);
	assertEquals(0, self.schedule.selectedScheduleCount)
end

function TestSchedule:testDeselectScheduleDuplicate()
	self.schedule:SelectSchedule(0);
	self.schedule:SelectSchedule(1);
	self.schedule:SelectSchedule(1);
	self.schedule:SelectSchedule(3);

	self.schedule:DeselectSchedule(1);
	assertEquals(true, table.contains(self.schedule.selectedSchedules, 1));
	assertEquals(0, self.schedule.selectedSchedules[1]);
	assertEquals(1, self.schedule.selectedSchedules[2]);
	assertEquals(3, self.schedule.selectedSchedules[3]);

	self.schedule:DeselectSchedule(1);
	assertEquals(false, table.contains(self.schedule.selectedSchedules, 1));
	assertEquals(0, self.schedule.selectedSchedules[1]);
	assertEquals(3, self.schedule.selectedSchedules[2]);
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
    return false;
end

function TestSchedule:testSetPage()
    self.schedule.scheduleManager = ScheduleManager:New();

	self.schedule.numEduPages = 3;
	self.schedule.currentEduPage = 0;

    self.schedule:SetEduPage(0);
    assertEquals(0, self.schedule.currentEduPage);

    self.schedule:SetEduPage(1);
    assertEquals(1, self.schedule.currentEduPage);
    
    self.schedule:SetEduPage(1);
    assertEquals(2, self.schedule.currentEduPage);

    self.schedule:SetEduPage(1);
    assertEquals(2, self.schedule.currentEduPage);

    self.schedule:SetEduPage(2);
    assertEquals(2, self.schedule.currentEduPage);

    self.schedule:SetEduPage(-3);
    assertEquals(0, self.schedule.currentEduPage);

    self.schedule:SetEduPage(10);
    assertEquals(self.schedule.numEduPages - 1, self.schedule.currentEduPage);
end
