LuaView = {}

function LuaView:New (name, parent)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.parent = parent;
	o.name = name
	self.disposed = false;
	local gamestate = CurrentState();
	
	return o
end

function LuaView:SetClosingEvent(event)
	self.closingEvent = event;
end

function LuaView:Dispose()
	if (self.disposed ~= true) then
		self.parent:RemoveComponent(self.name)
		if (self.closingEvent ~= nil) then 
			self:closingEvent();
		end
	end
	self.disposed = true;
end

function LuaView:Show()
	self.frame.Visible = true
	self.frame.Enabled = true
end

function LuaView:Hide()
	self.frame.Visible = false
	self.frame.Enabled = false
end
