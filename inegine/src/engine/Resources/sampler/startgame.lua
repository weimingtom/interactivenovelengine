LoadScript "Resources\\sampler\\models\\calendar.lua"
LoadScript "Resources\\sampler\\models\\character.lua"
LoadScript "Resources\\sampler\\models\\inventorymanager.lua"
LoadScript "Resources\\sampler\\models\\logmanager.lua"

--game models

--character initialization
character = Character:New();
	
--inventory initialization
inventoryManager = InventoryManager:New();
inventoryManager:AddItem("item1");
inventoryManager:EquipItem("item1");

--calendar
calendar = Calendar:New();
calendar:SetModifier(-2012);
calendar:SetDate(0, 1, 1);

--log manager
logManager = LogManager:New();

OpenState("character making", "Resources/Sampler/intro/makingstate.lua");