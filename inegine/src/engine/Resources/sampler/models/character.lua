--Import
Character = {}

function Character:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.status = {}
	self.max = {}
	self.min = {}
	
	self:Initialize();	
	
	return o
end

function Character:Initialize()
	self:SetFirstName("");
	self:SetLastName("");
	self:SetFatherBirthday(1, 1);
	self:SetBirthday(1, 1);
	self:SetBloodtype("A");
	self:SetFatherName("");
	self:SetDress("");

	self:Add("age", 12, 0, 999);
	self:Add("gold", 1000, -3000, 99999);
	
	--status
	self:Add("hp", 100, 0, 999);
	self:Add("will", 20, 0, 999);
	self:Add("int", 20, 0, 999);
	self:Add("cha", 20, 0, 999);
	self:Add("grace", 20, 0, 999);
	self:Add("moral", 20, 0, 999);
	self:Add("sense", 20, 0, 999);
	self:Add("rep", 20, 0, 999);
	self:Add("stress", 0, 0, 100);
	self:Add("mana", 0, 0, 100);
	self:Add("sword", 0, 0, 300);
	self:Add("magic", 0, 0, 300);
	self:Add("alchemy", 0, 0, 300);
	self:Add("music", 0, 0, 300);
	self:Add("dance", 0, 0, 300);
	self:Add("cooking", 0, 0, 300);
	self:Add("logic", 0, 0, 300);
	self:Add("wis", 0, 0, 300);
	--abilities
end

function Character:Add(key, value, min, max)
    self.status[key] = value;
    self.min[key] = min;
    self.max[key] = max;
end

function Character:Set(key, value)
	if (self.status[key] == nil) then
		error("invalid key!");
	end

	if (self.min[key] > value) then
		value = self.min[key];
	end
	
	if (self.max[key] < value) then
		value = self.max[key];
	end

    self.status[key] = value;
end

function Character:GetRatio(key)
	return self.status[key] / self.max[key] * 100;
end

function Character:Get(key)
    return self.status[key];
end

function Character:Read(key, digits)
	if (digits == nil) then digits = 0; end
	return string.format("%." .. (digits) .. "f", self.status[key])
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
    saveString = saveString .. "self:Initialize()\n";
    saveString = saveString .. [[self:SetFirstName("]] .. self:GetFirstName() .. [[");]] .. "\n";
    saveString = saveString .. [[self:SetLastName("]] .. self:GetLastName() .. [[");]] .. "\n";
    local mon, day = self:GetBirthday();
    saveString = saveString .. [[self:SetBirthday("]] .. mon .. "," .. day .. [[");]] .. "\n";
    local mon, day = self:GetFatherBirthday();
    saveString = saveString .. [[self:SetFatherBirthday("]] .. mon .. "," .. day .. [[");]] .. "\n";
    saveString = saveString .. [[self:SetBloodtype("]] .. self:GetBloodtype() .. [[");]] .. "\n";
    saveString = saveString .. [[self:SetFatherName("]] .. self:GetFatherName() .. [[");]] .. "\n";
    saveString = saveString .. [[self:SetDress("]] .. self:GetDress() .. [[");]] .. "\n";
    
	for i,v in pairs(self.status) do
        saveString = saveString .. "self:Set(\"" .. i .. "\"," .. v .. ")\n";
    end
    
    return saveString;
end