dofile "../sampler/components/flowview.lua"
require "luaunit"
require "mockview"

function Trace(msg)
    print(msg);
end

function table.contains(tbl, item)
	for i,v in ipairs(tbl) do 
		if (item == v) then
            return true;
        end
	end
    return false;
end

TestFlowview = {}

function TestFlowview:setUp()
    self.flowview = Flowview:New("testview")
end

function TestFlowview:testAdd()
    assertEquals(table.contains(self.flowview:GetItems(), "testItem"), false)

    self.flowview:Add({name = "testItem"});

    assertEquals(table.contains(self.flowview:GetItems(), "testItem"), true)
    assertEquals(table.contains(self.flowview:GetItems(), "testItem2"), false)
    assertEquals(table.contains(self.flowview.frame:GetItems(), "testItem"), true)
    assertEquals(table.contains(self.flowview.frame:GetItems(), "testItem2"), false)

    
    self.flowview:Add({name = "testItem2"});
    assertEquals(table.contains(self.flowview:GetItems(), "testItem2"), true)
    assertEquals(table.contains(self.flowview.frame:GetItems(), "testItem2"), true)
end

function TestFlowview:testRemove()
    self.flowview:Add({name = "testItem"});
    self.flowview:Remove("testItem");

    assertEquals(table.contains(self.flowview:GetItems(), "testItem"), false)
    assertEquals(table.contains(self.flowview.frame:GetItems(), "testItem"), false)
end