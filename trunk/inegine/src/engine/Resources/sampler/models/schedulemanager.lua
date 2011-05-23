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

function ScheduleManager:GetCategoryCount(category)
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
    item.shortdesc = self.csv:GetString(i, "shortdesc");
    item.ability = self.csv:GetString(i, "ability");
    item.successani = self.csv:GetString(i, "successani");
    item.failureani = self.csv:GetString(i, "failureani");
    return item;
end

function ScheduleManager:GetItems(category)
	local scheduleList = {};
    for i=0, self.csv.Count-1 do
        if (category == nil or category == self.csv:GetString(i, "category")) then
			table.insert(scheduleList, self:ExtractItem(i));
        end
    end
	return scheduleList;
end

function ScheduleManager:GetItem(id)
    local itemIndex = -1;
    for i=0, self.csv.Count-1 do
        if (id == self.csv:GetString(i, "id")) then
			itemIndex = i;
        end
    end
	assert(itemIndex ~= -1, "schedule " .. id .. " is not found");
	return self:ExtractItem(itemIndex);

end

function ScheduleManager:GetSuccessEffect(id)
	return self:GetEffect(id, self.csv_success);
end

function ScheduleManager:GetFailureEffect(id)
	return self:GetEffect(id, self.csv_failure);
end

function ScheduleManager:GetEffect(id, csv)
    for i=0, csv.Count-1 do
		if (id == csv:GetString(i, "id")) then
			local item = {};
			for j,key in ipairs(character:GetKeys()) do
				if (csv:HasColumn(key)) then
					Trace("effect " .. key .. " present!");
					item[key] = csv:GetFloat(i, key);
				end
			end
			return item;
		end
	end
	assert(false, "id \"" .. id .. "\" not found in csv");
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
	
	Trace("---------------------------");
	Trace("Processing schedule:" .. id);
	
    if (schedule.category == "edu") then
		Trace("Category : Education");
		rate = self:GetEduRate(BASE_EDU_RATE, character:Get("will"), character:Get("stress"));
    elseif (schedule.category == "job") then
		Trace("Category : Job");
		--increase schedule hit number
		character:Inc(character:GetScheduleHitKey(schedule.id), 1);
		
		Trace("History Hits : " .. character:Get(character:GetScheduleHitKey(schedule.id)));
		Trace("Ability : " .. schedule.ability .. " = " .. character:Get(schedule.ability));
		Trace("Stress : " .. character:Get("stress"));
		
		rate = self:GetJobRate(BASE_JOB_RATE, character:Get(schedule.ability), 
			character:Get(character:GetScheduleHitKey(schedule.id)), character:Get("stress"));
    elseif (schedule.category == "vac") then
		Trace("Category : Vacation");
		rate = 1;
	else
		error("invalid schedule category!");
	end
	
	Trace("Rate : " .. rate);

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
	
	Trace("Successes : " .. numSuccesses);
	self:ApplyEffect(effect);
	
	--output effect for debugging
	
	Trace("<Success Effect>");
	self:TraceEffect(successeffect);
	
	Trace("<Failure Effect>");
	self:TraceEffect(failureeffect);
	
	Trace("<Net Effect>");
	self:TraceEffect(effect);
	
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
       
	Trace("---------------------------");
	
    return schedule.text, success, result, animation;
end

function ScheduleManager:EmptyEffect()
	local effect = {};
	return effect;
end

function ScheduleManager:SaveEffect(target, source)
	for i,v in pairs(source) do
		if (target[i] == nil) then
			target[i] = 0;
		end
		
		target[i] = source[i] + target[i];
	end
end

function ScheduleManager:TraceEffect(effect)
	for i,v in pairs(effect) do
		Trace(i .. " : " .. effect[i]);
	end
end

function ScheduleManager:ApplyEffect(effect)
	for i,v in pairs(effect) do
		character:Inc(i, v);
	end
end

function ScheduleManager:ComposeString(header, effect)
	local result = header;
	result = result .. schedule_manager_sta .. character:Read("sta", 1) .. " (" .. self:GenString(effect.sta) .. ")\n";
	result = result .. schedule_manager_stress .. character:Read("stress", 1) .. " (" .. self:GenString(effect.stress) .. ")\n";
	result = result .. schedule_manager_gold .. character:Read("gold", 0) .. " (" .. self:GenString(effect.gold) .. ")";
	return result;
end

function ScheduleManager:GenString(value)
	if (value == nil or value == 0) then
		return "0";
	else
		if (value > 0) then
			value = string.format("%." .. (1) .. "f", value)
			return "+" .. value;
		elseif (value < 0) then
			value = string.format("%." .. (1) .. "f", value)
			return value;
		else
			return "0";
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

function ScheduleManager:GetHistoryRate(history)
	if (history > 30) then
		return 0.3;
	else
		return history / 100;
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

function ScheduleManager:GetJobRate(base, ability, history, stress)
	Trace(base .. "," .. ability .. "," .. history .. "," .. stress);
	local rate = base;
	rate = rate + self:GetBaseRate(ability);
	rate = rate + self:GetHistoryRate(history);
	rate = rate + self:GetStressRate(stress);
	if (rate > 0.99) then rate = 0.99; end
	if (rate < 0.25) then rate = 0.25; end
	return rate;
end