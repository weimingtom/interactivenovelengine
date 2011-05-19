LoadScript "components\\luaview.lua"

ShopListView = LuaView:New();

function ShopListView:Init()
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local font = GetFont("default")
	local name = self.name;
	
	self.frame = View()
	self.frame.Name = name
	
	self.frame.Width = GetWidth();
	self.frame.Height = GetHeight();
	self.frame.x = 0;--(GetWidth() - self.frame.Width) / 2;
	self.frame.y = 0;--(GetHeight() - self.frame.Height) / 2;
	self.frame.alpha = 155
	self.frame.layer = 3
	
	self.frame.Visible = false
	self.frame.Enabled = false
	parent:AddComponent(self.frame)
	
	local shopListMenu = SpriteBase();
	self.shopListMenu = shopListMenu;
	shopListMenu.Texture = "resources/ui/store_list.png"
	shopListMenu.Visible = true;
	shopListMenu.Layer = 3;
	self.frame:AddComponent(shopListMenu)
	
	local storeList = Flowview:New("storeList")
	storeList.frame.relative = true;
	storeList.frame.width = 229;
	storeList.frame.height = 80;
	storeList.frame.x = 280;
	storeList.frame.y = 251;
	storeList.frame.layer = 4;
	storeList.spacing = 20;
	storeList.padding = 2;
	self.storeList = storeList;
	self.frame:AddComponent(self.storeList.frame);
	self.storeList:Show();
	
	storeList:Add(self:CreateButton("shop0", "resources/icon/shop01a.png", "resources/icon/shop01b.png", false));
	storeList:Add(self:CreateButton("shop1", "resources/icon/shop02a.png", "resources/icon/shop02b.png"));
	storeList:Add(self:CreateButton("shop2", "resources/icon/shop03a.png", "resources/icon/shop03b.png"));
	

	self.backButton = UIFactory.CreateBackButton(
		function (button, luaevent, args)
				self:Dispose();
		end
	)
	self.backButton.X = 491
	self.backButton.Y = 259
	self.backButton.Layer = 10
	self.frame:AddComponent(self.backButton);

end

function ShopListView:SetShopSelectedEvent(event)
	self.shopSelectedEvent = event;
end

function ShopListView:CreateButton(name, texture, rolloverTexture, enabled)
	local button = UIFactory.CreateButton(texture, rolloverTexture,	
        function (button, luaevent, args)
			if (self.shopSelectedEvent ~= nil) then
				if (enabled == nil or enabled == true) then
					self.shopSelectedEvent(button, luaevent, name);
				end
			end
		end)
		
	button.Width = 60;
	button.Height = 72;
	return button;	
end

function ShopListView:SetGreeting(portrait, name, text)	
end