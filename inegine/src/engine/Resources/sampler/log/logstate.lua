--title state
--Import
LoadScript "models\\logmanager.lua"
LoadScript "components\\flowview.lua"

LogState = {}

function LogState:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self

	self.gamestate = CurrentState();

	self.numItems = 0;
	self.itemsPerPage = 14;
	self.currentLine = 0;
	self.scrollUnit = 6;
	self:Bottom();
	
    self:InitComponents()
    self:RegisterEvents()
    
	return o
end

--Component initialization
function LogState:InitComponents()
	local gamestate = self.gamestate;
	
	self:SetBackground("resources/images/title.jpg");
	
	local view = View();
	self.view = view;
	view.name = "view";
	view.x = 0;
	view.y = 0;
	view.BackgroundColor = 0x000000
	view.Alpha = 155
	view.Width = GetWidth();
	view.Height = GetHeight();
	AddComponent(view);
	view:Show();
	view.Layer = 10;
	
	local background = SpriteBase()
	background.name = "backround"
	background.relative = true;
	background.width = self.view.width
	background.height = self.view.height
	background.texture = "resources/ui/log_window.png"
	background.layer = 4;
	view:AddComponent(background);

	local logList = Flowview:New("logList")
	logList.frame.relative = true;
	logList.frame.width = 610
	logList.frame.height = 510
	logList.frame.x = 90
	logList.frame.y = 30
	logList.frame.layer = 10;
	logList.spacing = 5;
	logList.padding = 10;
	logList.frame.visible = true;
	logList.frame.enabled = true;
	self.logList = logList;
	
	background:AddComponent(logList.frame);
	
    local upButton = self:CreateUpButton(
        function()
			self:Up();
        end
    );
    self.upButton = upButton;
    upButton.x = 703
    upButton.y = 25
    background:AddComponent(upButton);

    local downButton = self:CreateDownButton(
        function()
            self:Down();
        end
    );
    self.downButton = downButton;
    downButton.x = 707
    downButton.y = 516
    background:AddComponent(downButton);

	local box = self:CreateBox();
	self.box = box;
	background:AddComponent(box);
	
	self.backButton = UIFactory.CreateBackButton(
		function (button, luaevent, args)
			self:Dispose();
		end
	)
	self.backButton.X = 730
	self.backButton.Y = 454
	self.backButton.Layer = 10
	background:AddComponent(self.backButton);

end

function LogState:Dispose()
	CloseState();
end

function LogState:SetBoxPosition()
	local percentage = 0;
	if (logManager:GetSize() <= self.itemsPerPage or self.currentLine == 0) then
		percentage = 0;
	else
		percentage = (self.currentLine + self.itemsPerPage) / (logManager:GetSize());
	end
	
	
	self.box.x = 707;
	self.box.y = ((self.downButton.y - self.upButton.y - self.upButton.height - 20) - self.box.height) * percentage + self.upButton.y + self.upButton.height + 10;
end

function LogState:Up()
	self.currentLine = self.currentLine - self.scrollUnit;
	if (self.currentLine < 0) then
		self.currentLine = 0;
    end
	self:AddItems();
end

function LogState:Down()
	self.currentLine = self.currentLine + self.scrollUnit;
	if (self.currentLine > logManager:GetSize() - self.itemsPerPage) then
		self.currentLine = logManager:GetSize() - self.itemsPerPage
	end
	self:AddItems();
end

function LogState:Bottom()
	self.currentLine = logManager:GetSize() - self.itemsPerPage;
end

function LogState:RegisterEvents()
	CurrentState().KeyDown = function(handler, luaevent, args) 
		self:KeyDown(handler, luaevent, args);
	end
end

function LogState:KeyDown(handler, luaevent, args)
	if (self.keyDownEvent ~= nil) then
		self.keyDownEvent(handler, luaevent, args);
	end
end

function LogState:SetBackground(filename)
	if (GetComponent("background") ~= nil) then
		RemoveComponent("background");
	end
	
	local background = SpriteBase();
	background.Name = "background";
	background.Texture = filename
	background.Visible = true;
	background.Layer = 0;
	InitComponent(background);
end

function LogState:AddDate(year, month, week)
	self.logList:Add(self:CreateDateItem(self.numItems, 590, 30, year, month, week));
	self.numItems = self.numItems + 1;
end

function LogState:AddLine(line, name, face)	
	self.logList:Add(self:CreateLineItem(self.numItems, 590, 30, name, face, line));
	self.numItems = self.numItems + 1;
end

function LogState:Clear()
	self.numItems = 0;
	self.logList:Clear();
end

function LogState:AddItems()
	self:Clear();

	local startIndex = self.currentLine;
	local endIndex = startIndex + self.itemsPerPage - 1;
	for i=startIndex, endIndex do
		local line = logManager:GetLine(i);
        if (line ~= nil) then
			if (line.date ~= nil) then
				self:AddDate(line.date.year, line.date.month, line.date.week);
			end

			if (line.name ~= nil and line.line ~= nil) then
				self:AddLine(line.line, line.name, nil);
			elseif (line.line ~= nil) then
				self:AddLine(line.line);
			end
       end
	end
	
	self:SetBoxPosition();
end

function LogState:CreateBox()
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = "boxButton";
	newButton.Texture = "resources/ui/scrollbar.png"
	newButton.Layer = 15
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 16;
	newButton.Height = 203;
	return newButton;
end

function LogState:CreateUpButton(event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = "upButton";
	newButton.Layer = 15
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 20;
	newButton.Height = 20;
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

function LogState:CreateDownButton(event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = "downButotn";
	newButton.Layer = 15
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 20;
	newButton.Height = 20;
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


function LogState:CreateButton(buttonText, event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonText;
	newButton.Texture = "resources/button/button.png"	
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


function LogState:CreateDateItem(id, width, height, year, month, week)
	local frame = View();
	frame.Name = id;
	frame.Relative = true;
	frame.Width = width;
	frame.Height = height;
	frame.Enabled = true;

	local button = Button();
	button.Name = "text"
	button.Width = width;
	button.Height = height;
	button.X = 0;
	button.Y = 0;
	button.font = GetFont("default");
	button.TextColor = 0xFFFFFF
	button.Text = year.. logstate_year .. month .. logstate_month .. week .. logstate_week;
	button.Alignment = 0;
	button.VerticalAlignment = 1;
	frame:AddComponent(button);

	return frame;
end

function LogState:CreateLineItem(id, width, height, name, face, line)
	local frame = View();
	frame.Name = id;
	frame.Relative = true;
	frame.Width = width;
	frame.Height = height;
	frame.Enabled = true;

	local button = Button();
	button.Name = "name"
	button.Width = width / 4;
	button.Height = height;
	button.X = 0;
	button.Y = 0;
	button.font = GetFont("default");
	button.TextColor = 0xFFFFFF
	button.Text = name;
	button.Alignment = 0;
	button.VerticalAlignment = 0;
	frame:AddComponent(button);

	local button = Button();
	button.Name = "line"
	button.Width = width / 4 * 3;
	button.Height = height;
	button.X = width / 4;
	button.Y = 0;
	button.font = GetFont("default");
	button.TextColor = 0xFFFFFF
	button.Text = line;
	button.Alignment = 0;
	button.VerticalAlignment = 0;
	frame:AddComponent(button);


	return frame;
end

--entry point
logState = LogState:New();
CurrentState().state = logState;

--extra actions
logState:AddItems();