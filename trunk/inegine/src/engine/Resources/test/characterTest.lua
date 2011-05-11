dofile "../sampler/models/character.lua"
require('luaunit')

TestCharacter = {}

function TestCharacter:setUp()
	self.character = Character:New();
	local character = self.character;
end

function TestCharacter:testGetSetStatus()
	local character = self.character;
	character:Set("int", 1);
	character:Set("cha", 2);
	character:Set("wis", 3);
	assertEquals(1, character:Get("int"))
	assertEquals(2, character:Get("cha"))
	assertEquals(3, character:Get("wis"))
	
	character:Inc("wis", 100);
	assertEquals(103, character:Get("wis"))
end

---------set up mock item manager----------
ItemManager = {}

function ItemManager:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	self.items = {};
	return o
end

function ItemManager:AddItem(id, item)
	self.items[id] = item;
end

function ItemManager:GetItem(id)
	return self.items[id];
end
---------------------------------------------------
function TestCharacter:testItemEffect()
	dofile "../sampler/models/inventorymanager.lua"
	inventoryManager = InventoryManager:New();
	itemManager = ItemManager:New();
	
	local newItem = {};
	newItem.hp = 5;
	newItem.grace = 10;
	itemManager:AddItem("item1", newItem);
	
	newItem = {};
	newItem.int = 1;
	newItem.hp = 2;
	newItem.wis = 3;
	newItem.grace = 4;
	itemManager:AddItem("item2", newItem);
	
	
	newItem = {};
	newItem.int = 1;
	newItem.hp = 2;
	newItem.wis = 3;
	newItem.grace = 4;
	itemManager:AddItem("item3", newItem);
	
	newItem = {};
	newItem.int = 5;
	newItem.hp = 6;
	newItem.wis = 7;
	newItem.grace = 8;
	itemManager:AddItem("item4", newItem);
	
	
	inventoryManager:AddItem("item1", "item", 1);
	inventoryManager:AddItem("item2", "item", 4);
	inventoryManager:AddItem("item3", "dress", 1);
	inventoryManager:AddItem("item4", "dress", 1);

	local character = self.character;
	character:Set("int", 1);
	character:Set("cha", 2);
	character:Set("hp", 3);
	character:Set("wis", 4);
	character:Set("grace", 5);
	character:SetDress("item3");
	
	assertEquals(6, character:Get("int"))
	assertEquals(2, character:Get("cha"))
	assertEquals(18, character:Get("hp"))
	assertEquals(19, character:Get("wis"))
	assertEquals(35, character:Get("grace"))
end

function TestCharacter:testSave()
	local character = self.character;
	character:Set("int", 1);
	character:Set("cha", 2);
	character:Set("wis", 3);

    local saveString = character:Save("character");
    print(saveString);
    
	assert(loadstring(saveString))();
end

function TestCharacter:testEvent()
	local character = self.character;
	character:SetLookEvent(function()
		testval = 1;
	end);
	
	testval = 0;
	character:SetDress("test");
	assertEquals(1, testval);
	
	testval = 0;
	character:SetBody("test");
	assertEquals(1, testval);
	
	testval = 0;
	character:SetBody("test");
	assertEquals(1, testval);
	
end