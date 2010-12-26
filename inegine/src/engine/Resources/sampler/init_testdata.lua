require "Resources\\sampler\\models\\calendar"
require "Resources\\sampler\\models\\character"
require "Resources\\sampler\\models\\schedulemanager"
require "Resources\\sampler\\models\\itemmanager"
require "Resources\\sampler\\models\\inventorymanager"
require "Resources\\sampler\\models\\shopmanager"

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

scheduleManager = ScheduleManager:New();
scheduleManager:Load()

itemManager = ItemManager:New();
itemManager:Load();

inventoryManager = InventoryManager:New();
inventoryManager:AddItem("item13", "item");
inventoryManager:AddItem("item14", "item");
inventoryManager:AddItem("item15", "furniture");

shopManager = ShopManager:New();
shopManager:Load();