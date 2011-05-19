-- InventoryView UI component implemented in lua
LoadScript "components\\luaview.lua"
LoadScript "components\\tabview.lua"
LoadScript "components\\flowview.lua"
LoadScript "components\\uifactory.lua"

InventoryView = LuaView:New();

function InventoryView:Init()
	self.activeTab = inventory_dress;
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local name = self.name;
	
	self.frame = View()
	self.frame.Name = name
	
	self.frame.x = 0;
	self.frame.y = 0;
	self.frame.Width = 800
	self.frame.Height = 600
	self.frame.alpha = 0
	self.frame.layer = 6
	
	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)	
		end
	
	parent:AddComponent(self.frame)
	
	local inventoryMenu = SpriteBase();
	self.inventoryMenu = inventoryMenu;
	inventoryMenu.Texture = "resources/ui/inventory_window.png"
	inventoryMenu.Visible = true;
	inventoryMenu.Layer = 3;
	self.frame:AddComponent(inventoryMenu)
	
	
	local dressRollOver = SpriteBase();
	self.dressRollOver = dressRollOver;
	dressRollOver.Texture = "resources/ui/inventory_window_dress_rollover.png"
	dressRollOver.Visible = false;
	dressRollOver.Layer = 4;
	dressRollOver:Hide();
	self.frame:AddComponent(dressRollOver)
	
	
	local itemRollOver = SpriteBase();
	self.itemRollOver = itemRollOver;
	itemRollOver.Texture = "resources/ui/inventory_window_item_rollover.png"
	itemRollOver.Visible = false;
	itemRollOver.Layer = 4;
	itemRollOver:Hide();
	self.frame:AddComponent(itemRollOver)

    local upButton = self:CreateUpButton(
    function()
        if (self.upButtonEvent ~= nil) then
            self.upButtonEvent();
        end
    end
    );
    upButton.x = 155
    upButton.y = 535
    upButton.width = 25
    upButton.height = 20
    self.frame:AddComponent(upButton);

    local downButton = self:CreateDownButton(
        function()
            if (self.downButtonEvent ~= nil) then
                self.downButtonEvent();
            end
        end
    );
    downButton.x = 246
    downButton.y = 535
    downButton.width = 25
    downButton.height = 20
    self.frame:AddComponent(downButton);

	local dressView = Flowview:New("dressview")
	dressView.frame.relative = true;
	dressView.frame.width = 350;
	dressView.frame.height = 326;
	dressView.frame.x = 40;
	dressView.frame.y = 225;
	dressView.frame.layer = 4;
	dressView.spacing = 2;
	dressView.padding = 2;
	self.dressView = dressView;
	self.frame:AddComponent(self.dressView.frame);
	self.dressView:Show();
	
	self.dressButton = UIFactory.CreateRollOverButton(
		function()
			self.itemView:Hide();
			self.dressView:Show();
			self.activeTab = inventory_dress;
		end,
		function ()
			self.dressRollOver:Show();
			self.itemRollOver:Hide();
		end,
		function ()
			self.dressRollOver:Hide();
			self.itemRollOver:Hide();
		end);
	self.dressButton.X =  33
	self.dressButton.Y = 181
	self.dressButton.Width = 66
	self.dressButton.Height = 32
	self.dressButton.Layer = 5
	self.frame:AddComponent(self.dressButton);
	
	local itemView = Flowview:New("itemview")
	self.itemView = itemView;
	itemView.frame.relative = true;
	itemView.frame.width = 350;
	itemView.frame.height = 326;
	itemView.frame.x = 40;
	itemView.frame.y = 225;
	itemView.frame.layer = 4;
	itemView.spacing = 5;
	itemView.padding = 10;
	itemView.frame.visible = false;
	itemView.frame.enabled = false;
	self.itemView = itemView;
	self.frame:AddComponent(self.itemView.frame);
		
	self.itemButton = UIFactory.CreateRollOverButton(
		function()
			self.itemView:Show();
			self.dressView:Hide();
			self.activeTab = inventory_item;
		end,
		function ()
			self.itemRollOver:Show();
			self.dressRollOver:Hide();
		end,
		function ()
			self.dressRollOver:Hide();
			self.itemRollOver:Hide();
		end);
	self.itemButton.X =  125
	self.itemButton.Y = 184
	self.itemButton.Width = 63
	self.itemButton.Height = 28
	self.itemButton.Layer = 5
	self.frame:AddComponent(self.itemButton);
	
	--page button
	local button = Button();
	self.pageButton = button;
	button.Width = 60;
	button.Height = 30;
	button.X = 184
	button.Y = 531;
	button.Layer = 10
	button.font = GetFont("item_name");
	button.TextColor = 0x2222FF
	button.Alignment = 1;
	button.VerticalAlignment = 1;
	button:Show();
	self.frame:AddComponent(button);
	
	self.backButton = UIFactory.CreateBackButton(
		function (button, luaevent, args)
				self:Dispose();
		end
	)
	self.backButton.X = 380
	self.backButton.Y = 460
	self.backButton.Layer = 10
	self.frame:AddComponent(self.backButton);
	
	-------------------
	-- detail window --
	-------------------
	local detailWindow = SpriteBase();
	self.detailWindow = detailWindow;
	detailWindow.Texture = "resources/ui/inventory_detail.png"
	detailWindow.Visible = true;
	detailWindow.Layer = 10;
	self.parent:AddComponent(detailWindow)
	detailWindow:Hide();
	
	local pic = Button();
	self.detailIcon = pic;
	pic.Visible = true;
	pic.Width = 60;
	pic.Height = 60;
	pic.X = 274
	pic.Y = 227
	pic.MouseDoubleClick = 
		function (button, luaevent, args)
			Trace("click!");
			if (self.equipEvent ~= nil) then
				self.equipEvent();
			end
		end
	detailWindow:AddComponent(pic);
	
	local button = Button();
	self.detailName = button;
	button.Width = 110;
	button.Height = 21;
	button.X = 355
	button.Y = 227
	button.font = GetFont("item_name");
	button.TextColor = 0x000000
	button.Alignment = 0;
	button.VerticalAlignment = 1;
	detailWindow:AddComponent(button);
	
	local button = Button();
	self.detailPrice = button;
	button.Width = 110;
	button.Height = 20;
	button.X = 470
	button.Y = 227;
	button.font = GetFont("item_desc");
	button.TextColor = 0x000000
	button.Alignment = 0;
	button.VerticalAlignment = 1;
	detailWindow:AddComponent(button);
	
	local button = Button();
	self.detailDesc = button;
	button.Width = 175;
	button.Height = 50;
	button.X = 355
	button.Y = 236;
	button.font = GetFont("item_desc");
	button.TextColor = 0x000000
	button.Alignment = 0;
	button.VerticalAlignment = 1;
	detailWindow:AddComponent(button);
	
	self.sellButton = UIFactory.CreateRollOverButton(
		function()
			if (self.sellEvent ~= nil) then
				self.sellEvent();
			end
		end,
		function ()
			self.detailWindowRollover:Show();
		end,
		function ()
			self.detailWindowRollover:Hide();
		end);
	self.sellButton.X =  455
	self.sellButton.Y = 323
	self.sellButton.Width = 51
	self.sellButton.Height = 30
	self.sellButton.Layer = 5
	detailWindow:AddComponent(self.sellButton);	
	
	local detailWindowRollover = SpriteBase();
	self.detailWindowRollover = detailWindowRollover;
	detailWindowRollover.Texture = "resources/ui/inventory_detail_rollover.png"
	detailWindowRollover.Visible = true;
	detailWindowRollover.Layer = 4;
	detailWindow:AddComponent(detailWindowRollover)
	detailWindowRollover:Hide();
	
	
	self.backButton = UIFactory.CreateBackButton(
		function (button, luaevent, args)
			self:CloseDetail();
		end
	)
	self.backButton.X = 537
	self.backButton.Y = 235
	self.backButton.Layer = 10
	detailWindow:AddComponent(self.backButton);
	
	
