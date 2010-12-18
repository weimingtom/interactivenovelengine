SchedulePresenter = {}

function SchedulePresenter:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.pageItems = 8;

	self.numEduPages = 0;
	self.currentEduPage = 0;

	self.numJobPages = 0;
	self.currentJobPage = 0;

	self.numVacPages = 0;
	self.currentVacPage = 0;

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
	
    scheduleView:EnableRun(false);
    scheduleView:Show();
    
    self:RegisterEvents();
    self:Update();
end

function SchedulePresenter:RegisterEvents()
    local scheduleView = self.scheduleView;
    local main = self.main;
    local scheduleManager = self.scheduleManager;

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
            self:SelectSchedule(args);
		end
	)


	scheduleView:SetSelectedFocusEvent(
		function (button, luaevent, args)
			Trace("focus selected event called from " .. args);
            self.focusedScheduleID = args;
            scheduleView:FocusSelectedItem(args);
            local scheduleID =  self.scheduleKeyMap[args];
            Trace(args);
            scheduleView:SetDetailText(scheduleManager:GetItem(scheduleID).desc);
		end
	)

	scheduleView:SetDeletingEvent(
		function (button, luaevent, args)
            if (self.focusedScheduleID ~= nil) then
                self:DeselectSchedule(self.focusedScheduleID);
                self.focusedScheduleID = nil;
            end
		end
	)

    scheduleView:SetExecutingEvent(
		function (button, luaevent, args)
			scheduleView:Dispose();
            self.scheduleManager:SetSelectedSchedules(self.selectedSchedules);
			self.main:OpenScheduleExecution();
		end
    )

    scheduleView:SetUpButtonEvent(
        function()
            local activeTab = scheduleView:GetActiveTab();
            if (activeTab == "education") then
                if (self:SetEduPage(-1)) then self:Update(); end
            elseif (activeTab == "work") then
                if (self:SetJobPage(-1)) then self:Update(); end
            elseif (activeTab == "vacation") then
                if (self:SetVacPage(-1)) then self:Update(); end
            end
        end
    )

    scheduleView:SetDownButtonEvent(
        function()
            local activeTab = scheduleView:GetActiveTab();
            if (activeTab == "education") then
                if (self:SetEduPage(1)) then self:Update(); end
            elseif (activeTab == "work") then
                if (self:SetJobPage(1)) then self:Update(); end
            elseif (activeTab == "vacation") then
                if (self:SetVacPage(1)) then self:Update(); end
            end
        end
    )
end

function SchedulePresenter:Update()
    self:UpdateNumPages();
    if (self.scheduleView ~= nil) then
        self.scheduleView:ClearEducationItems();
        self.scheduleView:ClearWorkItems();
        self.scheduleView:ClearVacationItems();
        self:AddItems();
    end
end

function SchedulePresenter:UpdateNumPages()
	self.numEduPages = math.ceil(self.scheduleManager:GetItemCount("edu") / self.pageItems);
	self.numJobPages = math.ceil(self.scheduleManager:GetItemCount("job") / self.pageItems);
	self.numVacPages = math.ceil(self.scheduleManager:GetItemCount("vac") / self.pageItems);
end

function SchedulePresenter:AddItems()
	local scheduleView = self.scheduleView;
	local scheduleList = scheduleManager:GetItems("edu");
	for i,v in ipairs(scheduleList) do
	    if (self:ItemInPage(i, self.currentEduPage)) then
            scheduleView:AddEducationItem(v.id, v.text, v.price .. "G", v.icon);
	    end
    end
	local scheduleList = scheduleManager:GetItems("job");
	for i,v in ipairs(scheduleList) do
	    if (self:ItemInPage(i, self.currentJobPage)) then
		    scheduleView:AddWorkItem(v.id, v.text, v.price .. "G", v.icon);
        end
	end

	local scheduleList = scheduleManager:GetItems("vac");
	for i,v in ipairs(scheduleList) do
	    if (self:ItemInPage(i, self.currentVacPage)) then
		    scheduleView:AddVacationItem(v.id, v.text, v.price .. "G", v.icon);
        end
	end
end

function SchedulePresenter:SelectSchedule(scheduleID)
	if (self.selectedScheduleCount < 4) then
		local key = self:GetKey();
		if (self.scheduleView ~= nil) then self.scheduleView:AddSelectedItem(key, "Resources/sampler/resources/icon.png"); end;
		table.insert(self.selectedSchedules, scheduleID);
		self.scheduleKeyMap[key] = scheduleID;
		self.selectedScheduleCount = self.selectedScheduleCount + 1;

        if (self.selectedScheduleCount == 4) then 
            self.scheduleView:EnableRun(true);
        end
        
        self.scheduleView:SetDetailText(self.scheduleManager:GetItem(scheduleID).desc);
	end
end

function SchedulePresenter:DeselectSchedule(scheduleID)
	if (self.selectedScheduleCount > 0) then
        if (self.scheduleView ~= nil) then self.scheduleView:RemoveSelectedItem(scheduleID); end
		table.removeItem(self.selectedSchedules, self.scheduleKeyMap[scheduleID]);
		if (table.contains(self.selectedSchedules, self.scheduleKeyMap[scheduleID] )) then
		else
			self.scheduleKeyMap[scheduleID] = nil;
		end
		self.selectedScheduleCount = self.selectedScheduleCount - 1;
        if (self.selectedScheduleCount < 4) then 
            self.scheduleView:EnableRun(false);
        end
        self.scheduleView:SetDetailText("");
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

function SchedulePresenter:ItemInPage(index, page)
    local itemPage = math.floor((index - 1) / self.pageItems);
    if (page == itemPage) then
        return true;
    else
        return false;
    end
end

function SchedulePresenter:SetEduPage(modifier)
    local oldpage = self.currentEduPage;
    local page = self.currentEduPage + modifier;
    if (page < 0) then
        self.currentEduPage = 0;
    elseif (page >= self.numEduPages) then
        self.currentEduPage = self.numEduPages - 1;
    else
        self.currentEduPage = page;
    end

    if (oldpage ~= self.currentEduPage) then
        return true;
    end
end

function SchedulePresenter:SetJobPage(modifier)
    local oldpage = self.currentJobPage;
    local page = self.currentJobPage + modifier;
    if (page < 0) then
        self.currentJobPage = 0;
    elseif (page >= self.numJobPages) then
        self.currentJobPage = self.numJobPages - 1;
    else
        self.currentJobPage = page;
    end

    if (oldpage ~= self.currentJobPage) then
        return true;
    end
end

function SchedulePresenter:SetVacPage(modifier)
    local oldpage = self.currentVacPage;
    local page = self.currentVacPage + modifier;
    if (page < 0) then
        self.currentVacPage = 0;
    elseif (page >= self.numVacPages) then
        self.currentVacPage = self.numVacPages - 1;
    else
        self.currentVacPage = page;
    end

    if (oldpage ~= self.currentVacPage) then
        return true;
    end
end
