require "Resources\\sampler\\models\\calendar"
require "Resources\\sampler\\models\\character"
require "Resources\\sampler\\models\\schedulemanager"

dofile("Resources/Sampler/init_csv.lua")

calendar = Calendar:New();
calendar:SetDate(1217, 6, 5);

character = Character:New();
character:SetFirstName("¾È³ª");
character:SetLastName("±è");
character:SetAge(12);
character:SetGold(1000);
character:SetStress(50);
character:SetMana(100);

scheduleManager = ScheduleManager:New();
scheduleManager:Load()