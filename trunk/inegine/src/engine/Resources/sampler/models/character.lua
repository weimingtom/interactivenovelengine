--Import
Character = {}

function Character:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.status = {}
		
	self:SetFatherBirthday(1, 1);
	self:SetBirthday(1, 1);
	self:SetBloodtype("A");
	self:SetFatherName("");
	self:SetDress("");

	self:Set("age", 12);
	self:Set("gold", 1000);
	
	--status
	self:Set("hp", 100);
	self:Set("will", 20);
	self:Set("stress", 0);
	--abilities
		
	return o
end

function Character:Set(key, value)
    self.status[key] = value;
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