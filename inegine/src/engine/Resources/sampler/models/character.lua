--Import
Character = {}

function Character:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.status = {}
	self.max = {}
	self.min = {}
	self.trigger = {}
	self.dress = nil;
	self:Initialize();	
	
	return o
end

function Character:Initialize()
	--profile
	self:SetFirstName("");
	self:SetLastName("");
	self:SetFatherBirthday(1, 1);
	self:SetBirthday(1, 1);
	self:SetBloodtype("A");
	self:SetFatherName("");
	self:SetDress("");
	self:SetBody("");
	self:Add("age", 12, 0, 999);
	self:Add("gold", 1000, -3000, 99999);
	
	--abilities
	self:Add("sta", 100, 0, 999);
	self:Add("will", 20, 0, 999);
	self:Add("int", 20, 0, 999);
	self:Add("cha", 20, 0, 999);
	self:Add("grace", 20, 0, 999);
	self:Add("moral", 20, 0, 999);
	self:Add("sense", 20, 0, 999);
	self:Add("rep", 20, 0, 999);
	self:Add("stress", 0, 0, 100);
	self:Add("mana", 0, 0, 100);
	--skills
	self:Add("sword", 0, 0, 300);
	self:Add("magic", 0, 0, 300);
	self:Add("alchemy", 0, 0, 300);
	self:Add("music", 0, 0, 300);
	self:Add("dance", 0, 0, 300);
	self:Add("cooking", 0, 0, 300);
	self:Add("logic", 0, 0, 300);
	self:Add("wis", 0, 0, 300);
	--todo: add job histories and attraction points
	--job histories
	self:Add("edu1", 0, 0, 999);
	self:Add("edu2", 0, 0, 999);
	self:Add("job1", 0, 0, 999);
	self:Add("job2", 0, 0, 999);
end

function Character:Add(key, value, min, max)
    self.status[key] = value;
    self.min[key] = min;
    self.max[key] = max;
end

function Character:Inc(key, value)
	self:Set(key, self:Get(key) + value);
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
    
    if (self.trigger[key] ~= nil) then
		Trace("trigger event executed!");
		self.trigger[key]();
	end
end

function Character:GetRatio(key)
	return self.status[key] / self.max[key] * 100;
end

function Character:Get(key)
    local base = self.status[key];
    local effective = base;
    if (inventoryManager ~= nil) then
		local itemlist = inventoryManager:GetItems("item");
		
		if (self.dress ~= nil and self.dress ~= "") then
			table.insert(itemlist, self.dress);
		end
		for i,v in pairs(itemlist) do
			local item = itemManager:GetItem(v);
			local itemCount = inventoryManager:GetItemCount(v);
			assert(item ~= nil);
			if (item[key] ~= nil) then
				effective = effective + itemCount * item[key];
			end
		end
    end
    
    return effective;
end

function Character:Read(key, digits)
	if (digits == nil) then digits = 0; end
	return string.format("%." .. (digits) .. "f", self:Get(key))
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

--tachie related
function Character:SetLookEvent(event)
	self.lookEvent = event;
end

function Character:GetDress()
	return self.dress;
end

function Character:SetDress(id)
	self.dress = id;
    if (self.lookEvent ~= nil) then
		Trace("look event executed!");
		self.lookEvent();
	end
end

function Character:GetBody()
	return self.body;
end

function Character:SetBody(id)
	self.body = id;
    if (self.lookEvent ~= nil) then
		Trace("look event executed!");
		self.lookEvent();
	end
end
--tachie related over

function Character:SetTriggerEvent(status, event)
	self.trigger[status] = event;
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
    saveString = saveString .. [[self:SetBody("]] .. self:GetBody() .. [[");]] .. "\n";
    
	for i,v in pairs(self.status) do
        saveString = saveString .. "self:Set(\"" .. i .. "\"," .. v .. ")\n";
    end
    
    return saveString;
end