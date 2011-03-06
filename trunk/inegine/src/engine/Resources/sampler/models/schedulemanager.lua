--Import
ScheduleManager = {}

function ScheduleManager:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function ScheduleManager:Load()
    self.csv = GetCsv("scheduledata");
    self.csv_success = GetCsv("schedulesuccess");
    self.csv_failure = GetCsv("schedulefailure");
end

function ScheduleManager:GetItemCount(category)
	local count = 0;
	for i=0, self.csv.Count-1 do
        local c = self.csv:GetString(i, "category");
        if (category == c) then count = count + 1;
        end
    end
    return count;
end

function ScheduleManager:ExtractItem(i)
    local item = {};
    item.category = self.csv:GetString(i, "category");
    item.id = self.csv:GetString(i, "id");
    item.text = self.csv:GetString(i, "name");
    item.price = self.csv:GetString(i, "price");
    item.icon = self.csv:GetString(i, "icon");
    item.desc = self.csv:GetString(i, "desc");
    item.successani = self.csv:GetString(i, "successani");
    item.failureani = self.csv:GetString(i, "failureani");
    return item;
end

function ScheduleManager:GetItems(category)
	local scheduleList = {};
    for i=0, self.csv.Count-1 do
        if (category == self.csv:GetString(i, "category")) then
			table.insert(scheduleList, self:ExtractItem(i));
        end
    end
	return scheduleList;
end

function ScheduleManager:GetItem(id)
    local itemIndex
    for i=0, self.csv.Count-1 do
        if (id == self.csv:GetString(i, "id")) then
			itemIndex = i;
        end
    end
	
	return self:ExtractItem(itemIndex);

end

function ScheduleManager:GetSuccessEffect(id)
    for i=0, self.csv.Count-1 do
		if (id == self.csv_success:GetString(i, "id")) then
			local item = {};
			--success
			item.hp = self.csv_success:GetFloat(i, "health");
			item.stress = self.csv_success:GetFloat(i, "stress");
			return item;
		end
	end
end

function ScheduleManager:GetFailureEffect(id)
    for i=0, self.csv.Count-1 do
		if (id == self.csv_failure:GetString(i, "id")) then
			local item = {};
			--failure
			item.hp = self.csv_failure:GetFloat(i, "health");
			item.stress = self.csv_failure:GetFloat(i, "stress");
			return item;
		end
    end
end

function ScheduleManager:SetSelectedSchedules(selectedSchedules)
    self.selectedSchedules = selectedSchedules;
end

function ScheduleManager:GetSelectedSchedules()
    return self.selectedSchedules;
end

function ScheduleManager:ProcessSchedule(id)
	local numDays = 8;
	local successeffect = self:GetSuccessEffect(id);
	local failureeffect = self:GetFailureEffect(id);
    local schedule = self:GetItem(id);
    local result = "";
    local success = false;
    local animation = "";
    local rate = 0;
    local numSuccesses = 0;
    local effect = self:EmptyEffect();
	
    if (schedule.category == "edu") then
		rate = 0.5;--self:GetEduRate(BASE_RATE, character:Get("will"), character:Get("stress"));
    elseif (schedule.category == "job") then
		rate = 1;
    elseif (schedule.category == "vac") then
		rate = 1;
	else
		error("invalid schedule category!");
	end

	for i=1, numDays do
		local roll = math.random();
		Trace(i .. ":" .. roll);
		if (roll < rate) then 
			--success
			self:SaveEffect(effect, successeffect);
			numSuccesses = numSuccesses + 1;
		else
			self:SaveEffect(effect, failureeffect);
			--failure
		end
	end
	
	Trace("successes: " .. numSuccesses);
	
	self:ApplyEffect(effect);
	
	if (numSuccesses >= numDays / 2) then
		--success
		success = true;
		result = self:ComposeString("SUCCESS\n", effect);
		animation = schedule.successani;
	else
		--failure
		success = false;
		result = self:ComposeString("FAILURE\n", effect);
		animation = schedule.failureani;
	end
       
    return schedule.text, success, result, animation;
end

function ScheduleManager:EmptyEffect()
	local effect = {};
	effect.hp = 0;
	effect.stress = 0;
	return effect;
end

function ScheduleManager:SaveEffect(buffer, effect)
	buffer.hp = buffer.hp + effect.hp;
	buffer.stress = buffer.stress + effect.stress;
end

function ScheduleManager:ApplyEffect(effect)
	character:Set("hp", character:Get("hp") + effect.hp);
	character:Set("stress", character:Get("stress") + effect.stress); 
end

function ScheduleManager:ComposeString(header, effect)
	local result = header;
	result = result .. "HEALTH : " .. character:Read("hp", 1) .. " (" .. self:GenString(effect.hp) .. ")";
	result = result .. "\nSTRESS : " .. character:Read("stress", 1) .. " (" .. self:GenString(effect.stress) .. ")";
	return result;
end

function ScheduleManager:GenString(value)
	if (value == nil or value == 0) then
		return " ";
	else
		if (value > 0) then
			value = string.format("%." .. (1) .. "f", value)
			return "+" .. value;
		elseif (value < 0) then
			value = string.format("%." .. (1) .. "f", value)
			return value;
		else
			return " ";
		end
	end
end

function ScheduleManager:GetBaseRate(ability)
	if (ability >= 200) then
		return 0.2;
	elseif (ability >= 100) then
		return 0.1;
	elseif (ability >= 50) then
		return 0.05;
	else
		return 0;
	end
end

function ScheduleManager:GetStressRate(stress)
	if (stress >= 90) then
		return -0.5;
	elseif (stress >= 75) then
		return -0.25;
	elseif (stress >= 50) then
		return -0.1;
	elseif (stress >= 25) then
		return 0;
	elseif (stress < 25) then
		return 0.1;
	end
end

function ScheduleManager:GetEduRate(base, will, stress)
	local rate = base;
	rate = rate + self:GetBaseRate(will);
	rate = rate + self:GetStressRate(stress);
	if (rate > 0.99) then rate = 0.99; end
	if (rate < 0.25) then rate = 0.25; end
	return rate;
end