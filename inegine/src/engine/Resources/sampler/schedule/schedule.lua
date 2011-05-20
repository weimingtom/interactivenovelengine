-- schedule UI component implemented in lua
LoadScript "components\\luaview.lua"
LoadScript "components\\tabview.lua"
LoadScript "components\\flowview.lua"

ScheduleView = LuaView:New();

function ScheduleView:Init()
	self.activeTab = schedule_view_work
	local gamestate = CurrentState();
	local parent = self.parent;
	local font = GetFont("default");
	local name = self.name;
	self.font = font;
	self.frame = View()
	self.frame.Name = name

	self.frame.X = 0;
	self.frame.Y = 0;
	self.frame.Width = GetWidth();
	self.frame.Height = GetHeight();
	self.frame.alpha = 155
	self.frame.layer = 6

	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)
		end

	parent:AddComponent(self.frame)
	
	local scheduleMenu = SpriteBase();
	self.scheduleMenu = scheduleMenu;
	scheduleMenu.Texture = "resources/ui/schedule_select_menu.png"
	scheduleMenu.Visible = true;
	scheduleMenu.Layer = 3;
	self.frame:AddComponent(scheduleMenu)	
	
	local educationRollOver = SpriteBase();
	self.educationRollOver = educationRollOver;
	educationRollOver.Texture = "resources/ui/schedule_education_rollover.png"
	educationRollOver.Visible = false;
	educationRollOver.Layer = 4;
	educationRollOver:Hide();
	self.frame:AddComponent(educationRollOver)
	
	self.educationButton = UIFactory.CreateRollOverButton(
		function()
			self.educationView:Show();
			self.workView:Hide();
			self.vacationView:Hide();
			self.activeTab = schedule_view_education;
			self.pageUpdateEvent();
		end,
		function ()
			self.educationRollOver:Show();
			self.workRollOver:Hide();
			self.vacationRollOver:Hide();
		end,
		function ()
			self.educationRollOver:Hide();
			self.workRollOver:Hide();
			self.vacationRollOver:Hide();
		end);
	self.educationButton.X =  28
	self.educationButton.Y = 178
	self.educationButton.Width = 68
	self.educationButton.Height = 39
	self.educationButton.Layer = 5
	self.frame:AddComponent(self.educationButton);

	local workRollOver = SpriteBase();
	self.workRollOver = workRollOver;
	workRollOver.Texture = "resources/ui/schedule_work_rollover.png"
	workRollOver.Visible = false;
	workRollOver.Layer = 4;
	workRollOver:Hide();
	self.frame:AddComponent(workRollOver)
	
	self.workButton = UIFactory.CreateRollOverButton(
		function()
			self.educationView:Hide();
			self.workView:Show();
			self.vacationView:Hide();
			self.activeTab = schedule_view_work
			self.pageUpdateEvent();
		end,
		function ()
			self.educationRollOver:Hide();
			self.workRollOver:Show();
			self.vacationRollOver:Hide();
		end,
		function ()
			self.educationRollOver:Hide();
			self.workRollOver:Hide();
			self.vacationRollOver:Hide();
		end);
	self.workButton.X =  115
	self.workButton.Y = 175
	self.workButton.Width = 70
	self.workButton.Height = 42
	self.workButton.Layer = 5
	self.frame:AddComponent(self.workButton);
	
	local vacationRollOver = SpriteBase();
	self.vacationRollOver = vacationRollOver;
	vacationRollOver.Texture = "resources/ui/schedule_vacation_rollover.png"
	vacationRollOver.Visible = false;
	vacationRollOver.Layer = 4;
	vacationRollOver:Hide();
	self.frame:AddComponent(vacationRollOver)
	
	self.vacationButton = UIFactory.CreateRollOverButton(
		function()
			self.educationView:Hide();
			self.workView:Hide();
			self.vacationView:Show();
			self.activeTab = shcedule_view_vacation
			self.pageUpdateEvent();
		end,
		function ()
			self.educationRollOver:Hide();
			self.workRollOver:Hide();
			self.vacationRollOver:Show();
		end,
		function ()
			self.educationRollOver:Hide();
			self.workRollOver:Hide();
			self.vacationRollOver:Hide();
		end);
	self.vacationButton.X =  213
	self.vacationButton.Y = 172
	self.vacationButton.Width = 81
	self.vacationButton.Height = 44
	self.vacationButton.Layer = 5
	self.frame:AddComponent(self.vacationButton);
	
	local deleteRollOver = SpriteBase();
	self.deleteRollOver = deleteRollOver;
	deleteRollOver.Texture = "resources/ui/schedule_delete_rollover.png"
	deleteRollOver.Visible = false;
	deleteRollOver.Layer = 4;
	deleteRollOver:Hide();
	self.frame:AddComponent(deleteRollOver)
	
	self.deleteButton = UIFactory.CreateRollOverButton(
		function()
            if (self.deleteEvent ~= nil) then
                self.deleteEvent(self.deleteButton, luaevent, args);
            end
		end,
		function ()
			self.deleteRollOver:Show();
		end,
		function ()
			self.deleteRollOver:Hide();
		end);
	self.deleteButton.X = 635
	self.deleteButton.Y = 386
	self.deleteButton.Width = 72
	self.deleteButton.Height = 30
	self.deleteButton.Layer = 5
	self.frame:AddComponent(self.deleteButton);
	
	local okRollOver = SpriteBase();
	self.okRollOver = okRollOver;
	okRollOver.Texture = "resources/ui/schedule_ok_rollover.png"
	okRollOver.Visible = false;
	okRollOver.Layer = 4;
	okRollOver:Hide();
	self.frame:AddComponent(okRollOver)
	
	self.okButton = UIFactory.CreateRollOverButton(
		function(executeButton, luaevent, args)
			self.executeEvent(executeButton, luaevent, args);
		end,
		function ()
			self.okRollOver:Show();
		end,
		function ()
			self.okRollOver:Hide();
		end);
	self.okButton.X = 563
	self.okButton.Y = 387
	self.okButton.Width = 67
	self.okButton.Height = 30
	self.okButton.Layer = 5
	self.frame:AddComponent(self.okButton);
	
	local repeatRollOver = SpriteBase();
	self.repeatRollOver = repeatRollOver;
	repeatRollOver.Texture = "resources/ui/schedule_repeat_rollover.png"
	repeatRollOver.Visible = false;
	repeatRollOver.Layer = 4;
	repeatRollOver:Hide();
	self.frame:AddComponent(repeatRollOver)
	
	self.repeatButton = UIFactory.CreateRollOverButton(
		function()
            if (self.repeatEvent~=nil) then
                self.repeatEvent(self.repeatButton, luaevent, args);
            end
		end,
		function ()
			self.repeatRollOver:Show();
		end,
		function ()
			self.repeatRollOver:Hide();
		end);
	self.repeatButton.X =  715
	self.repeatButton.Y = 386
	self.repeatButton.Width = 68
	self.repeatButton.Height = 30
	self.repeatButton.Layer = 5
	self.frame:AddComponent(self.repeatButton);
		
	local upButton = self:CreateUpButton(
    function()
        if (self.upButtonEvent ~= nil) then
            self.upButtonEvent();
        end
    end
    );
    upButton.x = 147
    upButton.y = 539
    upButton.width = 20
    upButton.height = 20
    self.frame:AddComponent(upButton);

    local downButton = self:CreateDownButton(
        function()
            if (self.downButtonEvent ~= nil) then
				Trace("down button!");
                self.downButtonEvent();
            end
        end
    );
    downButton.x = 243
    downButton.y = 539
    downButton.width = 20
    downButton.height = 20
    self.frame:AddComponent(downButton);
	
	local button = Button();
	self.pageButton = button;
	button.Width = 60;
	button.Height = 30;
	button.X = 178
	button.Y = 536;
	button.Layer = 10
	button.font = GetFont("item_name");
	button.TextColor = 0x2222FF
	button.Alignment = 1;
	button.VerticalAlignment = 1;
	button:Show();
	self.frame:AddComponent(button);
	
	
	
	self.backButton = UIFactory.CreateBackButton(
		function (button, luaevent, args)
				self:Dispose();
		end
	)
	self.backButton.X = 715
	self.backButton.Y = 460
	self.backButton.Layer = 10
	self.frame:AddComponent(self.backButton);
	
	local educationView = Flowview:New("educationView")
	educationView.frame.relative = true;
	educationView.frame.width = 350;
	educationView.frame.height = 326;
	educationView.frame.x = 40;
	educationView.frame.y = 225;
	educationView.frame.layer = 4;
	educationView.spacing = 2;
	educationView.padding = 2;
	self.educationView = educationView;
	self.frame:AddComponent(self.educationView.frame);
	self.educationView:Show();
	
	local workView = Flowview:New("workView")
	workView.frame.relative = true;
	workView.frame.width = 350;
	workView.frame.height = 326;
	workView.frame.x = 40;
	workView.frame.y = 225;
	workView.frame.layer = 4;
	workView.spacing = 2;
	workView.padding = 2;
	self.workView = workView;
	self.frame:AddComponent(self.workView.frame);
	self.workView:Hide();
	
	local vacationView = Flowview:New("vacationView")
	vacationView.frame.relative = true;
	vacationView.frame.width = 350;
	vacationView.frame.height = 326;
	vacationView.frame.x = 40;
	vacationView.frame.y = 225;
	vacationView.frame.layer = 4;
	vacationView.spacing = 2;
	vacationView.padding = 2;
	self.vacationView = vacationView;
	self.frame:AddComponent(self.vacationView.frame);
	self.vacationView:Hide();

	local selectedItemsView = Flowview:New("selectedItemsView")
	selectedItemsView.frame.relative = true;
	selectedItemsView.frame.width = 190;
	selectedItemsView.frame.height = 63;
	selectedItemsView.frame.x = 555;
	selectedItemsView.frame.y = 270;
	selectedItemsView.frame.layer = 4;
	selectedItemsView.spacing = 0;
	selectedItemsView.padding = 0;
	self.selectedItemsView = selectedItemsView;
	self.frame:AddComponent(self.selectedItemsView.frame);
	self.selectedItemsView:Show();

	--local executeButton = self:CreateButton(schedule_view_run,
		--function (executeButton, luaevent, args)
            --if (self.executeEvent~=nil) then
                --self.executeEvent(executeButton, luaevent, args);
            --end
		--end)
	--executeButton.Layer = 4;
	--executeButton.X = selectionframe.x + 213;
	--executeButton.Y = selectionframe.y + selectionframe.height;
	--self.executeButton = executeButton
	--self.frame:AddComponent(executeButton);
