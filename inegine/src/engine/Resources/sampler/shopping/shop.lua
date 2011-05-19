LoadScript "components\\luaview.lua"
LoadScript "components\\messagewindow.lua"
LoadScript "components\\flowview.lua"

ShopView = LuaView:New();

shop_font_default = "default"
shop_font_small = "small"
shop_font_menu = "menu"

function ShopView:Init()
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local name = self.name;
	
	self.frame = View()
	self.frame.Name = name
	
	self.frame.Width = GetWidth()
	self.frame.Height = GetHeight()
	self.frame.x = 0;
	self.frame.y = 0;
	self.frame.alpha = 255
	self.frame.layer = 6
	
	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)	
		end
	
	parent:AddComponent(self.frame)
		
	
	local shopMenu = SpriteBase();
	self.shopMenu = shopMenu;
	shopMenu.Texture = "resources/ui/store_menu.png"
	shopMenu.Visible = true;
	shopMenu.Layer = 3;
	self.frame:AddComponent(shopMenu)	
		
	local dialogueWin = MessageWindow:New("dialogueWin", self.frame);
	self.dialogueWin = dialogueWin;
	dialogueWin:Init();
	dialogueWin.frame.relative = true;
	dialogueWin.frame.x = 0;
	dialogueWin.frame.y = self.frame.height - dialogueWin.frame.height;
	dialogueWin:Hide();
	
	
    local upButton = self:CreateUpButton(
    function()
        if (self.upButtonEvent ~= nil) then
            self.upButtonEvent();
        end
    end
    );
    upButton.x = 215
    upButton.y = 390
    upButton.width = 20
    upButton.height = 20
    self.frame:AddComponent(upButton);

    local downButton = self:CreateDownButton(
        function()
            if (self.downButtonEvent ~= nil) then
                self.downButtonEvent();
            end
        end
    );
    downButton.x = 312
    downButton.y = 390
    downButton.width = 20
    downButton.height = 20
    self.frame:AddComponent(downButton);

	--page button
	local button = Button();
	self.pageButton = button;
	button.Width = 60;
	button.Height = 30;
	button.X = 252
	button.Y = 386;
	button.Layer = 10
	button.font = GetFont("item_name");
	button.TextColor = 0x2222FF
	button.Alignment = 1;
	button.VerticalAlignment = 1;
	button:Show();
	self.frame:AddComponent(button);
	

	local itemListView = Flowview:New("itemListView")
	itemListView.frame.relative = true;
	itemListView.frame.width = 350;
	itemListView.frame.height = 238;
	itemListView.frame.x = 105;
	itemListView.frame.y = 155;
	itemListView.frame.layer = 4;
	itemListView.spacing = 0;
	itemListView.padding = 0;
	self.itemListView = itemListView;
	self.frame:AddComponent(self.itemListView.frame);
	self.itemListView:Show();
	
	
	self.backButton = UIFactory.CreateBackButton(
		function (button, luaevent, args)
				self:Dispose();
		end
	)
	self.backButton.X = 687
	self.backButton.Y = 306
	self.backButton.Layer = 10
	self.frame:AddComponent(self.backButton);
	
	--detail window
	local button = Button();
	self.detailName = button;
	button.Width = 110;
	button.Height = 21;
	button.X = 505
	button.Y = 300
	button.font = GetFont("item_name");
	button.TextColor = 0x000000
	button.Alignment = 0;
	button.Layer = 10
	button:Show();
	button.VerticalAlignment = 1;
	self.frame:AddComponent(button);
	
	local button = Button();
	self.detailPrice = button;
	button.Width = 110;
	button.Height = 20;
	button.X = 620
	button.Y = 299;
	button.font = GetFont("item_desc");
	button.TextColor = 0x000000
	button.Alignment = 0;
	button.VerticalAlignment = 1;
	button.Layer = 10
	button:Show();
	self.frame:AddComponent(button);
	
	local button = Button();
	self.detailDesc = button;
	button.Width = 175;
	button.Height = 50;
	button.X = 505
	button.Y = 309;
	button.font = GetFont("item_desc");
	button.TextColor = 0x000000
	button.Alignment = 0;
	button.VerticalAlignment = 1;
	button.Layer = 10
	button:Show();
	self.frame:AddComponent(button);
		
	
	-------------------
	-- commit window --
	-------------------	
	local commitWindow = SpriteBase();
	self.commitWindow = commitWindow;
	commitWindow.Texture = "resources/ui/store_detail.png"
	commitWindow.Visible = true;
	commitWindow.Layer = 10;
	self.parent:AddComponent(commitWindow)
	commitWindow:Hide();
	
	local pic = Button();
	self.commitIcon = pic;
	pic.Visible = true;
	pic.Width = 60;
	pic.Height = 60;
	pic.X = 274
	pic.Y = 227
	commitWindow:AddComponent(pic);
	
	local button = Button();
	self.commitName = button;
	button.Width = 110;
	button.Height = 21;
	button.X = 355
	button.Y = 227
	button.font = GetFont("item_name");
	button.TextColor = 0x000000
	button.Alignment = 0;
	button.VerticalAlignment = 1;
	commitWindow:AddComponent(button);
	
	local button = Button();
	self.commitPrice = button;
	button.Width = 110;
	button.Height = 20;
	button.X = 470
	button.Y = 227;
	button.font = GetFont("item_desc");
	button.TextColor = 0x000000
	button.Alignment = 0;
	button.VerticalAlignment = 1;
	commitWindow:AddComponent(button);
	
	local button = Button();
	self.commitCount = button;
	button.Width = 60;
	button.Height = 30;
	button.X = 412
	button.Y = 260;
	button.font = GetFont("item_desc");
	button.TextColor = 0x000000
	button.Alignment = 1;
	button.VerticalAlignment = 1;
	commitWindow:AddComponent(button);
	
	local upButton = self:CreateUpButton(
        function()
            if (self.upCountButtonEvent ~= nil) then
                self.downCountButtonEvent();
            end
        end
    );
    upButton.x = 387;
    upButton.y = 265;
    commitWindow:AddComponent(upButton);

    local downButton = self:CreateDownButton(
        function()
            if (self.downCountButtonEvent ~= nil) then
                self.upCountButtonEvent();
            end
        end
    );
    downButton.x = 479;
    downButton.y = 266;
    commitWindow:AddComponent(downButton);
	
	
	self.buyButton = UIFactory.CreateRollOverButton(
		function()
			if (self.buyingEvent ~= nil) then
				self.buyingEvent();
			end
		end,
		function ()
			self.commitWindowRollover:Show();
		end,
		function ()
			self.commitWindowRollover:Hide();
		end);
	self.buyButton.X =  455
	self.buyButton.Y = 323
	self.buyButton.Width = 51
	self.buyButton.Height = 30
	self.buyButton.Layer = 5
	commitWindow:AddComponent(self.buyButton);	
	
	local commitWindowRollover = SpriteBase();
	self.commitWindowRollover = commitWindowRollover;
	commitWindowRollover.Texture = "resources/ui/store_detail_rollover.png"
	commitWindowRollover.Visible = true;
	commitWindowRollover.Layer = 4;
	commitWindow:AddComponent(commitWindowRollover)
	commitWindowRollover:Hide();
	
	
	self.backButton = UIFactory.CreateBackButton(
		function (button, luaevent, args)
			self:CloseCommitWindow();
		end
	)
	self.backButton.X = 537
	self.backButton.Y = 235
	self.backButton.Layer = 10
	commitWindow:AddComponent(self.backButton);
	
	
	
	--local countLabel = Label();
	--self.countLabel = countLabel;
	--countLabel.text = "";
	--countLabel.font = GetFont(shop_font_default);
	--countLabel.width = 30;
	--countLabel.height = 30;
	--countLabel.x = 50;
	--countLabel.y = 100;
	--countLabel.TextColor = 0xFFFFFF;
	--commitWindow:AddComponent(countLabel);
	--
	--

		
		
	--local background = ImageWindow()
	--self.background = background;
	--background.name = "backround"
	--background.relative = true;
	--background.width = 465;
	--background.height = 270;
	--background.x = 50;
	--background.y = 160;
    --background.WindowTexture = "resources/window.png"
    --background.RectSize = 40
    --background.BackgroundColor = 0xFFFFFF
	--background.alpha = 255
	--background.layer = 6;
	--self.frame:AddComponent(background);
		--
	--local upButton = self:CreateUpButton(
        --function()
            --if (self.upButtonEvent ~= nil) then
                --self.upButtonEvent();
            --end
        --end
    --);
    --upButton.x = background.width - 30 + background.x;
    --upButton.y = 10 + background.y;
    --self.frame:AddComponent(upButton);
