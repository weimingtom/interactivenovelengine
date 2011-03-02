--Import
Character = {}

function Character:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.status = {}
	
	self.firstname = "";
	self.lastname = "";
	self.age = 10;
	self.gold = 0;
	self.stress = 0;
	self.mana = 0;
	self.month = 1;
	self.day = 1;
	self.fatherMonth = 1;
	self.fatherDay = 1;
	self.bloodtype = "A";
	self.fatherName = "";
	self.dress = "";
	
	return o
end

function Character:SetStatus(key, value)
    self.status[key] = value;
end

function Character:GetStatus(key, value)
    return self.status[key];
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

function Character:GetBirthday()
	return self.month, self.day;
end

function Character:SetBirthday(month, day)
	self.month = month;
	self.day = day;
end

function Character:GetFatherBirthday()
	return self.fatherMonth, self.fatherDay;
end

function Character:SetFatherBirthday(month, day)
	self.fatherMonth = month;
	self.fatherDay = day;
end

function Character:GetBloodtype()
	return self.bloodtype;
end

function Character:SetBloodtype(type)
	self.bloodtype = type;
end

function Character:GetFatherName()
	return self.fatherName;
end

function Character:SetFatherName(name)
	self.fatherName = name;
end

function Character:GetDress()
	return self.dress;
end

function Character:SetDress(id)
	self.dress = id;
end

function Character:Save(target)
    local saveString = target .. " = Character:New()\n";
    saveString = saveString .. "local self = " .. target .. "\n"
    saveString = saveString .. [[self:SetFirstName("]] .. self:GetFirstName() .. [[");]] .. "\n";
    saveString = saveString .. [[self:SetLastName("]] .. self:GetLastName() .. [[");]] .. "\n";
    saveString = saveString .. [[self:SetAge("]] .. self:GetAge() .. [[");]] .. "\n";
    saveString = saveString .. [[self:SetGold("]] .. self:GetGold() .. [[");]] .. "\n";
    saveString = saveString .. [[self:SetStress("]] .. self:GetStress() .. [[");]] .. "\n";
    saveString = saveString .. [[self:SetMana("]] .. self:GetMana() .. [[");]] .. "\n";
    local mon, day = self:GetBirthday();
    saveString = saveString .. [[self:SetBirthday("]] .. mon .. "," .. day .. [[");]] .. "\n";
    local mon, day = self:GetFatherBirthday();
    saveString = saveString .. [[self:SetFatherBirthday("]] .. mon .. "," .. day .. [[");]] .. "\n";
    saveString = saveString .. [[self:SetBloodtype("]] .. self:GetBloodtype() .. [[");]] .. "\n";
    saveString = saveString .. [[self:SetFatherName("]] .. self:GetFatherName() .. [[");]] .. "\n";
    saveString = saveString .. [[self:SetDress("]] .. self:GetDress() .. [[");]] .. "\n";
    
	for i,v in pairs(self.status) do
        saveString = saveString .. "self:SetStatus(\"" .. i .. "\"," .. v .. ")\n";
    end
    
    return saveString;
end