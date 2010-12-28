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
    Trace("saving : " .. saveData);
end

function SaveManager:Load()
    local loadData = LoadString(self.saveFile);
    Trace("loading : " .. loadData);
    if (loadData ~= nil) then 
		CloseState() -- TODO: change to CleatStates()!
        assert(loadstring(loadData))();
		LoadScript("Resources/Sampler/startgame.lua")
		return true;
    else
		return false;
    end
end