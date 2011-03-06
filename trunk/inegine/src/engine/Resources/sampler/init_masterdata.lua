LoadScript "Resources\\sampler\\models\\schedulemanager.lua"
LoadScript "Resources\\sampler\\models\\itemmanager.lua"
LoadScript "Resources\\sampler\\models\\shopmanager.lua"
LoadScript "Resources\\sampler\\models\\savemanager.lua"
LoadScript "Resources\\sampler\\models\\eventmanager.lua"

--parameters
BASE_EDU_RATE = 0.75;
BASE_JOB_RATE = 0.60;

--game master data
scheduleManager = ScheduleManager:New();
scheduleManager:Load()

itemManager = ItemManager:New();
itemManager:Load();

shopManager = ShopManager:New();
shopManager:Load();

eventManager = EventManager:New();
eventManager:Load();

--save manager
saveManager = SaveManager:New();
saveManager:Init();