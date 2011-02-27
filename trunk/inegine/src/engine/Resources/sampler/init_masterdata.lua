LoadScript "Resources\\sampler\\models\\calendar.lua"
LoadScript "Resources\\sampler\\models\\character.lua"
LoadScript "Resources\\sampler\\models\\schedulemanager.lua"
LoadScript "Resources\\sampler\\models\\itemmanager.lua"
LoadScript "Resources\\sampler\\models\\inventorymanager.lua"
LoadScript "Resources\\sampler\\models\\shopmanager.lua"
LoadScript "Resources\\sampler\\models\\savemanager.lua"
LoadScript "Resources\\sampler\\models\\eventmanager.lua"

--game master data
scheduleManager = ScheduleManager:New();
scheduleManager:Load()

itemManager = ItemManager:New();
itemManager:Load();

shopManager = ShopManager:New();
shopManager:Load();

eventManager = EventManager:New();
eventManager:Load();

--calendar
calendar = Calendar:New();
calendar:SetModifier(-2012);
calendar:SetDate(0, 1, 1);

--save manager
saveManager = SaveManager:New();
saveManager:Init();