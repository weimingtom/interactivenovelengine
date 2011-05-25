-- selection UI component implemented in lua
LoadScript "components\\flowview.lua"

Selector = LuaView:New();

function Selector:Init()
	local gamestate = CurrentState();	
	local parent = self.parent;
	local name = self.name;

	self.selectionList = {}
	self.selectionCount = 0
	self.SelectionHeight = 28
	self.Margin = 10
	self.SelectedIndex = -1
	self.Layer = 0
	
	--self.frame = TextWindow()
	self.frame = SpriteBase()
	self.frame.Name = name
	self.frame.texture = "resources/ui/selector.png"
	self.frame.Alpha = 255
	self.frame.Width = 329
	self.frame.Height = 162
	self.frame.X = 236
	self.frame.Y = 192
	self.frame.Layer = 20
	self.frame.Visible = false
	self.frame.Enabled = false
	AddComponent(self.frame)
	
	local question = Button();
	self.question = question;
	question.x = 40;
	question.Y = 30;
	question.font = GetFont("small");
	question.height = 30;
	question.width = 289;
	question.alignment = 0;
	self.frame:AddComponent(question);
	
	local selectionBox = Flowview:New("dressview")
	selectionBox.frame.relative = true;
	selectionBox.frame.width = 289;
	selectionBox.frame.height = 122;
	selectionBox.frame.x = 35;
	selectionBox.frame.y = 60;
	selectionBox.frame.layer = 4;
	selectionBox.spacing = 0;
	selectionBox.padding = 0;
	self.selectionBox = selectionBox;
	self.frame:AddComponent(self.selectionBox.frame);
	self.selectionBox:Show();
end


function Selector:Remove()
	RemoveComponent(self.frame)
end

function Selector:Show()
	self.frame.Visible = true
	self.frame.Enabled = true
end


function Selector:Hide()
	self.frame.Visible = false
	self.frame.Enabled = false
end

function Selector:Ask(text)
	self.question.text = text;
end

function Selector:SetMouseClick(event)
	self.mouseClick = event;
end

function Selector:GetSelected()
	local result = self.SelectedIndex;
	self:Clear();
	return result;
end

function Selector:Add(text)
	local newSelection = TextWindow()
	newSelection.Name = "selection" .. self.selectionCount;
	newSelection.Alpha = 0
	newSelection.Width = 280;
	newSelection.Height = self.SelectionHeight
	newSelection.Relative = true;
	newSelection.Layer = 6
	newSelection.Margin = 0;
	newSelection.Visible = true
	newSelection.Font = GetFont("selector");
	newSelection.Text = text
	newSelection.TextColor = 0x000000
	newSelection.BackgroundColor = 0xFFFFFF
	--newSelection.Alignment = 0
	--newSelection.VerticalAlignment = 1
	
	local index = self.selectionCount;
	newSelection.MouseClick =
		function(selectionWindow, event, args)
			self.SelectedIndex = index;
			if (self.mouseClick ~= nil) then
				--self:Hide()
				self:mouseClick()
			end
		end
	newSelection.MouseMove =
		function(selectionWindow, event, args)
			newSelection.TextColor = 0xFF0000
		end
	newSelection.MouseLeave =
		function(selectionWindow, event, args)
			newSelection.TextColor = 0x000000
		end
	self.selectionBox:Add(newSelection)
	newSelection:Show();
	table.insert(self.selectionList, newSelection.Name)
	self.selectionCount = self.selectionCount + 1
end

function Selector:List()
	for i,v in ipairs(self.selectionList) 
		do Trace(v) 
	end
end

function Selector:Clear()
	self.selectionBox:Clear();
	self.selectionList = {}
	self.selectionCount = 0
	self.SelectedIndex = -1;
end

