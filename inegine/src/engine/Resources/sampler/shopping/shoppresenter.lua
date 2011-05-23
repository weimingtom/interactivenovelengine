ShopPresenter = {}

function ShopPresenter:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.pageItems = 8;

	self.numPages = 0;
	self.currentPage = 0;

	self.selectedItem = nil;
	self.shopName = nil;
	
	self.itemCount = 0;
	
	return o
end

function ShopPresenter:SetClosingEvent(event)
	self.closingEvent = event;
end

function ShopPresenter:Init(main, shopView, itemManager, shopManager, inventoryManager, shopName)
	self.shopName = shopName;
	self.main = main;
	self.shopView = shopView;
	self.itemManager = itemManager;
	self.shopManager = shopManager;
	self.inventoryManager = inventoryManager;

	--shopView:SetBuyMode(false);
	shopView:SetDialogueName(shopManager:GetShop(shopName).owner);
	shopView:SetPortraitTexture(shopManager:GetShop(shopName).portrait);
	shopView:SetDialogueText(shopManager:GetShop(shopName).greetings);	
	shopView:ShowDialogue(true);
	
	
    shopView:Show();
    
    self:RegisterEvents();
    self:Update();
end

function ShopPresenter:Finalize()
	self.shopView:Hide();
end

function ShopPresenter:RegisterEvents()
    local shopView = self.shopView;
    local main = self.main;
    local shopManager = self.shopManager;

	shopView:SetClosingEvent(
		function()
			if (self.closingEvent ~= nil) then
				self.closingEvent();
			end
			self:Finalize();
		end
	);

	shopView:SetSelectedEvent(
		function (button, luaevent, args)
            self:SelectItem(args);
		end
	)


    shopView:SetUpButtonEvent(
        function()
            if (self:SetPage(-1)) then self:Update(); end
        end
    )

    shopView:SetDownButtonEvent(
        function()
            if (self:SetPage(1)) then self:Update(); end
        end
    )
    
    shopView:SetSelectedEvent(
		function(button, luaevent, args)
			self:SelectItem(args);
		end
	);
	
	shopView:SetCommitEvent(
		function(button, luaevent, args)
			self:AskCount(args);
		end
	);
	
	shopView:SetBuyingEvent(
		function()
			self:BuyItem();
		end
	);
	
	shopView:SetCountUpButtonEvent(
        function()
			local item = self.itemManager:GetItem(self.selectedItem);
			if (item.category ~= "dress") then
				self.itemCount = self.itemCount + 1;
				self:RefreshCount();
            end
        end
    )

    shopView:SetCountDownButtonEvent(
        function()
			if (self.itemCount > 1) then
				self.itemCount = self.itemCount - 1;
				self:RefreshCount();
			end
        end
    )
	
end

function ShopPresenter:Update()
    self:UpdateNumPages();
    if (self.shopView ~= nil) then
        self.shopView:ClearItems();
        self:AddItems();
        self:PrintPageNumbers();
    end
end

function ShopPresenter:PrintPageNumbers()
	self.shopView:PrintPageNumbers(self.numPages, self.currentPage);
end

function ShopPresenter:UpdateNumPages()
	self.numPages = math.ceil(self.shopManager:GetCategoryCount(self.shopName) / self.pageItems);
end

function ShopPresenter:AddItems()
	local shopView = self.shopView;
	local itemList = shopManager:GetItems(self.shopName);
	for i,listing in ipairs(itemList) do
		local v = self.itemManager:GetItem(listing.id);
		assert(v ~= nil, "item " .. listing.id .. " is null");
	    if (self:ItemInPage(i, self.currentPage)) then 
            shopView:AddItem(v.id, v.text, v.icon, v.price, 1, v.shortdesc);
	    end
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

function ShopPresenter:ItemInPage(index, page)
    local itemPage = math.floor((index - 1) / self.pageItems);
    if (page == itemPage) then
        return true;
    else
        return false;
    end
end

function ShopPresenter:SetPage(modifier)
    local oldpage = self.currentPage;
    local page = self.currentPage + modifier;
    if (page < 0) then
        self.currentPage = 0;
    elseif (page >= self.numPages) then
        self.currentPage = self.numPages - 1;
    else
        self.currentPage = page;
    end

    if (oldpage ~= self.currentPage) then
        return true;
    end
end

function ShopPresenter:SelectItem(itemID)
	local item = self.itemManager:GetItem(itemID);
	self.shopView:SelectItem(item.id, item.text, item.desc, item.icon, item.price);
	self.selectedItem = itemID;
end

function ShopPresenter:AskCount()
	self.itemCount = 1;
	self:RefreshCount();
end

function ShopPresenter:RefreshCount()
	local item = self.itemManager:GetItem(self.selectedItem);
	self.shopView:OpenCommitWindow(item.icon, item.text, self.itemCount, self.itemCount * item.price);
end

function ShopPresenter:BuyItem()
	Trace("buying " .. self.selectedItem)
	local item = self.itemManager:GetItem(self.selectedItem);
	
	--check if item is dress and already in inventory
	if (item.category == "dress" and inventoryManager:ItemExists(item.id)) then
		self.shopView:ClearDialogueText();
		self.shopView:SetDialogueText(shop_view_buy_failed_item_already_exists);
		self.shopView:CloseCommitWindow();
		return;
	end
	
	--check for gold
	local totalPrice = self.itemCount * item.price;
	if (character:Get("gold") < totalPrice) then
		self.shopView:ClearDialogueText();
		self.shopView:SetDialogueText(shop_view_buy_failed_not_enough_gold);
		self.shopView:CloseCommitWindow();
		return;
	end
	
	--handle buying transaction
	self.shopView:ClearDialogueText();
	--TODO: for consumables (i.e. food), display effect message (i.e. "daughter's charisma increased!")
	character:Dec("gold", totalPrice)
	if (item.category == "dress") then
		self.inventoryManager:AddItem(item.id, item.category, self.itemCount);
		self.shopView:SetDialogueText(shop_view_buy_success);
	elseif (item.category == "instant") then
		--use item
		character:UseItem(item.id);
		self.shopView:SetDialogueText(item.resulttext);
	end
	self.shopView:CloseCommitWindow();
end