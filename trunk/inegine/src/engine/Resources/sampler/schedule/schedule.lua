-- schedule UI component implemented in lua
require "Resources\\sampler\\components\\luaview"
require "Resources\\sampler\\components\\tabview"
require "Resources\\sampler\\components\\flowview"

ScheduleView = LuaView:New();

function ScheduleView:Init()
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
	self.frame.layer = 3

	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)
		end

	parent:AddComponent(self.frame)

	local tabviewframe = View()
	self.tabviewframe = tabviewframe;
	self.tabviewframe.Name = "tabviewframe"

	self.tabviewframe.X = 10;
	self.tabviewframe.Y = 300;
	self.tabviewframe.Width = 460
	self.tabviewframe.Height = 290
	self.tabviewframe.alpha = 155
	self.tabviewframe.layer = 3

	self.frame:AddComponent(self.tabviewframe)


	local tabView = Tabview:New("tabView", GetFont("default"));
    self.tabView = tabView;
	tabView.frame.relative = true
	tabView.frame.X = 15;
	tabView.frame.Y = 0;
	tabView.frame.Width = self.tabviewframe.Width;
	tabView.frame.Height = self.tabviewframe.Height - 50;
	tabView.frame.layer = 5;
	tabviewframe:AddComponent(tabView.frame);
	tabView:Show();


	local background = ImageWindow()
	background.name = "backround"
	background.relative = true;
	background.width = self.tabviewframe.width - 10;
	background.height = self.tabviewframe.height - 50 - 50;
	background.x = 5;
	background.y = 50;
    background.WindowTexture = "Resources/sampler/resources/window.png"
    background.RectSize = 40
    background.BackgroundColor = 0xFFFFFF
	background.alpha = 255
	background.layer = 4;
	tabviewframe:AddComponent(background);

    local upButton = self:CreateUpButton(
        function()
            if (self.upButtonEvent ~= nil) then
                self.upButtonEvent();
            end
        end
    );
    upButton.x = background.width - 30 + background.x;
    upButton.y = 10 + background.y;
    tabviewframe:AddComponent(upButton);

    local downButton = self:CreateDownButton(
        function()
            if (self.downButtonEvent ~= nil) then
                self.downButtonEvent();
            end
        end
    );
    downButton.x = background.width - 30 + background.x;
    downButton.y = background.height - 20 + background.y;
    tabviewframe:AddComponent(downButton);

	local educationView = Flowview:New("educationview")
	educationView.frame.relative = true;
	educationView.frame.width = tabView.frame.width - 10;
	educationView.frame.height = tabView.frame.height - 50 - 50;
	educationView.frame.x = 5;
	educationView.frame.y = 50;
	educationView.frame.layer = 10;
	educationView.spacing = 5;
	educationView.padding = 10;
	educationView.frame.visible = true;
	educationView.frame.enabled = true;
	self.educationView = educationView;
	tabView:AddTab("education", educationView.frame);

	local workView = Flowview:New("workview")
	workView.frame.relative = true;
	workView.frame.width = tabView.frame.width - 10;
	workView.frame.height = tabView.frame.height - 50 - 50;
	workView.frame.x = 5;
	workView.frame.y = 50;
	workView.frame.alpha = 155
	workView.frame.layer = 4;
	workView.spacing = 5;
	workView.padding = 10;
	workView.frame.visible = false;
	workView.frame.enabled = false;
	self.workView = workView;
	tabView:AddTab("work", workView.frame);

	local vacationView = Flowview:New("vacationview");
	vacationView.frame.relative = true;
	vacationView.frame.width = tabView.frame.width - 10;
	vacationView.frame.height = tabView.frame.height - 50 - 50;
	vacationView.frame.x = 5;
	vacationView.frame.y = 50;
	vacationView.frame.alpha = 155
	vacationView.frame.layer = 4;
	vacationView.spacing = 5;
	vacationView.padding = 10;
	vacationView.frame.visible = false;
	vacationView.frame.enabled = false;
	self.vacationView = vacationView;
	tabView:AddTab("vacation", vacationView.frame);

	local repeatButton = self:CreateButton("Repeat",
		function (repeatButton, luaevent, args)
            if (self.executeEvent~=nil) then
                self.repeatEvent(repeatButton, luaevent, args);
            end
		end)
	repeatButton.Layer = 4;
	repeatButton.X = tabviewframe.width - 105;
	repeatButton.Y = tabviewframe.height - 45;
	self.repeatButton = repeatButton
	tabviewframe:AddComponent(repeatButton);

	local selectionframe = ImageWindow()
	self.selectionframe = selectionframe;
	selectionframe.Name = "selectionframe"

	selectionframe.X = 475;
	selectionframe.Y = 315;
    selectionframe.WindowTexture = "Resources/sampler/resources/window.png"
    selectionframe.RectSize = 40
    selectionframe.BackgroundColor = 0xFFFFFF
	selectionframe.Width = 320
	selectionframe.Height = 80
	selectionframe.alpha = 255
	selectionframe.layer = 3

	self.frame:AddComponent(selectionframe)

	local selectedItemsView = Flowview:New("selectedItemsView");
	selectedItemsView.frame.relative = true;
	selectedItemsView.frame.width = selectionframe.width - 10;
	selectedItemsView.frame.height = selectionframe.height;
	selectedItemsView.frame.x = 5;
	selectedItemsView.frame.y = 5;
	selectedItemsView.frame.alpha = 155
	selectedItemsView.frame.layer = 4;
	selectedItemsView.spacing = 30;
	selectedItemsView.padding = 10;
	selectedItemsView.frame.visible = true;
	selectedItemsView.frame.enabled = true;
	self.selectedItemsView = selectedItemsView;
	selectionframe:AddComponent(selectedItemsView.frame);

	local closeButton = self:CreateButton("Close",
		function (closeButton, luaevent, args)
            self:Dispose();
		end)
	closeButton.Layer = 4;
	closeButton.X = selectionframe.x + 7;
	closeButton.Y = selectionframe.y + selectionframe.height;
	self.closeButton = closeButton
	self.frame:AddComponent(closeButton);


	local deleteButton = self:CreateButton("Delete",
		function (deleteButton, luaevent, args)
            if (self.deleteEvent ~= nil) then
                self.deleteEvent(deleteButton, luaevent, args);
            end
		end)
	deleteButton.Layer = 4;
	deleteButton.X = selectionframe.x + 110;
	deleteButton.Y = selectionframe.y + selectionframe.height;
	self.deleteButton = deleteButton
	self.frame:AddComponent(deleteButton);

	local executeButton = self:CreateButton("Run",
		function (executeButton, luaevent, args)
            if (self.executeEvent~=nil) then
                self.executeEvent(executeButton, luaevent, args);
            end
		end)
	executeButton.Layer = 4;
	executeButton.X = selectionframe.x + 213;
	executeButton.Y = selectionframe.y + selectionframe.height;
	self.executeButton = executeButton
	self.frame:AddComponent(executeButton);


	local detailviewframe = ImageWindow()
	self.detailviewframe = detailviewframe;
	detailviewframe.Name = "detailviewframe"
	detailviewframe.font = font;
	detailviewframe.X = 475;
	detailviewframe.Y = 440;
    detailviewframe.WindowTexture = "Resources/sampler/resources/window.png"
    detailviewframe.RectSize = 40
    detailviewframe.BackgroundColor = 0xFFFFFF
    detailviewframe.linespacing = 10
    detailviewframe.margin = 15
    detailviewframe.leftmargin = 15
	detailviewframe.Width = 320
	detailviewframe.Height = 150
	detailviewframe.alpha = 255
	detailviewframe.layer = 3

	self.frame:AddComponent(detailviewframe)

