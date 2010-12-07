SchedulePresenter = {}

function SchedulePresenter:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.numPages = 0;
	self.currentPage = 0;
	self.pageItems = 8;

	self.selectedSchedules = {};
	self.scheduleKeyMap = {};
	self.selectedScheduleCount = 0;
	self.focusedScheduleID = nil;
    self.uniqueSequence = 0;
    	
    
	return o
end

function SchedulePresenter:SetClosingEvent(event)
	self.closingEvent = event;
end

function SchedulePresenter:Init(main, scheduleView, scheduleManager)
	self.main = main;
	self.scheduleView = scheduleView;
	self.scheduleManager = scheduleManager;
	
	main:ToggleMainMenu(false);
	scheduleView:Show();
	
	scheduleView:SetClosingEvent( 
		function()
			if (self.closingEvent ~= nil) then
				self.closingEvent();
			end
		
			scheduleView:Hide();
			main:ToggleMainMenu(true);
		end
	);
	
	scheduleView:SetSelectedEvent(
		function (button, luaevent, args)
			Trace("select event called from " .. args);
			local iconKey = self:GetKey();
			Trace(iconKey);
            scheduleView:AddSelectedItem(iconKey, "Resources/sampler/resources/icon.png");
            self:SelectSchedule(args, iconKey);
		end
	)

	
	scheduleView:SetSelectedFocusEvent(
		function (button, luaevent, args)
			Trace("focus selected event called from " .. args);
            self.focusedScheduleID = args;          
            scheduleView:FocusSelectedItem(args);
            local scheduleID =  self.scheduleKeyMap[args];
            Trace(args);
            scheduleView:SetDetailText("detailed explanation: " .. scheduleID);
		end
	)

	scheduleView:SetDeletingEvent(
		function (button, luaevent, args)         
            if (self.focusedScheduleID ~= nil) then
                scheduleView:RemoveSelectedItem(self.focusedScheduleID);
                self:DeselectSchedule(self.focusedScheduleID);
                self.focusedScheduleID = nil;
            end
		end
	)
	
    scheduleView:SetExecutingEvent(
		function (button, luaevent, args)
			scheduleView:Dispose();
			self.main:OpenScheduleExecution();
		end
    )	
end

function SchedulePresenter:AddTestItems()
	local scheduleView = self.scheduleView;
	local scheduleList = ScheduleManager:GetSchedules("edu");
	for i,v in ipairs(scheduleList) do
		if (v.category == "edu") then
			scheduleView:AddEducationItem(v.id, v.text, v.price .. "G", v.icon);
		elseif (v.category == "job") then
			scheduleView:AddWorkItem(v.id, v.text, v.price .. "G", v.icon);
		elseif (v.category == "vac") then
			scheduleView:AddVacationItem(v.id, v.text, v.price .. "G", v.icon);
		end 
	end
	scheduleView:ClearEducationItems();
end

function SchedulePresenter:SelectSchedule(scheduleID, key)
	if (self.selectedScheduleCount < 4) then
		table.insert(self.selectedSchedules, scheduleID);
		self.scheduleKeyMap[key] = scheduleID;
		self.selectedScheduleCount = self.selectedScheduleCount + 1;
	end
end

function SchedulePresenter:DeselectSchedule(scheduleID)
	if (self.selectedScheduleCount > 0) then
		table.removeItem(self.selectedSchedules, scheduleID);
		if (table.contains(self.selectedSchedules, scheduleID)) then
		else
			self.scheduleKeyMap[scheduleID] = nil;
		end
		self.selectedScheduleCount = self.selectedScheduleCount - 1;
	end
end

function SchedulePresenter:GetKey()
	self.uniqueSequence = self.uniqueSequence + 1;
	return "key" .. self.uniqueSequence;
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
