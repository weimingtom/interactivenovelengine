LoadScript "models\\schedulemanager.lua"
LoadScript "models\\itemmanager.lua"
LoadScript "models\\shopmanager.lua"
LoadScript "models\\savemanager.lua"
LoadScript "models\\eventmanager.lua"
LoadScript "models\\talkmanager.lua"
LoadScript "condition\\conditionmanager.lua"

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

talkManager = TalkManager:New();
talkManager:Load();

--save manager
saveManager = SaveManager:New();
saveManager:Init();