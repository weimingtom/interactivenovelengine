InventoryPresenter = {}

function InventoryPresenter:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.pageItems = 8;

	self.numDressPages = 0;
	self.currentDressPage = 0;

	self.numItemPages = 0;
	self.currentItemPage = 0;

	self.numFurniturePages = 0;
	self.currentFurniturePage = 0;

	self.focuseditemID = nil;

    self.uniqueSequence = 0;
    self.keyMap = {};

	return o
end

function InventoryPresenter:SetClosingEvent(event)
	self.closingEvent = event;
end

function InventoryPresenter:Init(main, inventoryView, itemManager, inventoryManager)
	self.main = main;
	self.inventoryView = inventoryView;
	self.itemManager = itemManager;
    self.inventoryManager = inventoryManager;

	main:ToggleMainMenu(false);
	main:SetTachiePosition(inventoryView.frame.X + inventoryView.frame.Width + 10);
	
    inventoryView:Show();
    
    self:RegisterEvents();
    self:Update();
end

function InventoryPresenter:Finalize()
	self.inventoryView:Hide();
	self.main:ToggleMainMenu(true);
	self.main:CenterTachie();
end

function InventoryPresenter:RegisterEvents()
    local inventoryView = self.inventoryView;
    local main = self.main;
    local itemManager = self.itemManager;
    local inventoryManager = self.inventoryManager;

	inventoryView:SetClosingEvent(
		function()
			if (self.closingEvent ~= nil) then
				self.closingEvent();
			end
			self:Finalize();
		end
	);

	inventoryView:SetSelectedEvent(
		function (button, luaevent, args)
            self:SelectItem(self:GetID(args));
		end
	)


    inventoryView:SetUpButtonEvent(
        function()
            local activeTab = inventoryView:GetActiveTab();
            if (activeTab == "Dress") then
                if (self:SetDressPage(-1)) then self:Update(); end
            elseif (activeTab == "Item") then
                if (self:SetItemPage(-1)) then self:Update(); end
            elseif (activeTab == "Furniture") then
                if (self:SetFurniturePage(-1)) then self:Update(); end
            end
        end
    )

    inventoryView:SetDownButtonEvent(
        function()
            local activeTab = inventoryView:GetActiveTab();
            if (activeTab == "Dress") then
                if (self:SetDressPage(1)) then self:Update(); end
            elseif (activeTab == "Item") then
                if (self:SetItemPage(1)) then self:Update(); end
            elseif (activeTab == "Furniture") then
                if (self:SetFurniturePage(1)) then self:Update(); end
            end
        end
    )
    
    inventoryView:SetEquipEvent(
		function()
			self:EquipItem();
		end
    )
end

function InventoryPresenter:Update()
    self:UpdateNumPages();
    if (self.inventoryView ~= nil) then
        self.inventoryView:ClearDressItems();
        self.inventoryView:ClearItemItems();
        self.inventoryView:ClearFurnitureItems();
        self:AddItems();
    end
end

function InventoryPresenter:UpdateNumPages()
	self.numDressPages = math.ceil(self.inventoryManager:GetItemCount("dress") / self.pageItems);
	self.numItemPages = math.ceil(self.inventoryManager:GetItemCount("item") / self.pageItems);
	self.numFurniturePages = math.ceil(self.inventoryManager:GetItemCount("furniture") / self.pageItems);
end

function InventoryPresenter:AddItems()
	local inventoryView = self.inventoryView;
	local itemList = self.inventoryManager:GetItems("dress");
	for i,v in ipairs(itemList) do
	    if (self:ItemInPage(i, self.currentDressPage)) then
            local item = self.itemManager:GetItem(v);
            inventoryView:AddDressItem(self:GetKey(item.id), item.text, item.icon);
	    end
    end
	local itemList = self.inventoryManager:GetItems("item");
	for i,v in ipairs(itemList) do
	    if (self:ItemInPage(i, self.currentItemPage)) then
            local item = self.itemManager:GetItem(v);
		    inventoryView:AddItemItem(self:GetKey(item.id), item.text, item.icon);
        end
	end

	local itemList = self.inventoryManager:GetItems("furniture");
	for i,v in ipairs(itemList) do
	    if (self:ItemInPage(i, self.currentFurniturePage)) then
            local item = self.itemManager:GetItem(v);
		    inventoryView:AddFurnitureItem(self:GetKey(item.id), item.text, item.icon);
        end
	end
end

function InventoryPresenter:GetKey(id)
	self.uniqueSequence = self.uniqueSequence + 1;
	local key = "key" .. self.uniqueSequence;
    self.keyMap[key] = id;
    return key;
end

function InventoryPresenter:GetID(key)
    return self.keyMap[key];
end

function InventoryPresenter:SelectItem(id)
	local item = self.itemManager:GetItem(id);
	self.inventoryView:SelectItem(item.id, item.text, item.desc, item.icon, item.price);
	self.selectedItem = id;
	if (self.inventoryManager:ItemEquipped(id)) then
		self.inventoryView:SetEquipMode(false);
	else
		self.inventoryView:SetEquipMode(true);
	end	
end

function InventoryPresenter:EquipItem()
	if (self.selectedItem ~= nil) then
		local itemID = self.selectedItem;
		if (self.inventoryManager:ItemEquipped(itemID)) then
			self.inventoryManager:UnequipItem(itemID);
		else
			self.inventoryManager:EquipItem(itemID);
		end
		self:SelectItem(itemID);
	end
end

function table.contains(tbl, item)
	for i,v in ipairs(tbl) do
		if (item == v) then
            return true;
        end
	end
    return false;
end

function table.removeItem(tbl, item)
	for i,v in ipairs(tbl) do
		if (item == v) then
            table.remove(tbl, i)
            return;
        end
	end
end

function InventoryPresenter:ItemInPage(index, page)
    local itemPage = math.floor((index - 1) / self.pageItems);
    if (page == itemPage) then
        return true;
    else
        return false;
    end
end

function InventoryPresenter:SetDressPage(modifier)
    local oldpage = self.currentDressPage;
    local page = self.currentDressPage + modifier;
    if (page < 0) then
        self.currentDressPage = 0;
    elseif (page >= self.numDressPages) then
        self.currentDressPage = self.numDressPages - 1;
    else
        self.currentDressPage = page;
    end

    if (oldpage ~= self.currentDressPage) then
        return true;
    end
end

function InventoryPresenter:SetItemPage(modifier)
    local oldpage = self.currentItemPage;
    local page = self.currentItemPage + modifier;
    if (page < 0) then
        self.currentItemPage = 0;
    elseif (page >= self.numItemPages) then
        self.currentItemPage = self.numItemPages - 1;
    else
        self.currentItemPage = page;
    end

    if (oldpage ~= self.currentItemPage) then
        return true;
    end
end

function InventoryPresenter:SetFurniturePage(modifier)
    local oldpage = self.currentFurniturePage;
    local page = self.currentFurniturePage + modifier;
    if (page < 0) then
        self.currentFurniturePage = 0;
    elseif (page >= self.numFurniturePages) then
        self.currentFurniturePage = self.numFurniturePages - 1;
    else
        self.currentFurniturePage = page;
    end

    if (oldpage ~= self.currentFurniturePage) then
        return true;
    end
end
