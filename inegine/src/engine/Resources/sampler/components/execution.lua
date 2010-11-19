-- schedule UI component implemented in lua
require "Resources\\sampler\\components\\tabview"
require "Resources\\sampler\\components\\flowview"

ScheduleView = {}

function ExecutionView:New (name, font, parent)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.parent = parent;
	o.name = name
	o.font = font;
	
	o:Init();
	
	return o
end

function ExecutionView:Init()
	local gamestate = CurrentState();
	local parent = self.parent;
	local font = self.font; 
	local name = self.name;
	
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
end

function ExecutionView:Dispose()
	self.parent:RemoveComponent(self.name)
end

function ExecutionView:Show()
	Trace("showing schedule!")
	self.frame.Visible = true
	self.frame.Enabled = true
end


function ExecutionView:Hide()
	self.frame.Visible = false
	self.frame.Enabled = false
end