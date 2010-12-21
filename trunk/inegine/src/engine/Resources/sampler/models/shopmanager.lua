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
    for i=0, self.csv.ColumnCount-1 do
        local c = self.csv:GetColumn(i);
        if c == "category" then self.categoryIndex = i;
        elseif c == "id" then self.idIndex = i;
        else 
            Trace(c .. " does not match anything");
        end
    end

    self.shopcsv = GetCsv("shoplist");
    for i=0, self.shopcsv.ColumnCount-1 do
        local c = self.shopcsv:GetColumn(i);
        if c == "id" then self.shopidIndex = i;
        elseif c == "name" then self.shopnameIndex = i;
        elseif c == "owner" then self.shopownerIndex = i;
        elseif c == "greetings" then self.shopgreetingsIndex = i;
        elseif c == "portrait" then self.shopportraitIndex = i;
        elseif c == "buymessage" then self.shopbuymessageIndex = i;
        else 
            Trace(c .. " does not match anything");
        end
    end
end

function ShopManager:ItemExists(id)
    return table.contains(self.itemList, id);
end

function ShopManager:ExtractItem(i)
    local item = {};
    item.category = self.csv:GetString(i, self.categoryIndex);
    item.id = self.csv:GetString(i, self.idIndex);
    return item;
end

function ShopManager:GetItems(category)
	local itemList = {};
    for i=0, self.csv.Count-1 do
    local itemCategory = self.csv:GetString(i, self.categoryIndex);
        if (category == itemCategory) then
			table.insert(itemList, self:ExtractItem(i));
        end
    end
	return itemList;
end

function ShopManager:GetItemCount(category)
	local count = 0;
	for i=0, self.csv.Count-1 do
        local c = self.csv:GetString(i, self.categoryIndex);
        if (category == c) then count = count + 1;
        end
    end
	return count;
end

function ShopManager:ExtractShop(i)
    local item = {};
    item.id = self.shopcsv:GetString(i, self.shopidIndex);
    item.name = self.shopcsv:GetString(i, self.shopnameIndex);
    item.owner = self.shopcsv:GetString(i, self.shopownerIndex);
    item.greetings = self.shopcsv:GetString(i, self.shopgreetingsIndex);
    item.portrait = self.shopcsv:GetString(i, self.shopportraitIndex);
    item.buymessage = self.shopcsv:GetString(i, self.shopbuymessageIndex);
    return item;
end

function ShopManager:GetShop(shop)
    for i=0, self.shopcsv.Count-1 do
    local shopId = self.shopcsv:GetString(i, self.shopidIndex);
        Trace(shop .. " vs " .. shopId);
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