--
--
	local detailviewframe = TextWindow()
	self.detailviewframe = detailviewframe;
	detailviewframe.Name = "detailviewframe"
	detailviewframe.font = GetFont("item_name");
	detailviewframe.TextColor = 0x000000
	detailviewframe.X = 471;
	detailviewframe.Y = 451;
    detailviewframe.linespacing = 10
    detailviewframe.margin = 15
    detailviewframe.leftmargin = 15
	detailviewframe.Width = 276
	detailviewframe.Height = 70
	detailviewframe.alpha = 0
	detailviewframe.layer = 8
	self.frame:AddComponent(detailviewframe)
end

function ScheduleView:CreateUpButton(event)
	local newButton = View()
	newButton.Relative = true;
	newButton.Layer = 15
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 18;
	newButton.Height = 12;
	newButton.State = {}
	newButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
                if (event~=nil) then 
					event(button, luaevent, args);
				end
			end
		end
	return newButton;
end

function ScheduleView:CreateDownButton(event)
	local newButton = View()
	newButton.Relative = true;
	newButton.Layer = 15
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 18;
	newButton.Height = 12;
	newButton.State = {}
	newButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				Trace("button down!");
                if (event~=nil) then 
					event(button, luaevent, args);
				end
			end
		end
	return newButton;
