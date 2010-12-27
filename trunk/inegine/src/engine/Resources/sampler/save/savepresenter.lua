SavePresenter = {}

function SavePresenter:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self

    return o
end

function SavePresenter:SetClosingEvent(event)
	self.closingEvent = event;
end

function SavePresenter:Init(main, saveView, saveManager)
	self.main = main;
	self.saveView = saveView;
	self.saveManager = saveManager;

	self.main:ToggleMainMenu(false);
	self.main:ShowTachie(false);
	
    saveView:Show();
    
    self:RegisterEvents();
    self:Update();
end

function SavePresenter:Finalize()
	self.saveView:Hide();

	self.main:ToggleMainMenu(true);
	self.main:ShowTachie(true);
end

function SavePresenter:RegisterEvents()
    local saveView = self.saveView;
    local main = self.main;

	saveView:SetClosingEvent(
		function()
			if (self.closingEvent ~= nil) then
				self.closingEvent();
			end
			self:Finalize();
		end
	);

	saveView:SetSelectedEvent(
		function (id)
            Trace(id);
		end
	)

	saveView:SetSaveEvent(
		function()
			self:Save();
		end
	);

end

function SavePresenter:Update()
    self.saveView:Clear();
    self.saveView:AddSlot("1", "비어있음");
    self.saveView:AddSlot("2", "비어있음");
    self.saveView:AddSlot("3", "비어있음");
    self.saveView:AddSlot("4", "비어있음");
    self.saveView:AddSlot("5", "비어있음");
end

function SavePresenter:Save()
    self.saveManager:Save();
end