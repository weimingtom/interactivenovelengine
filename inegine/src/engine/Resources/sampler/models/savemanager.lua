--Import
SaveManager = {}

function SaveManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	self.saveFile = "save.dat";
	self.saveIDs = {};
	self.saveDescriptions = {};
	
	return o
end

function SaveManager:Init()
	self:LoadRecords();
end

function table.contains(tbl, item)
	for i,v in ipairs(tbl) do
		if (item == v) then
            return true;
        end
	end
    return false;
end

function SaveManager:AddRecord(id, description)
	if (table.contains(self.saveIDs, id) == false) then
		table.insert(self.saveIDs, id);
	end
	self.saveDescriptions[id] = description;

end

function SaveManager:GetRecordIDs()
	return self.saveIDs;
end

function SaveManager:GetRecordDescription(id)
	return self.saveDescriptions[id];
end

function SaveManager:LoadRecords()
    local loadData = LoadString(self.saveFile);
    Trace("loading : " .. loadData);
    if (loadData ~= nil) then 
        assert(loadstring(loadData))(self);
		return true;
    else
		return false;
    end
end

function SaveManager:GenerateRecordString()
	local recordString = "";
	
	recordString = recordString .. "local self = ...; self.saveRecords = {}; self.saveIDs = {};\n";
	for i,v in ipairs(self.saveIDs) do
		local description = self:GetRecordDescription(v);
        recordString = recordString .. [[self:AddRecord("]] .. v .. [[","]] .. description .. [[");]] .. "\n";
   	end  
   	
   	return recordString;
end

function SaveManager:SaveRecords()
	SaveString(self:GenerateRecordString(), self.saveFile);
end

function SaveManager:GenerateSaveString()
    local saveData = "";
    saveData = saveData .. calendar:Save("calendar");
    saveData = saveData .. character:Save("character");
    saveData = saveData .. inventoryManager:Save("inventoryManager");
    return saveData;
end

function SaveManager:GenerateSaveFileName(id)
	return id .. ".sav";
end

function SaveManager:Save(id, description)
    SaveString(self:GenerateSaveString(), self:GenerateSaveFileName(id));
    self:AddRecord(id, description);
    self:SaveRecords();
end

function SaveManager:Load(id)
    local loadData = LoadString(self:GenerateSaveFileName(id));
    Trace("loading : " .. loadData);
    if (loadData ~= nil) then 
		Trace("closing state");
		CloseState() -- TODO: change to CleatStates()
		Trace("applying saved data");       
        assert(loadstring(loadData))();
        
        
        
		OpenState("main", "Resources/Sampler/main/main.lua");
		return true;
    else
		return false;
    end
end