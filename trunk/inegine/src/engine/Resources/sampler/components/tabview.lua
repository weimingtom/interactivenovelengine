-- selection UI component implemented in lua

Tabview = {}

function Tabview:New (name, font)
	local o = {};
	setmetatable(o, self)
	self.__index = self;
	o.name = name;
	o.font = font;
	
	o:Init();
	
	return o;	
end

function Tabview:Init()
	self.tabList = {}
	self.viewList = {}
	self.tabCount = 0
	
	self.buttonWidth = 120;
	self.buttonHeight = 40;
	
	self.frame = View()
	self.frame.relative = true;
	self.frame.Name = self.name;
	self.frame.Width = 400
	self.frame.Height = 430
	self.frame.alpha = 155
	self.frame.layer = 7
	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)	
		end
end

function Tabview:Dispose()
	--self.parent:RemoveComponent(self.name)
end

function Tabview:Show()
	self.frame.Visible = true
	self.frame.Enabled = true
end


function Tabview:Hide()
	self.frame.Visible = false
	self.frame.Enabled = false
end

function Tabview:AddTab(name, view)
	table.insert(self.tabList, name)
	table.insert(self.viewList, view.name);
	
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = name;
	newButton.Texture = "Resources/sampler/resources/button.png"	
	newButton.Layer = 6;
	newButton.X = 5 + self.tabCount * (self.buttonWidth + 2);
	newButton.Y = 10;
	newButton.pushed = true;
	newButton.Width = self.buttonWidth;
	newButton.Height = self.buttonHeight;
	newButton.State = {}
	newButton.Text = name;
	newButton.Font = self.font
	newButton.TextColor = 0xEEEEEE
	newButton.MouseUp = 
		function (target, luaevent, args) 
			self:ButtonClicked(target, luaevent, args);
		end
	self.frame:AddComponent(newButton);
	
	view.relative = true;
	view.layer = 7;
	view.visible = false;
	view.enabled = false;
	
	self.frame:AddComponent(view);
		
	if (self.tabCount == 0) then
		self:SetEnabledView(name);
	end
	
	self.tabCount = self.tabCount + 1;
end

function Tabview:Trace()
	for i,v in ipairs(self.tabList) 
		do Trace(v) 
	end
end

function Tabview:Clear()
	for i,v in ipairs(self.tabList) do 
		self.frame:RemoveComponent(v)
		self.frame:RemoveComponent(self.viewList[i]) 
	end
	self.tabList = {}
	self.viewList = {}
	self.tabCount = 0
end

function Tabview:ButtonClicked(target, luaevent, args)
	Trace("button clicked!!! " .. target.name);
	self:SetEnabledView(target.name);
end

function Tabview:SetEnabledView(name)
	for i,v in ipairs(self.tabList) do 
		local button = self.frame:GetComponent(v);
		local view = self.frame:GetComponent(self.viewList[i]);
		if (v == name) then
			button.pushed = false;
			view.enabled = true;
			view.visible = true;
		else
			button.pushed = true;
			view.enabled = false;
			view.visible = false;
		end
	end
end