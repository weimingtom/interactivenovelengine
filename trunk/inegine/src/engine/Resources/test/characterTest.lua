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

    function TestCharacter:testSave()
		local character = self.character;
		character:Set("int", 1);
		character:Set("cha", 2);
		character:Set("wis", 3);

        local saveString = character:Save("character");
        print(saveString);
        
		assert(loadstring(saveString))();
    end