end

function ScheduleView:CreateSelectedButton(buttonName, buttonText)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonName;
	newButton.Texture = "resources/button.png"
	newButton.Layer = 3
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 120;
	newButton.Height = 40;
	newButton.State = {}
	newButton.MouseDown =
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
		end
	newButton.MouseUp =
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				self.selectedFocusEvent(button, luaevent, args);
			end
		end
	newButton.TextColor = 0xEEEEEE
	return newButton;
end

function ScheduleView:AddEducationItem(id, text, price, icon, effect)
	self.educationView:Add(UIFactory.CreateItemButton(id, text, icon, price, 1, effect,
	 function(button, event, args)
		self.selectedEvent(button, luaevent, id);
	 end, false,
	 function(button, event, args)
		self.detailEvent(button, luaevent, id);
	 end
	 ));
end

function ScheduleView:AddWorkItem(id, text, price, icon, effect)
	self.workView:Add(UIFactory.CreateItemButton(id, text, icon, price, 1, effect,
	 function(button, event, args)
		self.selectedEvent(button, luaevent, id);
	 end, false,
	 function(button, event, args)
		self.detailEvent(button, luaevent, id);
	 end
	 ));
end

function ScheduleView:AddVacationItem(id, text, price, icon, effect)
	self.vacationView:Add(UIFactory.CreateItemButton(id, text, icon, price, 1, effect,
	 function(button, event, args)
		self.selectedEvent(button, luaevent, id);
	 end, false,
	 function(button, event, args)
		self.detailEvent(button, luaevent, id);
	 end
	 ));
end

function ScheduleView:AddSelectedItem(id, icon)
	self.selectedItemsView:Add(self:CreateSelectedItem(id, icon));
