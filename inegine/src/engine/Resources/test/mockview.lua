function View()
    return Mockview:New()
end

Mockview = {}

function Mockview:New()
	local o = {};
	setmetatable(o, self)
	self.__index = self;
	
	o.name = name;
    o.components = {};
    o.width = 400;
    o.height = 400;
	return o;
end

function table.removeItem(tbl, item)
	for i,v in ipairs(tbl) do 
		if (item == v) then
            table.remove(tbl, i)
            return;
        end
	end
end

function Mockview:AddComponent(component)
    table.insert(self.components, component.name);
end

function Mockview:RemoveComponent(componentName)
    table.removeItem(self.components, componentName);
end

function Mockview:GetComponent(componentName)
    --print("returning component:" .. componentName);
    return {name= componentName, Height = 40, Width = 120};
end

function Mockview:GetItems()
    return self.components;
end