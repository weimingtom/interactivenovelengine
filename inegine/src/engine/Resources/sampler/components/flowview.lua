-- selection UI component implemented in lua

Flowview = {}

function Flowview:New (name)
	local o = {};
	setmetatable(o, self)
	self.__index = self;
	
	o.name = name;
	
	o:Init();
	
	return o;
end

function Flowview:Init()
	self.componentList = {}
	self.viewList = {}
	self.itemCount = 0
	
	self.padding = 40;
	self.spacing = 20;
	
	self.frame = View()
	self.frame.relative = true;
	self.frame.Name = self.name
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

function Flowview:Dispose()
	--self.parent:RemoveComponent(self.name)
end

function Flowview:Show()
	self.frame.Visible = true
	self.frame.Enabled = true
end


function Flowview:Hide()
	self.frame.Visible = false
	self.frame.Enabled = false
end

function Flowview:Add(component)
	table.insert(self.componentList, component.name)
	self.frame:AddComponent(component)
	self:RearrangeComponents()
	self.itemCount = self.itemCount + 1
end

function table.removeItem(tbl, item)
	for i,v in ipairs(tbl) do 
		if (item == v) then
            table.remove(tbl, i)
            return;
        end
	end
end

function Flowview:Remove(componentName)
	table.removeItem(self.componentList, componentName);
	self.frame:RemoveComponent(componentName)
	self:RearrangeComponents()
	self.itemCount = self.itemCount - 1
end

function Flowview:GetItem(componentName)
    return self.frame:GetComponent(componentName);
end

function Flowview:GetItems()
	--for i,v in ipairs(self.componentList) 
	--	do Trace(v) 
	--end
    return self.componentList;
end

function Flowview:Clear()
	for i,v in ipairs(self.componentList) do 
		self.frame:RemoveComponent(self.componentList[i]) 
	end
	self.componentList = {}
	self.itemCount = 0
end

function Flowview:RearrangeComponents()
	local firstItem = true;
	local nextX = 0;
	local nextY = 0;
	local maxHeight = -1;
	for i,v in ipairs(self.componentList) do
		local component = self.frame:GetComponent(self.componentList[i])
		if (component.Height >= maxHeight) then maxHeight = component.Height end;
		if (firstItem) then
			component.X = self.padding;
			component.Y = self.padding;
			firstItem = false;
		else
			if (nextX + component.Width >= self.frame.width) then
				--Trace(component.name .. " is over width!");
				--Trace("width: " .. component.Width)
				nextX = self.padding;
				nextY = nextY + maxHeight + self.spacing;
				maxHeight = -1;
			end
			component.X = nextX;
			component.Y = nextY;
		end 
		nextX = component.X + component.Width + self.spacing;
		if (nextX >= self.frame.width) then
			nextX = self.padding;
			nextY = component.Y + maxHeight + self.spacing;
			maxHeight = -1;
		else
			nextY = component.Y;
		end
	end	
end