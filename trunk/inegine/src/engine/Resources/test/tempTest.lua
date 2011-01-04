require('luaunit')
dofile "../sampler/models/savemanager.lua"

TestTemp = {}

    function TestTemp:setUp()
    end


    function TestTemp:testTemp()
		local saveManager = SaveManager:New();
		saveManager:AddRecord("save1", "save 1 test");
		saveManager:AddRecord("save2", "save 2 test");
		saveManager:AddRecord("save3", "save 3 test");
		local ids = saveManager:GetRecordIDs();
		
		assertEquals(true, table.contains(ids, "save1"));
		assertEquals(true, table.contains(ids, "save2"));
		assertEquals(true, table.contains(ids, "save3"));
		assertEquals(false, table.contains(ids, "save4"));
		
		
		assertEquals("save 1 test", saveManager:GetRecordDescription("save1"));
		
		print(saveManager:GenerateRecordString());
		
    end
    
function table.contains(tbl, item)
	for i,v in ipairs(tbl) do
		if (item == v) then
            return true;
        end
	end
    return false;
end