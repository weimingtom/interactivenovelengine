--title state
--Import
LoadScript "Resources\\sampler\\models\\logmanager.lua"
LoadScript "Resources\\sampler\\components\\flowview.lua"

LogState = {}

function LogState:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self

	self.gamestate = CurrentState();

	self.numItems = 0;
	self.itemsPerPage = 12;
	self.currentLine = 0;
	self:Bottom();
	
    self:InitComponents()
    self:RegisterEvents()
    
	return o
end

--Component initialization
function LogState:InitComponents()
	local gamestate = self.gamestate;
	
	self:SetBackground("Resources/sampler/resources/images/title.jpg");
	
	local view = View();
	self.view = view;
	view.name = "view";
	view.x = 0;
	view.y = 0;
	view.Width = GetWidth();
	view.Height = GetHeight();
	AddComponent(view);
	view:Show();
	view.Layer = 10;
	
	local background = ImageWindow()
	background.name = "backround"
	background.relative = true;
	background.width = self.view.width - 100;
	background.height = self.view.height - 150;
	background.x = 50;
	background.y = 50;
    background.WindowTexture = "Resources/sampler/resources/parchmentwindow.png"
    background.RectSize = 40
    background.BackgroundColor = 0xFFFFFF
	background.alpha = 255
	background.layer = 4;
	view:AddComponent(background);

	local logList = Flowview:New("logList")
	logList.frame.relative = true;
	logList.frame.width = background.width - 10;
	logList.frame.height = background.height - 10;
	logList.frame.x = 5;
	logList.frame.y = 5;
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
    upButton.x = background.width - 60;
    upButton.y = 30;
    background:AddComponent(upButton);

    local downButton = self:CreateDownButton(
        function()
            self:Down();
        end
    );
    self.downButton = downButton;
    downButton.x = background.width - 60;
    downButton.y = background.height - 30;
    background:AddComponent(downButton);

	local box = self:CreateBox();
	self.box = box;
	background:AddComponent(box);
	
	self.closeButton = self:CreateButton("Close", 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false
				Trace("button click!")
				self:Dispose();
			end
		end)
    self.closeButton.x = background.x + background.width - 110;
    self.closeButton.y = background.y + background.height + 5
	view:AddComponent(self.closeButton);
end

function LogState:Dispose()
	CloseState();
end

function LogState:SetBoxPosition()
	Trace(self.currentLine .. "/" .. logManager:GetSize());
	
	local percentage = 0;
	if (logManager:GetSize() <= self.itemsPerPage or self.currentLine == 0) then
		percentage = 0;
	else
		percentage = (self.currentLine + self.itemsPerPage) / (logManager:GetSize());
	end
	
	Trace("[" .. percentage .. "]");
	
	self.box.x = self.upButton.x;
	self.box.y = self.upButton.y + self.upButton.height + 20 +
		(self.downButton.y - (self.upButton.y + self.upButton.height) - self.downButton.height - 40) * percentage;
end

function LogState:Up()
	if (self.currentLine > 0) then
		self.currentLine = self.currentLine - 1;
		self:AddItems();
    end
end

function LogState:Down()
	if (self.currentLine < logManager:GetSize() - self.itemsPerPage) then
		self.currentLine = self.currentLine + 1;
		self:AddItems();
	end
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
	self.logList:Add(self:CreateDateItem(self.numItems, 400, 30, year, month, week));
	self.numItems = self.numItems + 1;
end

function LogState:AddLine(line, name, face)
	if (name ~= nil) then
		Trace("[[[" .. name .. ":" .. line .. "]]]");
	else
		Trace("[[[ " .. ":" .. line .. "]]]");
	end
	
	self.logList:Add(self:CreateLineItem(self.numItems, 400, 30, name, face, line));
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
	newButton.Texture = "Resources/sampler/resources/box.png"
	newButton.Layer = 15
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 18;
	newButton.Height = 12;
	return newButton;
end

function LogState:CreateUpButton(event)
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

function LogState:CreateDownButton(event)
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


function LogState:CreateButton(buttonText, event)
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
	button.TextColor = 0xFF0000
	button.Text = "<year " .. year .. " month " .. month .. " week " .. week .. ">";
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