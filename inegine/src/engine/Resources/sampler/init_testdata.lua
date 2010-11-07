require "Resources\\sampler\\models\\calendar"
require "Resources\\sampler\\models\\character"

calendar = Calendar:New();
calendar:SetYear(1217);
calendar:SetMonth("June");
calendar:SetDay(5);

character = Character:New();
character:SetFirstName("�ȳ�");
character:SetLastName("��");
character:SetAge(12);
character:SetGold(1000);
character:SetStress(50);
character:SetMana(100);