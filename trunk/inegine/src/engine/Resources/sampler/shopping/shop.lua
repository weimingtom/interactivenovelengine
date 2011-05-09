LoadScript "components\\luaview.lua"
LoadScript "components\\dialoguewindow.lua"
LoadScript "components\\flowview.lua"

ShopView = LuaView:New();

shop_font_default = "default"
shop_font_small = "small"
shop_font_menu = "menu"

function ShopView:Init()
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local font = GetFont(shop_font_default)
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
		
	local dialogueWin = DialogueWindow:New("dialogueWin", self.frame);
	self.dialogueWin = dialogueWin;
	dialogueWin:Init();
	dialogueWin.frame.relative = true;
	dialogueWin.frame.x = 0;
	dialogueWin.frame.y = self.frame.height - dialogueWin.frame.height;
	dialogueWin:Hide();
	
	-------------------
	-- commit window --
	-------------------
	local commitWindow = ImageWindow()
	self.commitWindow = commitWindow;
	--commitWindow.Name = "commitWindow"
	commitWindow.relative = true;
	commitWindow.width = 300;
	commitWindow.height = 200;
	commitWindow.x = (GetWidth() - commitWindow.width) / 3;
	commitWindow.y = (GetHeight() - commitWindow.height) / 2;
    commitWindow.WindowTexture = "resources/window.png"
    commitWindow.RectSize = 40
	commitWindow.alpha = 255
	commitWindow.layer = 9;
	commitWindow:Hide();
	self.frame:AddComponent(commitWindow);
	
	local label = Label();
	label.text = shop_view_commit_text;
	label.font = GetFont(shop_font_default);
	label.width = 100;
	label.height = 50;
	label.x = (commitWindow.width - label.width) / 2;
	label.y = 0;
	label.TextColor = 0xFFFFFF;
	commitWindow:AddComponent(label);
	
	local itemNameLabel = Label();
	self.itemNameLabel = itemNameLabel;
	itemNameLabel.text = "";
	itemNameLabel.font = GetFont(shop_font_default);
	itemNameLabel.width = 200;
	itemNameLabel.height = 50;
	itemNameLabel.x = (commitWindow.width - itemNameLabel.width) / 2;
	itemNameLabel.y = 50;
	itemNameLabel.TextColor = 0xFFFFFF;
	commitWindow:AddComponent(itemNameLabel);
	
	local countLabel = Label();
	self.countLabel = countLabel;
	countLabel.text = "";
	countLabel.font = GetFont(shop_font_default);
	countLabel.width = 30;
	countLabel.height = 30;
	countLabel.x = 50;
	countLabel.y = 100;
	countLabel.TextColor = 0xFFFFFF;
	commitWindow:AddComponent(countLabel);
	
	
	local upButton = self:CreateUpButton(
        function()
            if (self.upCountButtonEvent ~= nil) then
                self.upCountButtonEvent();
            end
        end
    );
    upButton.x = 20;
    upButton.y = 100;
    commitWindow:AddComponent(upButton);

    local downButton = self:CreateDownButton(
        function()
            if (self.downCountButtonEvent ~= nil) then
                self.downCountButtonEvent();
            end
        end
    );
    downButton.x = 20;
    downButton.y = 120;
    commitWindow:AddComponent(downButton);

	local priceLabel = Label();
	self.priceLabel = priceLabel;
	priceLabel.text = "0G";
	priceLabel.font = GetFont(shop_font_default);
	priceLabel.width = 150;
	priceLabel.height = 30;
	priceLabel.x = 120;
	priceLabel.y = 100;
	priceLabel.TextColor = 0xFFFFFF;
	commitWindow:AddComponent(priceLabel);
		
		
	local okButton = self:CreateButton("okButton", shop_view_buy_button, 50, commitWindow.height - 45, 6)
	self.commitokButton = okButton;
	okButton.relative = true;
	okButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false
				self:CloseCommitWindow();
				self:buyingEvent();
			end
		end
	commitWindow:AddComponent(okButton);
		
	local closeButton = self:CreateButton("closeButton", common_cancel, okButton.x + okButton.width + 10,
	 commitWindow.height - 45, 6)
	self.commitCloseButton = closeButton;
	closeButton.relative = true;
	closeButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false
				self:CloseCommitWindow();
			end
		end
	commitWindow:AddComponent(closeButton);
		
		
		
	local background = ImageWindow()
	self.background = background;
	background.name = "backround"
	background.relative = true;
	background.width = 465;
	background.height = 270;
	background.x = 50;
	background.y = 160;
    background.WindowTexture = "resources/window.png"
    background.RectSize = 40
    background.BackgroundColor = 0xFFFFFF
	background.alpha = 255
	background.layer = 6;
	self.frame:AddComponent(background);
		
	local upButton = self:CreateUpButton(
        function()
            if (self.upButtonEvent ~= nil) then
                self.upButtonEvent();
            end
        end
    );
    upButton.x = background.width - 30 + background.x;
    upButton.y = 10 + background.y;
    self.frame:AddComponent(upButton);

    local downButton = self:CreateDownButton(
        function()
            if (self.downButtonEvent ~= nil) then
                self.downButtonEvent();
            end
        end
    );
    downButton.x = background.width - 30 + background.x;
    downButton.y = background.height - 20 + background.y;
    self.frame:AddComponent(downButton);
	
	local itemListView = Flowview:New("itemListView")
	itemListView.frame.relative = true;
	itemListView.frame.width = background.width;
	itemListView.frame.height = background.height - 50;
	itemListView.frame.x = 0;
	itemListView.frame.y = 0;
	itemListView.frame.layer = 4;
	itemListView.spacing = 5;
	itemListView.padding = 10;
	itemListView.frame.visible = true;
	itemListView.frame.enabled = true;
	self.itemListView = itemListView;
	background:AddComponent(itemListView.frame);
	
		
	local detailviewFrame = ImageWindow()
	detailviewFrame.name = "detailviewFrame"
	detailviewFrame.relative = true;
	detailviewFrame.width = 215;
	detailviewFrame.height = 230;
	detailviewFrame.leftMargin = 20;
	detailviewFrame.margin = 90;
	detailviewFrame.font = GetFont(shop_font_small);
    detailviewFrame.linespacing = 10
	detailviewFrame.x = 525;
	detailviewFrame.y = 160;
    detailviewFrame.WindowTexture = "resources/window.png"
    detailviewFrame.RectSize = 40
    detailviewFrame.backgroundColor = 0xFFFFFF
	detailviewFrame.alpha = 255
	detailviewFrame.layer = 6;
	self.detailviewFrame = detailviewFrame;
	self.frame:AddComponent(detailviewFrame);
	
	
	local pic = Button();
	pic.Name = "picture";
	pic.Visible = true;
	pic.Width = 48;
	pic.Height = 48;
	pic.X = 20;
	pic.Y = 10;
	pic.State = {}
	self.selectedIcon = pic;
	self.detailviewFrame:AddComponent(pic);
	
	local button = Button();
	button.Name = "text"
	button.Width = 68;
	button.Height = 21;
	button.X = 10;
	button.Y = 10 + pic.Height;
	button.font = GetFont(shop_font_menu);
	button.TextColor = 0xFFFFFF
	button.Text = text;
	button.Alignment = 1;
	button.VerticalAlignment = 1;
	self.selectedIconText = button;
	self.detailviewFrame:AddComponent(button);
	
	self.closeButton = self:CreateButton("closeButton", common_close, 
										 detailviewFrame.x + detailviewFrame.width - 210, background.y + background.height - 40, 6)
	self.closeButton.relative = true;
	self.closeButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false
				Trace("button click!")
				self:Dispose();
			end
		end
	self.frame:AddComponent(self.closeButton);
