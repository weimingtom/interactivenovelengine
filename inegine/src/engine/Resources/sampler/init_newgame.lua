LoadScript "Resources\\sampler\\models\\calendar.lua"
LoadScript "Resources\\sampler\\models\\character.lua"
LoadScript "Resources\\sampler\\models\\inventorymanager.lua"

--game models
character = Character:New();
character:SetFirstName("�ȳ�");
character:SetLastName("��");
character:SetAge(12);
character:SetGold(1000);
character:SetStress(50);
character:SetMana(100);

inventoryManager = InventoryManager:New();
inventoryManager:AddItem("item1");
inventoryManager:EquipItem("item1");
