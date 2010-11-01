require "Resources\\sampler\\calendar"
require "Resources\\sampler\\character"

calendar = Calendar:New();
calendar:SetYear(1217);
calendar:SetMonth("June");
calendar:SetDay(5);
calendar:SetWeek(1);

character = Character:New();
character:SetFirstName("¾È³ª");
character:SetLastName("±è");
character:SetAge(12);
character:SetGold(1000);
character:SetStress(50);
character:SetMana(100);

LoadState("main", "Resources/Sampler/main.lua");