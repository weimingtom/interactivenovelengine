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

function ShopManager:Load()
    self.csv = GetCsv("shopdata");
    self.shopcsv = GetCsv("shoplist");
end

function ShopManager:ItemExists(id)
    return table.contains(self.itemList, id);
end

function ShopManager:ExtractItem(i)
    local item = {};
    item.category = self.csv:GetString(i, "category");
    item.id = self.csv:GetString(i, "id");
    return item;
end

function ShopManager:GetItems(category)
	local itemList = {};
    for i=0, self.csv.Count-1 do
    local itemCategory = self.csv:GetString(i, "category");
        if (category == itemCategory) then
			table.insert(itemList, self:ExtractItem(i));
        end
    end
	return itemList;
end

function ShopManager:GetCategoryCount(category)
	local count = 0;
	for i=0, self.csv.Count-1 do
        local c = self.csv:GetString(i, "category");
        if (category == c) then count = count + 1;
        end
    end
	return count;
end

function ShopManager:ExtractShop(i)
    local item = {};
    item.id = self.shopcsv:GetString(i, "id");
    item.name = self.shopcsv:GetString(i, "name");
    item.owner = self.shopcsv:GetString(i, "owner");
    item.greetings = self.shopcsv:GetString(i, "greetings");
    item.portrait = self.shopcsv:GetString(i, "portrait");
    item.buymessage = self.shopcsv:GetString(i, "buymessage");
    return item;
end

function ShopManager:GetShop(shop)
    for i=0, self.shopcsv.Count-1 do
    local shopId = self.shopcsv:GetString(i, "id");
        if (shop == shopId) then
			return self:ExtractShop(i);
        end
    end
	return nil;
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