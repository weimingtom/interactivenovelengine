ShopManager = {}

function ShopManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.itemList = {};
    self.categoryMap = {};    
	self.equippedItems = {};
	return o
end

function ShopManager:AddItem(id, category)
    table.insert(self.itemList, id);
    self.categoryMap[id] = category;
end

function ShopManager:RemoveItem(id)
    table.removeItem(self.itemList, id);
    self.categoryMap[id] = nil;
end

function ShopManager:ItemExists(id)
    return table.contains(self.itemList, id);
end

function ShopManager:GetItems(category)
	local itemList = {};
	for i,v in ipairs(self.itemList) do
        if (category == self.categoryMap[v]) then
			table.insert(itemList, v);
        end
	end
	return itemList;
end

function ShopManager:GetItemCount(category)
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

function ShopManager:GetOwner(shop)
	return "샬록"
end

function ShopManager:GetOwnerImage(shop)
	return "Resources/sampler/resources/images/f2.png"
end

function ShopManager:GetOwnerGreetings(shop)
	return "어서오시게나"
end

function ShopManager:GetPurchaseMessage(shop)
	return "고맙네"
end