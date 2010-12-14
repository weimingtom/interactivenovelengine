dofile "../sampler/models/character.lua"
require('luaunit')

TestCharacter = {}

    function TestCharacter:setUp()
		self.character = Character:New();
		local character = self.character;
		character:SetFirstName("¾È³ª");
		character:SetLastName("±è");
		character:SetAge(12);
		character:SetGold(1000);
		character:SetStress(50);
		character:SetMana(100);
    end


    function TestCharacter:testGetSetStatus()
		local character = self.character;
		character:SetStatus("con", 1);
		character:SetStatus("int", 2);
		character:SetStatus("cha", 3);
		assertEquals(1, character:GetStatus("con"))
		assertEquals(2, character:GetStatus("int"))
		assertEquals(3, character:GetStatus("cha"))
    end