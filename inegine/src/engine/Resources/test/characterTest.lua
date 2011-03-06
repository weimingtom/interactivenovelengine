dofile "../sampler/models/character.lua"
require('luaunit')

TestCharacter = {}

    function TestCharacter:setUp()
		self.character = Character:New();
		local character = self.character;
		character:SetFirstName("¾È³ª");
		character:SetLastName("±è");
		character:Set("age", 12);
		character:Set("gold", 1000);
		character:Set("stress", 50);
		character:Set("mana", 100);
    end


    function TestCharacter:testGetSetStatus()
		local character = self.character;
		character:Set("con", 1);
		character:Set("int", 2);
		character:Set("cha", 3);
		assertEquals(1, character:Get("con"))
		assertEquals(2, character:Get("int"))
		assertEquals(3, character:Get("cha"))
    end

    function TestCharacter:testSave()
		local character = self.character;
		character:Set("con", 1);
		character:Set("int", 2);
		character:Set("cha", 3);

        local saveString = character:Save("character");
        print(saveString);
    end