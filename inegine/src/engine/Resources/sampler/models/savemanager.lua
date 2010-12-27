--Import
SaveManager = {}

function SaveManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
		
	return o
end

function SaveManager:Save()
    local inventoryData = inventoryManager:Save();
    local inventoryDataPath = "inventory.txt";
    SaveString(inventoryData, inventoryDataPath);
end

function SaveManager:Load()
    local inventoryDataPath = "inventory.txt";
    local inventoryData = LoadString(inventoryDataPath);
    if (inventoryData ~= nil) then 
        inventoryManager:Load(inventoryData);
    end
end