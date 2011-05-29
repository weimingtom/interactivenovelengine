require('luaunit')
dofile "../sampler/models/savemanager.lua"
dofile "../sampler/models/logmanager.lua"
dofile "../sampler/common/observer.lua"

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

--mock functions
function Replace(line) return line end
function Length(line) return string.len(line) end
function Substring() end

function TestTemp:testLog()
    local logMan = LogManager:New();
    logMan:SetDate(2, 11, 2);
    logMan:SetLine("Hello world")
    logMan:SetName("Anze", "pic1.png");
    logMan:SetLine("Hi")
    logMan:SetName("Cube", "pic2.png");
    logMan:SetLine("Hello")
    logMan:SetName("Anze", "pic1.png");
    logMan:SetLine("Bye")
    logMan:SetDate(2, 11, 3);
    logMan:SetLine("The day started")
    logMan:SetName("Anze", "pic1.png");
    logMan:SetLine("LOL")

	assertEquals(8, logMan:GetSize());
    assertEquals(nil, logMan:GetLine(0).line);
    assertEquals(2, logMan:GetLine(0).date.year);
    assertEquals(11, logMan:GetLine(0).date.month);
    assertEquals(2, logMan:GetLine(0).date.week);


    assertEquals("Hello world", logMan:GetLine(1).line);
    assertEquals(nil, logMan:GetLine(1).date);
    assertEquals(nil, logMan:GetLine(1).name);
    assertEquals(nil, logMan:GetLine(1).face);

    assertEquals("Anze", logMan:GetLine(2).name);
    assertEquals("pic1.png", logMan:GetLine(2).face);
    assertEquals("Hi", logMan:GetLine(2).line);

    
    assertEquals("The day started", logMan:GetLine(6).line);
    assertEquals("Anze", logMan:GetLine(7).name);
    assertEquals("pic1.png", logMan:GetLine(7).face);
    assertEquals("LOL", logMan:GetLine(7).line);

    for i=0, logMan:GetSize() - 1 do
        local line = logMan:GetLine(i);
        if (line.date ~= nil) then
            print("<year" .. line.date.year .. " month" .. line.date.month .. " week" .. line.date.week  .. ">");
        end

        if (line.name ~= nil and line.line ~= nil) then
            print(line.name .. " : " .. line.line);
        elseif (line.line ~= nil) then
            print("    " .. line.line);
        end
    end
end

function TestTemp:testObserver()
	alice = {}
	alice.name = "TEST"
	function alice:slot(param )
	  print(self.name, param )
	end
	bob = {}
	bob.alert = Observer.signal()

	bob.alert:register(alice, alice.slot)
	bob.alert("Hi there")
	bob.alert:deregister(alice)
	--bob.alert( "Hello?" )
end

function table.contains(tbl, item)
	for i,v in ipairs(tbl) do
		if (item == v) then
            return true;
        end
	end
    return false;
end


function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end