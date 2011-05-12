LoadScript "models\\calendar.lua"
LoadScript "models\\character.lua"
LoadScript "models\\inventorymanager.lua"
LoadScript "models\\logmanager.lua"

--game models

--character initialization
character = Character:New();
character:SetBody("resources/scg/ma.png"); --set default body
--TODO: change body image according to age automatically

--inventory initialization
inventoryManager = InventoryManager:New();

inventoryManager:AddItem("ewear");
inventoryManager:AddItem("pajamas");

inventoryManager:EquipItem("ewear");

--calendar
calendar = Calendar:New();
calendar:SetModifier(-2012);
calendar:SetDate(0, 1, 1);

--log manager
logManager = LogManager:New();

OpenState("character making", "intro/makingstate.lua");