end

function ScheduleView:CreateUpButton(event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = "upButton";
	newButton.Texture = "Resources/sampler/resources/up.png"
	newButton.Layer = 15
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 18;
	newButton.Height = 12;
	newButton.State = {}
	newButton.MouseDown =
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
			newButton.Pushed = true
		end
	newButton.MouseUp =
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
                if (event~=nil) then
					event(button, luaevent, args);
				end
			end
		end
	newButton.TextColor = 0xEEEEEE
	return newButton;
end

function ScheduleView:CreateDownButton(event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = "downButotn";
	newButton.Texture = "Resources/sampler/resources/down.png"
	newButton.Layer = 15
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 18;
	newButton.Height = 12;
	newButton.State = {}
	newButton.MouseDown =
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
			newButton.Pushed = true
		end
	newButton.MouseUp =
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
                if (event~=nil) then
					event(button, luaevent, args);
				end
			end
		end
	newButton.TextColor = 0xEEEEEE
	return newButton;
end

function ScheduleView:CreateButton(buttonText, event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonText;
	newButton.Texture = "Resources/sampler/resources/button/button.png"
	newButton.Layer = 3
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 100;
	newButton.Height = 40;
	newButton.State = {}
	newButton.MouseDown =
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
			newButton.Pushed = true
		end
	newButton.MouseUp =
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
                if (event~=nil) then
					event(button, luaevent, args);
				end
			end
		end
	newButton.Text = buttonText;
	newButton.Font = GetFont("menu"); --menuFont
	newButton.TextColor = 0xEEEEEE
	return newButton;
end

function ScheduleView:CreateSelectedButton(buttonName, buttonText)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonName;
	newButton.Texture = "Resources/sampler/resources/button.png"
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
	newButton.Text = buttonText;
	newButton.Font = self.font;
	newButton.TextColor = 0xEEEEEE
	return newButton;
end

function ScheduleView:AddEducationItem(id, text, price, icon)
	self.educationView:Add(self:CreateItem(id, text, price, icon));
end

function ScheduleView:AddWorkItem(id, text, price, icon)
	self.workView:Add(self:CreateItem(id, text, price, icon));
end

function ScheduleView:AddVacationItem(id, text, price, icon)
	self.vacationView:Add(self:CreateItem(id, text, price, icon));
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

function ScheduleView:SetRepeatingEvent(event)
	self.repeatEvent = event;
end

function ScheduleView:SetExecutingEvent(event)
	self.executeEvent = event;
end

function ScheduleView:SetDeletingEvent(event)
	self.deleteEvent = event;
end

function ScheduleView:SetSelectedEvent(event)
	self.selectedEvent = event;
end

function ScheduleView:SetSelectedFocusEvent(event)
	self.selectedFocusEvent = event;
end

function ScheduleView:CreateSelectedItem(id, icon)
	local pic = Button();
	pic.Name = id;
	pic.Texture = icon
	pic.Visible = true;
	pic.Width = 48;
	pic.Height = 48;
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
			Trace("mouse down!");
			button.State["mouseDown"] = true
			button.Pushed = true;
		end
	pic.MouseUp =
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				Trace("mouse up!");
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
    return self.tabView:GetEnabledTab()
end

function ScheduleView:SetUpButtonEvent(event)
    self.upButtonEvent = event;
end

function ScheduleView:SetDownButtonEvent(event)
    self.downButtonEvent = event;
end
function ScheduleView:EnableRun(enable)
    self.executeButton.Enabled = enable;
end
