-- selection UI component implemented in lua

Selector = {}

function Selector:New (name, font)
	local o = {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	self.name = name
	self.selectionList = {}
	self.selectionCount = 0
	self.SelectionHeight = 50
	self.Margin = 10
	self.SelectedIndex = -1
	self.Layer = 0
	local gamestate = CurrentState();
	
	--self.frame = TextWindow()
	self.frame = ImageWindow()
	self.frame.Name = name
	self.frame.Alpha = 155
	self.frame.Width = 320
	self.frame.Height = 240
	self.frame.X = (GetWidth() - self.frame.Width) / 2;
	self.frame.Y = (GetHeight() - self.frame.Height) / 2;
	self.frame.Layer = 0
	self.frame.LineSpacing = 20
	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.Font = font
	self.frame.WindowTexture = "Resources/win.png"
	self.frame.MouseLeave =
		function(selectionWindow, event, args)
			Trace("mouse leave: " .. selectionWindow.Name)	
		end
	
	AddComponent(self.frame)
	
	self.nextx = self.Margin
	self.nexty = self.Margin
	
	return o
end

function Selector:Show()
	Trace("showing selector!")
	self.frame.Layer = self.Layer
	self.frame.Visible = true
	self.frame.Enabled = true
	Trace("layer: " .. self.Layer)
end


function Selector:Hide()
	self.frame.Visible = false
	self.frame.Enabled = false
end


function Selector:Add(text)
	
	local newSelection = TextWindow()
	newSelection.Name = "selection" .. self.selectionCount;
	newSelection.Alpha = 155
	newSelection.Width = self.frame.Width - self.Margin * 2;
	newSelection.Height = self.SelectionHeight
	newSelection.Relative = true;
	newSelection.X = self.nextx;
	newSelection.Y = self.nexty;
	newSelection.Layer = 6
	newSelection.LineSpacing = 20
	newSelection.Visible = true
	newSelection.Font = self.frame.Font
	newSelection.BackgroundColor = 0xFFFFFF
	newSelection.Text = text
	newSelection.CenterText = true
	newSelection.CenterTextVertically = true
	
	local index = self.selectionCount;
	newSelection.MouseClick =
		function(selectionWindow, event, args)
			self.SelectedIndex = index;
			if (self.MouseClick ~= nil) then
				self:Hide()
				self:MouseClick()
			end
		end
	newSelection.MouseUp =
		function(selectionWindow, event, args)
			Trace("mouse up: " .. selectionWindow.Name)	
		end
	newSelection.MouseMove =
		function(selectionWindow, event, args)
			selectionWindow.Alpha = 200
		end
	newSelection.MouseLeave =
		function(selectionWindow, event, args)
			selectionWindow.Alpha = 155
		end
	self.frame:AddComponent(newSelection)
	
	table.insert(self.selectionList, newSelection.Name)
	self.selectionCount = self.selectionCount + 1
	self.nexty = self.nexty + newSelection.Height + self.Margin
	self:SetDimensions()
end

function Selector:SetDimensions()
	self.frame.Height = self.nexty
	self.frame.X = (GetWidth() - self.frame.Width) / 2;
	self.frame.Y = (GetHeight() - self.frame.Height) / 2;
end

function Selector:List()
	for i,v in ipairs(self.selectionList) 
		do Trace(v) 
	end
end

function Selector:Clear()
	for i,v in ipairs(self.selectionList) do 
		self.frame:RemoveComponent(v) 
	end
	self.selectionList = {}
	self.selectionCount = 0
	self.nextx = self.Margin
	self.nexty = self.Margin
end

