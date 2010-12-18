InventoryManager = {}

function InventoryManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.itemList = {};
    self.categoryMap = {};    
	self.equippedItems = {};
	return o
end

function InventoryManager:AddItem(id, category)
    table.insert(self.itemList, id);
    self.categoryMap[id] = category;
end

function InventoryManager:RemoveItem(id)
    table.removeItem(self.itemList, id);
    self.categoryMap[id] = nil;
end

function InventoryManager:ItemExists(id)
    return table.contains(self.itemList, id);
end

function InventoryManager:GetItems(category)
	local itemList = {};
	for i,v in ipairs(self.itemList) do
        if (category == self.categoryMap[v]) then
			table.insert(itemList, v);
        end
	end
	return itemList;
end

function table.contains(tbl, item)
	for i,v in ipairs(tbl) do
		if (item == v) then
            return true;
        end
	end
    return false;
end

function table.removeItem(tbl, item)
	for i,v in ipairs(tbl) do
		if (item == v) then
            table.remove(tbl, i)
            return;
        end
	end
end


function InventoryManager:ItemEquipped(id)
	if (self.equippedItems[id] ~= nil and self.equippedItems[id] == true) then
		return true;
	else
		return false;
	end
end

function InventoryManager:EquipItem(id)
	Trace("Equipping " .. id);
	
	if (self.categoryMap[id] == "dress") then
	    if (self.dressEquippedEvent ~= nil) then
		    self.dressEquippedEvent(id);
	    end

        for i,v in ipairs(self:GetItems("dress")) do
            self:UnequipItem(v);
        end
    end
	self.equippedItems[id] = true;
end

function InventoryManager:UnequipItem(id)
	Trace("Unequipping " .. id);
	
	self.equippedItems[id] = false;
end

function InventoryManager:SetDressEquippedEvent(event)
	self.dressEquippedEvent = event;
end