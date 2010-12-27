dofile "../sampler/models/inventorymanager.lua"
require('luaunit')

TestInventory = {}

    function TestInventory:setUp()
		self.inventory = InventoryManager:New();
    end

    function TestInventory:testAddItem()
        local inventory = self.inventory;
        inventory:AddItem("testItem1");
        inventory:AddItem("testItem2");
        inventory:AddItem("testItem3");

        
		assertEquals(true, inventory:ItemExists("testItem1"))
		assertEquals(true, inventory:ItemExists("testItem2"))
		assertEquals(true, inventory:ItemExists("testItem3"))
		assertEquals(false, inventory:ItemExists("testItem4"))
		assertEquals(false, inventory:ItemExists("testItem5"))
		assertEquals(false, inventory:ItemExists("testItem6"))
    end

    function TestInventory:testRemoveItem()
        local inventory = self.inventory;
        inventory:AddItem("testItem1");
        inventory:AddItem("testItem2");
        inventory:AddItem("testItem3");

        
		assertEquals(true, inventory:ItemExists("testItem1"))
		assertEquals(true, inventory:ItemExists("testItem2"))
		assertEquals(true, inventory:ItemExists("testItem3"))

        inventory:RemoveItem("testItem1");
        inventory:RemoveItem("testItem2");
        inventory:RemoveItem("testItem3");

		assertEquals(false, inventory:ItemExists("testItem1"))
		assertEquals(false, inventory:ItemExists("testItem2"))
		assertEquals(false, inventory:ItemExists("testItem3"))
    end

    function TestInventory:testGetItems()
        local inventory = self.inventory;
        inventory:AddItem("testItem1", "cat1");
        inventory:AddItem("testItem2", "cat1");
        inventory:AddItem("testItem3", "cat1");
        inventory:AddItem("testItem4", "cat2");
        inventory:AddItem("testItem5", "cat3");
        inventory:AddItem("testItem6", "cat4");
        local items = inventory:GetItems("cat1");
        assertEquals(true, table.contains(items, "testItem1"));
        assertEquals(true, table.contains(items, "testItem2"));
        assertEquals(true, table.contains(items, "testItem3"));
        assertEquals(true, table.contains(inventory:GetItems("cat2"), "testItem4"));
        assertEquals(true, table.contains(inventory:GetItems("cat3"), "testItem5"));
        assertEquals(true, table.contains(inventory:GetItems("cat4"), "testItem6"));
    end

    function TestInventory:testEquipDress()
        local inventory = self.inventory;
        inventory:AddItem("testItem1", "dress");
        inventory:AddItem("testItem2", "dress");
        inventory:AddItem("testItem3", "dress");

        assertEquals(false, inventory:ItemEquipped("testItem1"));
        assertEquals(false, inventory:ItemEquipped("testItem2"));
        assertEquals(false, inventory:ItemEquipped("testItem3"));

        inventory:EquipItem("testItem1");

        assertEquals(true, inventory:ItemEquipped("testItem1"));
        assertEquals(false, inventory:ItemEquipped("testItem2"));
        assertEquals(false, inventory:ItemEquipped("testItem3"));

        inventory:EquipItem("testItem2");

        assertEquals(false, inventory:ItemEquipped("testItem1"));
        assertEquals(true, inventory:ItemEquipped("testItem2"));
        assertEquals(false, inventory:ItemEquipped("testItem3"));

        inventory:EquipItem("testItem3");

        assertEquals(false, inventory:ItemEquipped("testItem1"));
        assertEquals(false, inventory:ItemEquipped("testItem2"));
        assertEquals(true, inventory:ItemEquipped("testItem3"));
    end


    function TestInventory:testGetCategories()
        local inventory = self.inventory;
        inventory:AddItem("testItem1", "cat1");
        inventory:AddItem("testItem2", "cat2");
        inventory:AddItem("testItem3", "cat3");

        local categoryList = inventory:GetCategories();
        assertEquals(true, table.contains(categoryList, "cat1"));
        assertEquals(true, table.contains(categoryList, "cat2"));
        assertEquals(true, table.contains(categoryList, "cat3"));
    end

    function TestInventory:testSave()
        local inventory = self.inventory;
        inventory:AddItem("testItem1", "cat1");
        inventory:AddItem("testItem2", "cat2");
        inventory:AddItem("testItem3", "cat3");
        inventory:EquipItem("testItem3");

        local saveString = inventory:Save();
    end

function table.contains(tbl, item)
	for i,v in ipairs(tbl) do
		if (item == v) then
            return true;
        end
	end
    return false;
end
