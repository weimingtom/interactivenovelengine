LoadScript "Resources\\sampler\\models\\calendar.lua"
LoadScript "Resources\\sampler\\models\\character.lua"
LoadScript "Resources\\sampler\\models\\inventorymanager.lua"

--game models
character = Character:New();
character:SetDress(item1);
character:SetAge(12);
character:SetGold(1000);
character:SetStress(50);
character:SetMana(100);
--
inventoryManager = InventoryManager:New();
inventoryManager:AddItem("item1");
inventoryManager:EquipItem("item1");
--
--calendar
calendar = Calendar:New();
calendar:SetModifier(-2012);
calendar:SetDate(0, 1, 1);

OpenState("character making", "Resources/Sampler/intro/makingstate.lua");