end

function InventoryView:CloseDetail()
	self.detailWindow:Hide();
	self.frame.enabled = true;
end

function InventoryView:CreateUpButton(event)
	local newButton = View()
	newButton.Relative = true;
	newButton.Layer = 15
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 18;
	newButton.Height = 12;
	newButton.State = {}
	newButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
                if (event~=nil) then 
					event(button, luaevent, args);
				end
			end
		end
	return newButton;
end

function InventoryView:CreateDownButton(event)
	local newButton = View()
	newButton.Relative = true;
	newButton.Layer = 15
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 18;
	newButton.Height = 12;
	newButton.State = {}
	newButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				Trace("button down!");
                if (event~=nil) then 
					event(button, luaevent, args);
				end
			end
		end
	return newButton;
end

function InventoryView:AddDressItem(buttonName, buttonText, icon, price, count, effect, equipped)
	self.dressView:Add(UIFactory.CreateItemButton(buttonName, buttonText, icon, price, count, effect, self.selectedEvent, equipped));
end

function InventoryView:AddItemItem(buttonName, buttonText, icon, price, count, effect)
	self.itemView:Add(UIFactory.CreateItemButton(buttonName, buttonText, icon, price, count, effect, self.selectedEvent));
end

function InventoryView:AddFurnitureItem(buttonName, buttonText, icon)
	--self.furnitureView:Add(UIFactory.CreateItemButton(buttonName, buttonText, icon, price, count, effect, selectedEvent));
end

function InventoryView:SetSellEvent(event)
	self.sellEvent = event;
end

function InventoryView:SetSelectedEvent(event)
	self.selectedEvent = event;
end

function InventoryView:SetUpButtonEvent(event)
    self.upButtonEvent = event;
end

function InventoryView:SetDownButtonEvent(event)
    self.downButtonEvent = event;
end

function InventoryView:SelectItem(itemId, itemName, description, icon, price, count)
	self.detailWindow:Show();
	self.frame.enabled = false;
	self.detailIcon.texture = icon;
	self.detailName.text = itemName;
	self.detailPrice.text = price .. "G"
	self.detailDesc.text = description;
end

function InventoryView:GetActiveTab()
    return self.activeTab;
end

function InventoryView:ClearDressItems()
	self.dressView:Clear();
end

function InventoryView:ClearItemItems()
	self.itemView:Clear();
end

function InventoryView:ClearFurnitureItems()
	--self.furnitureView:Clear();
end

function InventoryView:EquipItem()
	if (self.equipEvent ~= nil) then
		self:equipEvent();
	end
end

function InventoryView:SetEquipEvent(event)
	self.equipEvent = event;
end

function InventoryView:PrintPageNumbers(nd, cd, ni, ci, nf, cf)
	if (self.activeTab == inventory_dress) then
		self.pageButton.Text = (cd + 1) .. "/" .. nd;
	elseif (self.activeTab == inventory_item) then
		self.pageButton.Text = (ci + 1) .. "/" .. ni;
	elseif (self.activeTab == inventory_furniture) then
		self.pageButton.Text = (cf + 1) .. "/" .. nf;
	end
end