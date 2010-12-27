--Import
SaveManager = {}

function SaveManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	self.saveFile = "save.dat";	
	return o
end

function SaveManager:Save()
    local saveData = "";
    saveData = saveData .. inventoryManager:Save("inventoryManager");
    saveData = saveData .. calendar:Save("calendar");
    SaveString(saveData, self.saveFile);
end

function SaveManager:Load()
    local loadData = LoadString(self.saveFile);
    if (loadData ~= nil) then 
        assert(loadstring(loadData))();
    end
end