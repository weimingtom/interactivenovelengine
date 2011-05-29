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

function ItemManager:GetCategoryCount(category)
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
    item.sellable = self.csv:GetBoolean(i, "sellable");
    item.shortdesc = self.csv:GetString(i, "shortdesc");
    item.resulttext = self.csv:GetString(i, "resulttext");
    item.dressImage = self.csv:GetString(i, "dressImage");
    item.sta = self.csv:GetString(i, "sta");
    item.will = self.csv:GetString(i, "will");
    item.int = self.csv:GetString(i, "int");
    item.cha = self.csv:GetString(i, "cha");
    item.grace = self.csv:GetString(i, "grace");
    item.moral = self.csv:GetString(i, "moral");
    item.sense = self.csv:GetString(i, "sense");
    item.rep = self.csv:GetString(i, "rep");
    item.stress = self.csv:GetString(i, "stress");
    item.mana = self.csv:GetString(i, "mana");
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
    error(id .. " is non existent");
end