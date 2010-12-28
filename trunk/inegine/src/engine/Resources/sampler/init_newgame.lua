LoadScript "Resources\\sampler\\models\\calendar.lua"
LoadScript "Resources\\sampler\\models\\character.lua"
LoadScript "Resources\\sampler\\models\\inventorymanager.lua"

--game models
calendar = Calendar:New();
calendar:SetModifier(-2012);
calendar:SetDate(2012, 1, 1);

character = Character:New();
character:SetFirstName("¾È³ª");
character:SetLastName("±è");
character:SetAge(12);
character:SetGold(1000);
character:SetStress(50);
character:SetMana(100);

inventoryManager = InventoryManager:New();
inventoryManager:AddItem("item1");
inventoryManager:EquipItem("item1");
