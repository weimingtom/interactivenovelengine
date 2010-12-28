LoadScript "Resources\\sampler\\models\\calendar.lua"
LoadScript "Resources\\sampler\\models\\character.lua"
LoadScript "Resources\\sampler\\models\\schedulemanager.lua"
LoadScript "Resources\\sampler\\models\\itemmanager.lua"
LoadScript "Resources\\sampler\\models\\inventorymanager.lua"
LoadScript "Resources\\sampler\\models\\shopmanager.lua"
LoadScript "Resources\\sampler\\models\\savemanager.lua"

--game master data
scheduleManager = ScheduleManager:New();
scheduleManager:Load()

itemManager = ItemManager:New();
itemManager:Load();

shopManager = ShopManager:New();
shopManager:Load();

--save manager
saveManager = SaveManager:New();

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