--
    --local downButton = self:CreateDownButton(
        --function()
            --if (self.downButtonEvent ~= nil) then
                --self.downButtonEvent();
            --end
        --end
    --);
    --downButton.x = background.width - 30 + background.x;
    --downButton.y = background.height - 20 + background.y;
    --self.frame:AddComponent(downButton);
	--
	--local itemListView = Flowview:New("itemListView")
	--itemListView.frame.relative = true;
	--itemListView.frame.width = background.width;
	--itemListView.frame.height = background.height - 50;
	--itemListView.frame.x = 0;
	--itemListView.frame.y = 0;
	--itemListView.frame.layer = 4;
	--itemListView.spacing = 5;
	--itemListView.padding = 10;
	--itemListView.frame.visible = true;
	--itemListView.frame.enabled = true;
	--self.itemListView = itemListView;
	--background:AddComponent(itemListView.frame);
	--
		--
	--local detailviewFrame = ImageWindow()
	--detailviewFrame.name = "detailviewFrame"
	--detailviewFrame.relative = true;
	--detailviewFrame.width = 215;
	--detailviewFrame.height = 230;
	--detailviewFrame.leftMargin = 20;
	--detailviewFrame.margin = 90;
	--detailviewFrame.font = GetFont(shop_font_small);
    --detailviewFrame.linespacing = 10
	--detailviewFrame.x = 525;
	--detailviewFrame.y = 160;
    --detailviewFrame.WindowTexture = "resources/window.png"
    --detailviewFrame.RectSize = 40
    --detailviewFrame.backgroundColor = 0xFFFFFF
	--detailviewFrame.alpha = 255
	--detailviewFrame.layer = 6;
	--self.detailviewFrame = detailviewFrame;
	--self.frame:AddComponent(detailviewFrame);
	--
	--
	--local pic = Button();
	--pic.Name = "picture";
	--pic.Visible = true;
	--pic.Width = 48;
	--pic.Height = 48;
	--pic.X = 20;
	--pic.Y = 10;
	--pic.State = {}
	--self.selectedIcon = pic;
	--self.detailviewFrame:AddComponent(pic);
	--
	--local button = Button();
	--button.Name = "text"
	--button.Width = 68;
	--button.Height = 21;
	--button.X = 10;
	--button.Y = 10 + pic.Height;
	--button.font = GetFont(shop_font_menu);
	--button.TextColor = 0xFFFFFF
	--button.Text = text;
	--button.Alignment = 1;
	--button.VerticalAlignment = 1;
	--self.selectedIconText = button;
	--self.detailviewFrame:AddComponent(button);
	--
	--self.closeButton = self:CreateButton("closeButton", common_close, 
										 --detailviewFrame.x + detailviewFrame.width - 210, background.y + background.height - 40, 6)
	--self.closeButton.relative = true;
	--self.closeButton.MouseUp = 
		--function (button, luaevent, args)
			--if (button.State["mouseDown"]) then
				--button.Pushed = false
				--Trace("button click!")
				--self:Dispose();
			--end
		--end
	--self.frame:AddComponent(self.closeButton);
