--Import
ItemManager = {}

function ItemManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self

	return o
end

function ItemManager:Load()
    self.csv = GetCsv("itemdata");
end

function ItemManager:GetItemCount(category)
	local count = 0;
	for i=0, self.csv.Count-1 do
        local c = self.csv:GetString(i, "category");
        if (category == c) then count = count + 1;
        end
    end
    return count;
end

function ItemManager:ExtractItem(i)
    local item = {};
    item.category = self.csv:GetString(i, "category");
    item.id = self.csv:GetString(i, "id");
    item.text = self.csv:GetString(i, "text");
    item.price = self.csv:GetString(i, "price");
    item.icon = self.csv:GetString(i, "icon");
    item.desc = self.csv:GetString(i, "desc");
    item.dressImage = self.csv:GetString(i, "dressImage");
    return item;
end

function ItemManager:GetItems(category)
	local itemList = {};
    for i=0, self.csv.Count-1 do
        if (category == self.csv:GetString(i, "category")) then
			table.insert(itemList, self:ExtractItem(i));
        end
    end
	return itemList;
end

function ItemManager:GetItem(id)
    for i=0, self.csv.Count-1 do
        if (id == self.csv:GetString(i, "id")) then
			return self:ExtractItem(i);
        end
    end
end