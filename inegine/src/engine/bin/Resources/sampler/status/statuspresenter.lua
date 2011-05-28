StatusPresenter = {}

function StatusPresenter:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function StatusPresenter:SetClosingEvent(event)
	self.closingEvent = event;
end

function StatusPresenter:Init(main, statusView, character)
	self.main = main;
	self.statusView = statusView;
	self.character = character;

	statusView:Show();

    self:RegisterEvents();
    self:Update();
end

function StatusPresenter:RegisterEvents()
    local statusView = self.statusView;
    local main = self.main;
    local character = self.character;

	statusView:SetClosingEvent(
		function()
			if (self.closingEvent ~= nil) then
				self.closingEvent();
			end

			statusView:Hide();
		end
	);

end

function StatusPresenter:Update()
    if (self.statusView ~= nil) then
		self:AddItems();
    end
end

function StatusPresenter:AddItems()
	local nameText = self.character:GetFirstName() .. ", " .. self.character:GetLastName();
	
	self.statusView:SetName(nameText);
	
	local month, day = self.character:GetBirthday();
	local descriptionText = month .. status_month .. " " .. day .. status_day 
					  .. " " .. self.character:GetBloodtype() .. status_bloodtype;
	self.statusView:SetDescriptionText(descriptionText);
	
	
	self.statusView:AddGraphItem(status_sta, character:Read("sta"), character:Get("sta"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_will, character:Read("will"), character:Get("will"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_int, character:Read("int"), character:Get("int"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_cha, character:Read("cha"), character:Get("cha"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_grace, character:Read("grace"), character:Get("grace"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_moral, character:Read("moral"), character:Get("moral"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_sense, character:Read("sense"), character:Get("sense"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_rep, character:Read("rep"), character:Get("rep"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_stress, character:Read("stress"), character:Get("stress"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_mana, character:Read("mana"), character:Get("mana"), 0xBBBBBB);
	
	--empty dummy
	self.statusView:AddEmpty();
	

	self.statusView:AddGraphItem(status_sword, character:Read("sword"), character:Get("sword"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_magic, character:Read("magic"), character:Get("magic"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_alchemy, character:Read("alchemy"), character:Get("alchemy"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_music, character:Read("music"), character:Get("music"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_dance, character:Read("dance"), character:Get("dance"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_cooking, character:Read("cooking"), character:Get("cooking"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_logic, character:Read("logic"), character:Get("logic"), 0xBBBBBB);
	self.statusView:AddGraphItem(status_wis, character:Read("wis"), character:Get("wis"), 0xBBBBBB);

end