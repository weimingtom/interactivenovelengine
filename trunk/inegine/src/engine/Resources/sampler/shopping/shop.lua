LoadScript "Resources\\sampler\\components\\luaview.lua"

ShopView = LuaView:New();

function ShopView:Init()
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local font = GetFont("default")
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
		
	local background = ImageWindow()
	background.name = "backround"
	background.relative = true;
	background.width = 465;
	background.height = 270;
	background.x = 50;
	background.y = 160;--dialogueWin.frame.y - background.height - 10;
    background.WindowTexture = "Resources/sampler/resources/window.png"
    background.RectSize = 40
    background.BackgroundColor = 0xFFFFFF
	background.alpha = 255
	background.layer = 6;
	self.frame:AddComponent(background);
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
	detailviewFrame.font = GetFont("smalldefault");
    detailviewFrame.linespacing = 10
	detailviewFrame.x = 525;
	detailviewFrame.y = 160;
    detailviewFrame.WindowTexture = "Resources/sampler/resources/window.png"
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
	button.font = GetFont("verysmall");
	button.TextColor = 0xFFFFFF
	button.Text = text;
	button.Alignment = 1;
	button.VerticalAlignment = 1;
	self.selectedIconText = button;
	self.detailviewFrame:AddComponent(button);
	

	
	
	
	
	
	
	self.buyButton = self:CreateButton("buyButton", "Buy", 
										 detailviewFrame.x + detailviewFrame.width - 105, background.y + background.height - 40, 6)
	self.buyButton.relative = true;
	self.buyButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false
				Trace("button click!")
				if (self.buyingEvent ~= nil) then 
					self:buyingEvent();
				end
			end
		end
	self.frame:AddComponent(self.buyButton);

	
	self.closeButton = self:CreateButton("closeButton", "Close", 
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
	newButton.Texture = "Resources/sampler/resources/up.png"	
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
	newButton.Texture = "Resources/sampler/resources/down.png"	
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
	button.Texture = "Resources/sampler/resources/button/button.png"	
	button.Layer = layer;
	button.X = x;
	button.Y = y;
	button.Width = 100;
	button.Height = 40;
	button.Text = text;
	button.Font =  GetFont("menu")
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
	frame:AddComponent(pic);
	
	local button = Button();
	button.Name = "text"
	button.Width = 90;
	button.Height = 15;
	button.X = 0;
	button.Y = pic.Height;
	button.font = GetFont("verysmall");
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
	priceButton.font = GetFont("verysmall");
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
	newButton.Texture = "Resources/sampler/resources/button.png"	
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
	newButton.Font = GetFont("default");
	newButton.TextColor = 0xEEEEEE
	return newButton;
end

function ShopView:SelectItem(itemId, itemName, description, icon, price)
	self.selectedIcon.texture = icon;
	self.selectedIconText.text = price .. "G"
	self.detailviewFrame.text = description;
end

function ShopView:SetUpButtonEvent(event)
    self.upButtonEvent = event;
end

function ShopView:SetDownButtonEvent(event)
    self.downButtonEvent = event;
end

function ShopView:SetBuyMode(buy)
	self.buyButton.enabled = buy;
end