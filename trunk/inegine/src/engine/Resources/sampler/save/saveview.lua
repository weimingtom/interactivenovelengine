LoadScript "components\\luaview.lua"
LoadScript "components\\selector.lua"

SaveView = LuaView:New();

function SaveView:Init()
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local font = GetFont("default")
	local name = self.name;
	
    
	self.nextx = 30
	self.nexty = 30

	self.slotList = {}

	self.frame = View()
	self.frame.Name = name
	
	self.frame.Width = GetWidth();--450
	self.frame.Height = GetHeight();--240
	self.frame.x = 0;--(GetWidth() - self.frame.Width) / 2;
	self.frame.y = 0;--(GetHeight() - self.frame.Height) / 2;
	self.frame.alpha = 155
	self.frame.layer = 3
	
	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)	
		end
	
	parent:AddComponent(self.frame)
	
	local saveLoadWindow = View()
	saveLoadWindow.name = "saveLoadWindow"
	saveLoadWindow.relative = true;
	saveLoadWindow.width = 480
	saveLoadWindow.height = 310
	--saveLoadWindow.leftMargin = 90;
	--saveLoadWindow.margin = 12;
	--saveLoadWindow.font = GetFont("smalldefault");
    --saveLoadWindow.linespacing = 5
	saveLoadWindow.x = (self.frame.width - saveLoadWindow.width) / 2;
	saveLoadWindow.y = (self.frame.height - saveLoadWindow.height) / 2;
    --saveLoadWindow.WindowTexture = "resources/window.png"
    --saveLoadWindow.RectSize = 40
    --saveLoadWindow.backgroundColor = 0xFFFFFF
	saveLoadWindow.alpha = 255
	saveLoadWindow.layer = 6;
	self.saveLoadWindow = saveLoadWindow;
	self.frame:AddComponent(saveLoadWindow);


	self.closeButton = self:CreateButton("closeButton", "Close", 
        function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false
				Trace("button click!")
				self:Dispose();
			end
		end)
    self.closeButton.x = saveLoadWindow.x + saveLoadWindow.width - 110;
    self.closeButton.y = saveLoadWindow.y + saveLoadWindow.height + 5
	self.frame:AddComponent(self.closeButton);

	self.loadButton = self:CreateButton("loadButton", "Load", 
        function (button, luaevent, args)
            if (self.loadEvent ~= nil) then
                self.loadEvent();
            end
		end)
    self.loadButton.x = saveLoadWindow.x + saveLoadWindow.width - 110 - 110;
    self.loadButton.y = saveLoadWindow.y + saveLoadWindow.height + 5
	self.frame:AddComponent(self.loadButton);

	if (self.showSave == nil or self.showSave == true) then

		self.saveButton = self:CreateButton("saveButton", "Save", 
			function (button, luaevent, args)
				if (self.saveEvent ~= nil) then
					self.saveEvent();
				end
			end)
		self.saveButton.x = saveLoadWindow.x + saveLoadWindow.width - 110 - 110 * 2;
		self.saveButton.y = saveLoadWindow.y + saveLoadWindow.height + 5
		self.frame:AddComponent(self.saveButton);
	end

	if (self.showTitle == nil or self.showTitle == true) then

		self.titleButton = self:CreateButton("titleButton", "Title", 
			function (button, luaevent, args)
				if (self.titleEvent ~= nil) then
					self.titleEvent();
				end
			end)
		self.titleButton.x = saveLoadWindow.x + saveLoadWindow.width - 110 - 110 * 3;
		self.titleButton.y = saveLoadWindow.y + saveLoadWindow.height + 5
		self.frame:AddComponent(self.titleButton);
	end

end

function SaveView:CreateButton(buttonName, buttonText, event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonName;
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

function SaveView:AddSlot(id, text)
	local newSlot = TextWindow()
    newSlot.name = id;
    newSlot.x = self.nextx;
    newSlot.y = self.nexty;
	newSlot.Width = 420
	newSlot.Height = 50
    newSlot.Margin = 15
	newSlot.Font = GetFont("default");
	newSlot.BackgroundColor = 0x000000
	newSlot.Text = text
    newSlot.Alpha = 155
    newSlot.MouseClick = function()
        self:SelectSlot(id);
    end
	self.saveLoadWindow:AddComponent(newSlot)
    
    self.nexty = newSlot.y + newSlot.height + 5;
	table.insert(self.slotList, id)
end

function SaveView:SelectSlot(id)
    for i,v in ipairs(self.slotList) do 
		local slot = self.saveLoadWindow:GetComponent(v);
        if (id == v) then        
			slot.Alpha = 155
	        slot.BackgroundColor = 0x999999
        else
			slot.Alpha = 155
	        slot.BackgroundColor = 0x000000
        end
	end

    if (self.selectEvent ~= nil) then
        self.selectEvent(id);
    end
end

function SaveView:SetSelectedEvent(event)
    self.selectEvent = event;
end

function SaveView:SetSaveEvent(event)
    self.saveEvent = event;
end

function SaveView:SetLoadEvent(event)
    self.loadEvent = event;
end

function SaveView:SetTitleEvent(event)
    self.titleEvent = event;
end

function SaveView:Clear()
	for i,v in ipairs(self.slotList) do 
		self.saveLoadWindow:RemoveComponent(v) 
	end
	self.slotList = {}
	self.nextx = 30
	self.nexty = 30
end