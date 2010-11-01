--Import
Character = {}

function Character:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.firstname = 0;
	self.lastname = 0;
	self.age = 0;
	self.gold = 0;
	self.stress = 0;
	self.mana = 0;
   
	return o
end

function Character:GetFirstName()
	return self.firstName;
end

function Character:SetFirstName(firstName)
	self.firstName = firstName;
end

function Character:GetLastName()
	return self.lastName;
end

function Character:SetLastName(lastName)
	self.lastName = lastName;
end

function Character:GetAge()
	return self.age;
end

function Character:SetAge(age)
	self.age = age;
end

function Character:GetGold()
	return self.gold;
end

function Character:SetGold(gold)
	self.gold = gold;
end

function Character:GetStress()
	return self.stress;
end

function Character:SetStress(stress)
	self.stress = stress;
end

function Character:GetMana()
	return self.mana;
end

function Character:SetMana(mana)
	self.mana = mana;
end