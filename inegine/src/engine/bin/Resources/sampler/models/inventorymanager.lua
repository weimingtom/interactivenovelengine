InventoryManager = {}

function InventoryManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.itemList = {};
    self.categoryMap = {};
    self.countMap = {};    
    self.categoryList = {};    
	self.equippedItems = {};
		
	return o
end


function InventoryManager:AddItem(id, category, count)
	if (category == nil and itemManager ~= nil) then
		category = itemManager:GetItem(id).category;
	end

    if (count == nil) then
        count = 1;
    end

	-- make sure dress are unique in inventory
	if (category == "dress") then
		if (table.contains(self.itemList, id)) then
			return;
		elseif(count > 1) then
			count = 1;
		end
	end

    if (table.contains(self.itemList, id) == false) then
        table.insert(self.itemList, id);    
        if (table.contains(self.categoryList, category) == false) then
            table.insert(self.categoryList, category);
        end
        self.categoryMap[id] = category;
        self.countMap[id] = count;
    else
		self.countMap[id] = self.countMap[id] + count;
        
    end
end

function InventoryManager:RemoveItem(id, count)
	if (count == nil) then
		count = 1;
	end
	
    if (table.contains(self.itemList, id)) then
        if (self.countMap[id] == count) then
            table.removeItem(self.itemList, id);
            self.categoryMap[id] = nil;
        else
            self.countMap[id] = self.countMap[id] - count;
        end
    end
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

function InventoryManager:GetItemCount(id)
	return self.countMap[id];
end

function InventoryManager:GetCategoryCount(category)
	local count = 0;
	for i,v in ipairs(self.itemList) do
        if (category == self.categoryMap[v]) then
			count = count + 1;
        end
	end	
	return count;
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
	if (self.categoryMap[id] == "dress") then
		Info("Equipping " .. id);
		if (character:GetDress() ~= id) then			
			character:SetDress(id);
			for i,v in ipairs(self:GetItems("dress")) do
				if (v ~= id) then self:UnequipItem(v); end
			end
			self.equippedItems[id] = true;
		end
    end
end

function InventoryManager:UnequipItem(id)
	Info("Unequipping " .. id);
	self.equippedItems[id] = false;
end

function InventoryManager:GetCategories()
    local categories = {};
	for i,v in ipairs(self.categoryList) do
		table.insert(categories, v);
	end    
    return categories;
end

function InventoryManager:Clear()
	self.itemList = {};
    self.categoryMap = {};    
    self.categoryList = {};    
	self.equippedItems = {};
	self.equippedDress = nil;	
end

function InventoryManager:Save(target)
    local saveString = target .. " = InventoryManager:New()\n";
    saveString = saveString .. "local self = " .. target .. "\n"
    local categories = self:GetCategories();
	for i,v in ipairs(categories) do
		local items = self:GetItems(v);
	    for l,k in ipairs(items) do
            local itemCount = self:GetItemCount(k);
            saveString = saveString .. "self:AddItem(\"" .. k .. 
                                        "\",\"" .. v ..
                                        "\"," .. itemCount ..
                                         ");" .. "\n";
            if (self:ItemEquipped(k)) then
                saveString = saveString .. [[self:EquipItem("]] .. k .. [[");]] .. "\n";
            end
        end
	end      
    return saveString;
end

function ItemGet(id, count)
	inventoryManager:AddItem(id, nil, count);
end

function ItemLoss(id, count)
	inventoryManager:RemoveItem(id, count);
end

function ItemHas(id)
	return inventoryManager:ItemExists(id);
end

--ESS functions
function itemget(id, count)
	ItemGet(id, count);
end
AddESSCmd("itemget");

function itemloss(id, count)
	ItemLoss(id, count);
end
AddESSCmd("itemloss");

function itemhas(id)
	ItemHas(id);
end
AddESSCmd("itemhas");