end

function ScheduleView:ClearEducationItems()
	self.educationView:Clear();
end

function ScheduleView:ClearWorkItems()
	self.workView:Clear();
end

function ScheduleView:ClearVacationItems()
	self.vacationView:Clear();
end

function ScheduleView:RemoveSelectedItem(id)
	self.selectedItemsView:Remove(id);
end

function ScheduleView:RemoveSelectedItems()
	self.selectedItemsView:Clear();
end

function ScheduleView:FocusSelectedItem(buttonName)
    for i,v in ipairs(self.selectedItemsView:GetItems()) do
        local item = self.selectedItemsView:GetItem(v);
		if (buttonName == v) then
            item.pushed = true;
        else
            item.pushed = false;
        end
	end
end

function ScheduleView:SetDetailText(text)
    self.detailviewframe.text = text;
end


function ScheduleView:SetPageUpdateEvent(event)
	self.pageUpdateEvent = event;
end

function ScheduleView:SetRepeatingEvent(event)
	self.repeatEvent = event;
end

function ScheduleView:SetExecutingEvent(event)
	self.executeEvent = event;
end

function ScheduleView:SetDeletingEvent(event)
	self.deleteEvent = event;
end

function ScheduleView:SetDeleteallEvent(event)
	self.deleteallEvent = event;
end

function ScheduleView:SetSelectedEvent(event)
	self.selectedEvent = event;
end

function ScheduleView:SetDetailEvent(event)
	self.detailEvent = event;
end

function ScheduleView:SetSelectedFocusEvent(event)
	self.selectedFocusEvent = event;
end

function ScheduleView:CreateSelectedItem(id, icon)
	local pic = Button();
	pic.Name = id;
	pic.Texture = icon
	pic.Visible = true;
	pic.Width = 60;
	pic.Height = 60;
	pic.State = {}
	pic.MouseDown =
		function (button, luaevent, args)
			Trace("mouse down!");
			button.State["mouseDown"] = true
			button.Pushed = true;
		end
	pic.MouseUp =
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				Trace("mouse up!");
				button.Pushed = false;
				self.selectedFocusEvent(button, luaevent, id);
			end
		end
	return pic;
end
function ScheduleView:CreateItem(id, text, price, icon)
	local frame = View();
	frame.Name = id;
	frame.Relative = true;
	frame.Width = 90;
	frame.Height = 80;
	frame.Enabled = true;

	local pic = Button();
	pic.Name = "picture";
	pic.Texture = icon
	pic.Visible = true;
	pic.X = (frame.Width - pic.Width) / 2;
	pic.Width = 48;
	pic.Height = 48;
	pic.State = {}
	pic.MouseDown =
		function (button, luaevent, args)
			button.State["mouseDown"] = true
			button.Pushed = true;
		end
	pic.MouseUp =
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
				self.selectedEvent(button, luaevent, id);
			end
		end
	frame:AddComponent(pic);

	local button = Button();
	button.Name = "text"
	button.Width = 90;
	button.Height = 15;
	button.X = 0;
	button.Y = pic.Height;
	button.font = GetFont("verysmall");
	button.TextColor = 0xFFFFFF
	button.Text = text;
	button.Alignment = 1;
	button.VerticalAlignment = 1;
	frame:AddComponent(button);


	local priceButton = Button();
	priceButton.Name = "price"
	priceButton.Width = 90;
	priceButton.Height = 15;
	priceButton.X = 0;
	priceButton.Y = button.Y + button.Height;
	priceButton.font = GetFont("verysmall");
	priceButton.TextColor = 0xFFFFFF
	priceButton.Text = price;
	priceButton.Alignment = 1;
	priceButton.VerticalAlignment = 1;
	frame:AddComponent(priceButton);
	return frame;
end

function ScheduleView:GetActiveTab()
    return self.activeTab;
end

function ScheduleView:SetUpButtonEvent(event)
    self.upButtonEvent = event;
end

function ScheduleView:SetDownButtonEvent(event)
    self.downButtonEvent = event;
end
function ScheduleView:EnableRun(enable)
    self.okButton.Enabled = enable;
end

function ScheduleView:PrintPageNumbers(nd, cd, ni, ci, nf, cf)
	if (self.activeTab == schedule_view_education) then
		self.pageButton.Text = (cd + 1) .. "/" .. nd;
	elseif (self.activeTab == schedule_view_work) then
		self.pageButton.Text = (ci + 1) .. "/" .. ni;
	elseif (self.activeTab == shcedule_view_vacation) then
		self.pageButton.Text = (cf + 1) .. "/" .. nf;
	end
end