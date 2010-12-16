ExecutionPresenter = {}

function ExecutionPresenter:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function ExecutionPresenter:SetClosingEvent(event)
	self.closingEvent = event;
end

function ExecutionPresenter:Init(main, executionView, scheduleManager)
	self.main = main;
	self.executionView = executionView;
	self.scheduleManager = scheduleManager;

	main:ShowTachie(false);
	main:ToggleMainMenu(false);
	executionView:Show();

    self:RegisterEvents();
    self:Update();
end

function ExecutionPresenter:RegisterEvents()
    local executionView = self.executionView;
    local main = self.main;
    local scheduleManager = self.scheduleManager;
end

function ExecutionPresenter:Update()
    local executionView = self.executionView;
    local main = self.main;
    local scheduleManager = self.scheduleManager;

    self.selectedSchedules = scheduleManager:GetSelectedSchedules();
    self.currentScheduleIndex = 1;

    self:RunSchedule();
end

function ExecutionPresenter:RunSchedule()
    if (self.currentScheduleIndex > #(self.selectedSchedules)) then
        Trace("execution over!");
        self.executionView:Dispose();
		if (self.closingEvent ~= nil) then
			self.closingEvent();
		end
    else
        local scheduleName, success, result = self.scheduleManager:ProcessSchedule(self.selectedSchedules[self.currentScheduleIndex]);
        Trace("executing " .. scheduleName);

        self.executionView:SetExecutionOverEvent(
		    function ()
                Trace("executed " .. scheduleName);
                self:RunSchedule();
            end
        )
        local dialog2 = "";
        local portrait2 = "";
        if (success) then
            dialog2 = "이번주는 잘 되었습니다!\n아버지도 기뻐하실거에요.@"
            portrait2 = "Resources/sampler/resources/images/f2.png"
        else
            dialog2 = "이번주는 잘 안되었습니다!\n아버지가 슬퍼하실거에요.@"
            portrait2 = "Resources/sampler/resources/images/f1.png"
        end

	    self.executionView:ExecuteSchedule("규브", "이번주의 일정은 " ..  scheduleName .. "입니다.\n열심히 하세요.@",
							      "Resources/sampler/resources/images/f3.png", 
							      "Resources/sampler/resources/cursor.png",
							      "Resources/sampler/resources/cursor.png",
							      result,
							      dialog2,
							      portrait2);
        self.currentScheduleIndex = self.currentScheduleIndex + 1;
    end 
end