end

function ShopView:CreateUpButton(event)
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

function ShopView:CreateDownButton(event)
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


function ShopView:CreateButton(name, text, x, y, layer)
	local button = Button()
	button.Relative = true;
	button.Name = name
	button.Texture = "resources/button/button.png"	
	button.Layer = layer;
	button.X = x;
	button.Y = y;
	button.Width = 100;
	button.Height = 40;
	button.Text = text;
	button.Font =  GetFont(shop_font_menu)
	button.TextColor = 0xEEEEEE
	button.State = {}
	button.MouseDown = 
		function (button, luaevent, args)
			button.State["mouseDown"] = true
			button.Pushed = true
		end
	return button;
end

function ShopView:SetBuyingEvent(event)
	self.buyingEvent = event;
end

function ShopView:SetCommitEvent(event)
	self.commitEvent = event;
end

function ShopView:SetPortraitTexture(texture)
	self.dialogueWin:SetPortraitTexture(texture);
end

function ShopView:ClearDialogueText()
	self.dialogueWin:ClearDialogueText();
end

function ShopView:SetDialogueText(text)
	self.dialogueWin:SetDialogueText(text);
end

function ShopView:SetDialogueName(name)
	self.dialogueWin:SetDialogueName(name);
end

function ShopView:ShowDialogue(show)
	self.dialogueWin.frame.Visible = show;
	self.dialogueWin.frame.Enabled = show;
end

function ShopView:ClearItems()
	self.itemListView:Clear();
end

--function ShopView:AddItem(id, text, price, icon)
function ShopView:AddItem(buttonName, buttonText, icon, price, count, effect)
	self.itemListView:Add(UIFactory.CreateItemButton(buttonName, buttonText, icon, price, count, effect, self.commitEvent, nil,  self.selectedEvent));
end

function ShopView:SetSelectedEvent(event)
	self.selectedEvent = event;	
end

function ShopView:SelectItem(itemId, itemName, description, icon, price)
	self.detailName.text = itemName;
	self.detailPrice.text = price .. "G"
	self.detailDesc.text = description;
end

function ShopView:SetUpButtonEvent(event)
    self.upButtonEvent = event;
end

function ShopView:SetDownButtonEvent(event)
    self.downButtonEvent = event;
end

function ShopView:SetCountUpButtonEvent(event)
    self.upCountButtonEvent = event;
end

function ShopView:SetCountDownButtonEvent(event)
    self.downCountButtonEvent = event;
end

function ShopView:OpenCommitWindow(icon, itemName, count, price)
	self.commitIcon.texture = icon;
	self.commitName.text = itemName;
	self.commitPrice.text = price .. "G"
	self.commitCount.text = count;
	self.commitWindow:Show();
end

function ShopView:CloseCommitWindow()
	self.commitWindow:Hide();
end

function ShopView:PrintPageNumbers(numPages, currentPage)
	self.pageButton.Text = (currentPage + 1) .. "/" .. numPages;
end