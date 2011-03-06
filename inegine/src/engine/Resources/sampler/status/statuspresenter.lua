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

	main:ToggleMainMenu(false);
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
			main:ToggleMainMenu(true);
		end
	);

end

function StatusPresenter:Update()
    if (self.statusView ~= nil) then
		self:AddItems();
    end
end

function StatusPresenter:AddItems()
	local descriptionText = self.character:GetFirstName() .. ", " .. self.character:GetLastName();
	self.statusView:SetDescriptionText(descriptionText);
	
	
	self.statusView:AddGraphItem("ü��", character:Read("hp"), character:Get("hp"), 0xBBBBBB);
	self.statusView:AddGraphItem("�ǿ�", character:Read("will"), character:Get("will"), 0xBBBBBB);
	self.statusView:AddGraphItem("����", character:Read("int"), character:Get("int"), 0xBBBBBB);
	self.statusView:AddGraphItem("�ŷ�", character:Read("cha"), character:Get("cha"), 0xBBBBBB);
	self.statusView:AddGraphItem("��ǰ", character:Read("grace"), character:Get("grace"), 0xBBBBBB);
	self.statusView:AddGraphItem("���", character:Read("moral"), character:Get("moral"), 0xBBBBBB);
	self.statusView:AddGraphItem("����", character:Read("sense"), character:Get("sense"), 0xBBBBBB);
	self.statusView:AddGraphItem("����", character:Read("rep"), character:Get("rep"), 0xBBBBBB);
	self.statusView:AddGraphItem("��Ʈ����", character:Read("stress"), character:Get("stress"), 0xBBBBBB);
	self.statusView:AddGraphItem("����", character:Read("mana"), character:Get("mana"), 0xBBBBBB);

	self.statusView:AddGraphItem("�˼�", character:Read("sword"), character:Get("sword"), 0xBBBBBB);
	self.statusView:AddGraphItem("����", character:Read("magic"), character:Get("magic"), 0xBBBBBB);
	self.statusView:AddGraphItem("���ݼ�", character:Read("alchemy"), character:Get("alchemy"), 0xBBBBBB);
	self.statusView:AddGraphItem("����", character:Read("music"), character:Get("music"), 0xBBBBBB);
	self.statusView:AddGraphItem("��", character:Read("dance"), character:Get("dance"), 0xBBBBBB);
	self.statusView:AddGraphItem("�丮", character:Read("cooking"), character:Get("cooking"), 0xBBBBBB);
	self.statusView:AddGraphItem("��", character:Read("logic"), character:Get("logic"), 0xBBBBBB);
	self.statusView:AddGraphItem("���", character:Read("wis"), character:Get("wis"), 0xBBBBBB);

end