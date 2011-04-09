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

function SavePresenter:SetTitleEvent(event)
	self.titleEvent = event;
end

function SavePresenter:Init(saveView, saveManager, main)
	self.saveView = saveView;
	self.saveManager = saveManager;
	
    saveView:Show();
    
    self:RegisterEvents();
    self:Update();
end

function SavePresenter:Finalize()
	self.saveView:Hide();
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
			self.selectedID = id;
		end
	)

	saveView:SetSaveEvent(
		function()
			self:Save();
		end
	);

	saveView:SetLoadEvent(
		function()
			self:Load();
		end
	);
	
	saveView:SetTitleEvent(
		function()
			self:Title();
		end
	);
	
end

function SavePresenter:Update()
    self.saveView:Clear();
    local ids = saveManager:GetRecordIDs();
    local itemCount = 1;
    for i,v in ipairs(ids) do
		self.saveView:AddSlot(v, saveManager:GetRecordDescription(v));
		itemCount = itemCount + 1;
	end
	
	for i=itemCount,5 do
		self.saveView:AddSlot("save_" .. i, "empty");
	end
end

function SavePresenter:Save()
    if (self.selectedID ~= nil) then 
		self.saveManager:Save(self.selectedID, character:GetLastName() .. ", " .. 
			character:GetFirstName() .. " (" .. os.date("%m/%d %H:%M:%S") .. ")");
        self.selectedID = nil;
		self:Update();
	end
end

function SavePresenter:Load()
    if (self.selectedID ~= nil) then
		self.saveManager:Load(self.selectedID);
        self.selectedID = nil;
    end
end

function SavePresenter:Title()
	if (self.titleEvent ~= nil) then
		self.titleEvent();
		self.saveManager:Title();
	end
end