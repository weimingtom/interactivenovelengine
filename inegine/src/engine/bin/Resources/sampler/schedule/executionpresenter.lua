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

	executionView:Show();

    self:RegisterEvents();
    self:Update();
end

function ExecutionPresenter:Close()
	if (self.closingEvent ~= nil) then
		self.closingEvent();
	end
    self:DeregisterEvents();
end

function ExecutionPresenter:RegisterEvents()
    local executionView = self.executionView;
    local main = self.main;
    local scheduleManager = self.scheduleManager;
    
    main:SetKeyDownEvent(function(handler, luaevent, args) self:HandleKeyDown(handler, luaevent, args) end)
end

function ExecutionPresenter:HandleKeyDown(handler, luaevent, args)
	local code = args[0];
	if (code == 32) then --space
		self.executionView:Advance();
	end
end

function ExecutionPresenter:DeregisterEvents()
    main:SetKeyDownEvent(nil)
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
		calendar:AdvanceMonth()
        self.executionView:Dispose();
		self:Close();
    else
        local scheduleName, success, result, animation = self.scheduleManager:ProcessSchedule(self.selectedSchedules[self.currentScheduleIndex]);
        
        self.executionView:SetExecutionOverEvent(
		    function ()
        		calendar:AdvanceWeek()
                self:RunSchedule();
            end
        )
        local dialog2 = "";
        local portrait2 = "";
        local sound = "";
        if (success) then
            dialog2 = execution_presenter_success_msg
            portrait2 = "resources/ba_temp.png"
            sound = "failure";
        else
            dialog2 = execution_presenter_failure_msg
            portrait2 = "resources/ba_temp.png"
            sound = "failure";
        end

	    self.executionView:ExecuteSchedule(execution_presenter_dialogue_name,
								  execution_presenter_dialogue_text1 ..  scheduleName .. execution_presenter_dialogue_text2,
							      "resources/ba_temp.png", 
							      animation,
							      result,
							      dialog2,
							      portrait2,
							      sound,
							      function()
									self.main:InvalidateStatus();
							      end,
							      self.currentScheduleIndex);
        self.currentScheduleIndex = self.currentScheduleIndex + 1;
    end 
end

