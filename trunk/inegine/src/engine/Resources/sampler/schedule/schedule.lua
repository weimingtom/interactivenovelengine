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
	
	local tabviewframe = TextWindow()
	self.tabviewframe = tabviewframe;
	self.tabviewframe.Name = "tabviewframe"
	
	self.tabviewframe.X = 10;
	self.tabviewframe.Y = 300;
	self.tabviewframe.Width = 400
	self.tabviewframe.Height = 290
	self.tabviewframe.alpha = 155
	self.tabviewframe.layer = 3
	
	self.frame:AddComponent(self.tabviewframe)
	
	
	local tabView = Tabview:New("tabView", GetFont("default"));
	tabView.frame.relative = true
	tabView.frame.X = 0;
	tabView.frame.Y = 0;
	tabView.frame.Width = self.tabviewframe.Width;
	tabView.frame.Height = self.tabviewframe.Height - 50;
	tabView.frame.layer = 5;
	tabviewframe:AddComponent(tabView.frame);
	tabView:Show();
	
	
	local background = TextWindow()
	background.name = "backround"
	background.relative = true;
	background.width = self.tabviewframe.width - 10;
	background.height = self.tabviewframe.height - 50 - 50;
	background.x = 5;
	background.y = 50;
	background.alpha = 155
	background.layer = 4;
	tabviewframe:AddComponent(background);
		
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

	local repeatButton = Button()
	repeatButton.Relative = true;
	repeatButton.Name = "repeatButton"
	repeatButton.Texture = "Resources/sampler/resources/button.png"	
	repeatButton.Layer = 4;
	repeatButton.X = tabviewframe.width - 125;
	repeatButton.Y = tabviewframe.height - 45;
	repeatButton.Width = 120;
	repeatButton.Height = 40;
	repeatButton.State = {}
	repeatButton.MouseDown = 
		function (repeatButton, luaevent, args)
			repeatButton.State["mouseDown"] = true
			repeatButton.Pushed = true
		end
	repeatButton.MouseUp = 
		function (repeatButton, luaevent, args)
			if (repeatButton.State["mouseDown"]) then
				repeatButton.Pushed = false
				Trace("repeatButton click!")
                if (self.executeEvent~=nil) then 
                    self.repeatEvent(repeatButton, luaevent, args);
                end
			end
		end
	repeatButton.Text = "Repeat";
	repeatButton.Font = font
	repeatButton.TextColor = 0xEEEEEE
	
	self.repeatButton = repeatButton
	tabviewframe:AddComponent(repeatButton);
	
	local selectionframe = TextWindow()
	self.selectionframe = selectionframe;
	selectionframe.Name = "selectionframe"
	
	selectionframe.X = 415;
	selectionframe.Y = 200;
	selectionframe.Width = 380
	selectionframe.Height = 230
	selectionframe.alpha = 155
	selectionframe.layer = 3
	
	self.frame:AddComponent(selectionframe)
	
	local selectedItemsView = Flowview:New("selectedItemsView");
	selectedItemsView.frame.relative = true;
	selectedItemsView.frame.width = selectionframe.width - 10;
	selectedItemsView.frame.height = selectionframe.height - 55;
	selectedItemsView.frame.x = 5;
	selectedItemsView.frame.y = 5;
	selectedItemsView.frame.alpha = 155
	selectedItemsView.frame.layer = 4;	
	selectedItemsView.spacing = 5;
	selectedItemsView.padding = 10;
	selectedItemsView.frame.visible = true;
	selectedItemsView.frame.enabled = true;
	self.selectedItemsView = selectedItemsView;
	selectionframe:AddComponent(selectedItemsView.frame);

	local closeButton = Button()
	closeButton.Relative = true;
	closeButton.Name = "closeButton"
	closeButton.Texture = "Resources/sampler/resources/button.png"	
	closeButton.Layer = 4;
	closeButton.X = 5;
	closeButton.Y = selectionframe.height - 45;
	closeButton.Width = 120;
	closeButton.Height = 40;
	closeButton.State = {}
	closeButton.MouseDown = 
		function (closeButton, luaevent, args)
			closeButton.State["mouseDown"] = true
			closeButton.Pushed = true
		end
	closeButton.MouseUp = 
		function (closeButton, luaevent, args)
			if (closeButton.State["mouseDown"]) then
				closeButton.Pushed = false
				Trace("closeButton click!")
                self:Dispose();
			end
		end
	closeButton.Text = "Close";
	closeButton.Font = font
	closeButton.TextColor = 0xEEEEEE
	
	self.closebutton = closeButton;
	selectionframe:AddComponent(closeButton);
	
	
	local deleteButton = Button()
	deleteButton.Relative = true;
	deleteButton.Name = "deleteButton"
	deleteButton.Texture = "Resources/sampler/resources/button.png"	
	deleteButton.Layer = 4;
	deleteButton.X = 130;
	deleteButton.Y = selectionframe.height - 45;
	deleteButton.Width = 120;
	deleteButton.Height = 40;
	deleteButton.State = {}
	deleteButton.MouseDown = 
		function (deleteButton, luaevent, args)
			deleteButton.State["mouseDown"] = true
			deleteButton.Pushed = true
		end
	deleteButton.MouseUp = 
		function (deleteButton, luaevent, args)
			if (deleteButton.State["mouseDown"]) then
				deleteButton.Pushed = false
				Trace("deleteButton click!")
                self.deleteEvent(deleteButton, luaevent, args);
			end
		end
	deleteButton.Text = "Delete";
	deleteButton.Font = font
	deleteButton.TextColor = 0xEEEEEE
	
	self.deleteButton = deleteButton;
	selectionframe:AddComponent(deleteButton);
	
	local executeButton = Button()
	executeButton.Relative = true;
	executeButton.Name = "executeButton"
	executeButton.Texture = "Resources/sampler/resources/button.png"	
	executeButton.Layer = 4;
	executeButton.X = 255;
	executeButton.Y = selectionframe.height - 45;
	executeButton.Width = 120;
	executeButton.Height = 40;
	executeButton.State = {}
	executeButton.MouseDown = 
		function (executeButton, luaevent, args)
			executeButton.State["mouseDown"] = true
			executeButton.Pushed = true
		end
	executeButton.MouseUp = 
		function (executeButton, luaevent, args)
			if (executeButton.State["mouseDown"]) then
				executeButton.Pushed = false
				Trace("executeButton click!")
                if (self.executeEvent~=nil) then 
                    self.executeEvent(executeButton, luaevent, args);
                end
			end
		end
	executeButton.Text = "Run";
	executeButton.Font = font
	executeButton.TextColor = 0xEEEEEE
	
	self.executeButton = executeButton;
	selectionframe:AddComponent(executeButton);
	
	
	local detailviewframe = TextWindow()
	self.detailviewframe = detailviewframe;
	detailviewframe.Name = "detailviewframe"
	detailviewframe.font = font;
	detailviewframe.X = 415;
	detailviewframe.Y = 440;
	detailviewframe.Width = 380
	detailviewframe.Height = 150
	detailviewframe.alpha = 155
	detailviewframe.layer = 3
	
	self.frame:AddComponent(detailviewframe)
	
end


function ScheduleView:CreateButton(buttonName, buttonText)
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
			newButton.Pushed = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
				self.selectedEvent(button, luaevent, args);
			end
		end
	newButton.Text = buttonText;
	newButton.Font = self.font;
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
			--ewButton.Pushed = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				--button.Pushed = false;
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
	button.Width = 80;
	button.Height = 15;
	button.X = 5;
	button.Y = pic.Height;
	button.font = GetFont("verysmall");
	button.TextColor = 0xFFFFFF
	button.Text = text;
	button.Alignment = 1;
	button.VerticalAlignment = 1;
	frame:AddComponent(button);
	
	
	local priceButton = Button();
	priceButton.Name = "price"
	priceButton.Width = 80;
	priceButton.Height = 15;
	priceButton.X = 5;
	priceButton.Y = button.Y + button.Height;
	priceButton.font = GetFont("verysmall");
	priceButton.TextColor = 0xFFFFFF
	priceButton.Text = price;
	priceButton.Alignment = 1;
	priceButton.VerticalAlignment = 1;
	frame:AddComponent(priceButton);
	return frame;
end