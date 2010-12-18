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
    for i=0, self.csv.ColumnCount-1 do
        local c = self.csv:GetColumn(i);
        if c == "category" then self.categoryIndex = i;
        elseif c == "id" then self.idIndex = i;
        elseif c == "name" then self.nameIndex = i;
        elseif c == "price" then self.priceIndex = i;
        elseif c == "icon" then self.iconIndex = i;
        elseif c == "desc" then self.descIndex = i;
        elseif c == "dressImage" then self.dressImageIndex = i;
        else 
            Trace(c .. " does not match anything");
        end
    end
end

function ItemManager:GetItemCount(category)
	local count = 0;
	for i=0, self.csv.Count-1 do
        local c = self.csv:GetString(i, self.categoryIndex);
        if (category == c) then count = count + 1;
        end
    end
    return count;
end

function ItemManager:ExtractItem(i)
    local item = {};
    item.category = self.csv:GetString(i, self.categoryIndex);
    item.id = self.csv:GetString(i, self.idIndex);
    item.text = self.csv:GetString(i, self.nameIndex);
    item.price = self.csv:GetString(i, self.priceIndex);
    item.icon = self.csv:GetString(i, self.iconIndex);
    item.desc = self.csv:GetString(i, self.descIndex);
    item.dressImage = self.csv:GetString(i, self.dressImageIndex);
    return item;
end

function ItemManager:GetItems(category)
	local itemList = {};
    for i=0, self.csv.Count-1 do
        if (category == self.csv:GetString(i, self.categoryIndex)) then
			table.insert(itemList, self:ExtractItem(i));
        end
    end
	return itemList;
end

function ItemManager:GetItem(id)
    for i=0, self.csv.Count-1 do
        if (id == self.csv:GetString(i, self.idIndex)) then
			return self:ExtractItem(i);
        end
    end
end