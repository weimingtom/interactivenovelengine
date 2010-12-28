TachiePresenter = {}

function TachiePresenter:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function TachiePresenter:SetClosingEvent(event)
	self.closingEvent = event;
end

function TachiePresenter:Init(main, statusView, character)
	self.main = main;
	self.statusView = statusView;
	self.character = character;

	main:ToggleMainMenu(false);
	statusView:Show();

    self:RegisterEvents();
    self:Update();
end

function TachiePresenter:RegisterEvents()
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

function TachiePresenter:Update()
    if (self.statusView ~= nil) then
		self:AddItems();
    end
end