end

function ShopView:CreateUpButton(event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = "upButton";
	newButton.Texture = "resources/up.png"	
	newButton.Layer = 15
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 18;
	newButton.Height = 12;
	newButton.State = {}
	newButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
			newButton.Pushed = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
                if (event~=nil) then 
					event(button, luaevent, args);
				end
			end
		end
	newButton.TextColor = 0xEEEEEE
	return newButton;
end

function ShopView:CreateDownButton(event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = "downButotn";
	newButton.Texture = "resources/down.png"	
	newButton.Layer = 15
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 18;
	newButton.Height = 12;
	newButton.State = {}
	newButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
			newButton.Pushed = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
                if (event~=nil) then 
					event(button, luaevent, args);
				end
			end
		end
	newButton.TextColor = 0xEEEEEE
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

function ShopView:AddItem(id, text, price, icon)
	self.itemListView:Add(self:CreateItem(id, text, price, icon));
end

function ShopView:SetSelectedEvent(event)
	self.selectedEvent = event;	
end

function ShopView:CreateItem(id, text, price, icon)
	local frame = View();
	frame.Name = id;
	frame.Relative = true;
	frame.Width = 90;
	frame.Height = 80;
	frame.Enabled = true;
	
	local pic = Button();
	pic.Name = "picture";
	pic.Texture = icon
	pic.Visible = true;
	pic.X = (frame.Width - pic.Width) / 2;
	pic.Width = 48;
	pic.Height = 48;
	pic.State = {}
	pic.MouseDown = 
		function (button, luaevent, args)
			Trace("mouse down!");
			button.State["mouseDown"] = true
			button.Pushed = true;
		end
	pic.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				Trace("mouse up!");
				button.Pushed = false;
				self.selectedEvent(button, luaevent, id);
			end
		end
	pic.MouseDoubleClick =
		function (button, luaevent, args)
			Trace("double click!")
			self.selectedEvent(button, luaevent, id);
			self:commitEvent(button, luaevent, id);
		end

	frame:AddComponent(pic);
	
	local button = Button();
	button.Name = "text"
	button.Width = 90;
	button.Height = 15;
	button.X = 0;
	button.Y = pic.Height;
	button.font = GetFont(shop_font_small);
	button.TextColor = 0xFFFFFF
	button.Text = text;
	button.Alignment = 1;
	button.VerticalAlignment = 1;
	frame:AddComponent(button);
	
	
	local priceButton = Button();
	priceButton.Name = "price"
	priceButton.Width = 90;
	priceButton.Height = 15;
	priceButton.X = 0;
	priceButton.Y = button.Y + button.Height;
	priceButton.font = GetFont(shop_font_small);
	priceButton.TextColor = 0xFFFFFF
	priceButton.Text = price;
	priceButton.Alignment = 1;
	priceButton.VerticalAlignment = 1;
	frame:AddComponent(priceButton);
	return frame;
end

function ShopView:CreateItemButton(buttonName, buttonText)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonName;
	newButton.Texture = "resources/button.png"	
	newButton.Layer = 3
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 120;
	newButton.Height = 40;
	newButton.State = {}
	newButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
			newButton.Pushed = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
                if (self.selectedEvent~=nil) then 
					self.selectedEvent(button, luaevent, args);
				end
			end
		end
	newButton.Text = buttonText;
	newButton.Font = GetFont(shop_font_default);
	newButton.TextColor = 0xEEEEEE
	return newButton;
end

function ShopView:SelectItem(itemId, itemName, description, icon, price)
	self.selectedIcon.texture = icon;
	self.selectedIconText.text = price .. common_priceunit
	self.detailviewFrame.text = description;
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

function ShopView:OpenCommitWindow(itemName, count, price)
	self.priceLabel.text = price .. common_priceunit;
	self.countLabel.text = count;
	self.itemNameLabel.text = itemName;
	self.commitWindow:Show();
end

function ShopView:CloseCommitWindow()
	self.commitWindow:Hide();
end