require "Resources\\sampler\\components\\luaview"

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
	self.frame.alpha = 155
	self.frame.layer = 3
	
	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)	
		end
	
	parent:AddComponent(self.frame)
	
	local dialogueWin = ImageWindow()
	dialogueWin.Name = "dialogueWindow"
	dialogueWin.Alpha = 155
	dialogueWin.Width = 600
	dialogueWin.Height = 120
	dialogueWin.x = self.frame.Width - dialogueWin.Width - 20;
	dialogueWin.y = self.frame.Height - dialogueWin.Height - 20;
	dialogueWin.Layer = 5
	dialogueWin.LineSpacing = 20
	dialogueWin.MouseClick = 
        function(window, luaevent, args)
			Trace(window.name .. " clicked!");	
            window:AdvanceText();
        end
	dialogueWin.Visible = true
	dialogueWin.WindowTexture = "Resources/sampler/resources/win.png"
	dialogueWin.Font = GetFont("dialogue")
	
	dialogueWin.Cursor = AnimatedSprite();
	dialogueWin.Cursor.Name = "cursor"
	dialogueWin.Cursor.Texture = "Resources/sampler/resources/cursor.png"
	dialogueWin.Cursor.Width = 32;
	dialogueWin.Cursor.Height = 48;
	dialogueWin.Cursor.Rows = 4;
	dialogueWin.Cursor.Cols = 4;
	dialogueWin.Cursor.Layer = 10;
	dialogueWin.Cursor.Visible = true
	dialogueWin.PrintOver = 
		function (window, luaevent, args)
                if (self.dialogueOverEvent~=nil) then 
					self.dialogueOverEvent(window, luaevent, args);
				end
		end
	dialogueWin.narrationSpeed = 30;
	self.frame:AddComponent(dialogueWin);
	self.dialogueWin = dialogueWin;
	
	local portrait = SpriteBase();
	portrait.Name = "portrait";
	portrait.Visible = true;
	portrait.Layer = 2;
	self.portrait = portrait;
	self.frame:AddComponent(portrait);	

	self:ShowDialogue(false);
		
	local background = TextWindow()
	background.name = "backround"
	background.relative = true;
	background.width = 400;
	background.height = 320;
	background.x = 5;
	background.y = dialogueWin.y - background.height - 10;
	background.alpha = 155
	background.layer = 6;
	self.frame:AddComponent(background);
	
	
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
	
	
	local detailviewframe = TextWindow()
	self.detailviewframe = detailviewframe;
	detailviewframe.Name = "detailviewframe"
	detailviewframe.font = GetFont("default");
	detailviewframe.Width = 380
	detailviewframe.Height = 150
	detailviewframe.X = 415;
	detailviewframe.Y = dialogueWin.y - detailviewframe.height - 10;
	detailviewframe.alpha = 155
	detailviewframe.layer = 3
	
	self.frame:AddComponent(detailviewframe)
	
	self.buyButton = self:CreateButton("buyButton", "Buy", 
										 detailviewframe.width - 125, detailviewframe.height - 45, 6)
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
	detailviewframe:AddComponent(self.buyButton);

	
	self.closeButton = self:CreateButton("closeButton", "Close", 
										 background.width - 125, background.height - 45, 6)
	self.closeButton.relative = true;
	self.closeButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false
				Trace("button click!")
				if (self.closingEvent ~= nil) then 
					self:closingEvent();
				end
			end
		end
	background:AddComponent(self.closeButton);
end

function ShopView:CreateButton(name, text, x, y, layer)
	local button = Button()
	button.Relative = true;
	button.Name = name
	button.Texture = "Resources/sampler/resources/button.png"	
	button.Layer = layer;
	button.X = x;
	button.Y = y;
	button.Width = 120;
	button.Height = 40;
	button.Text = text;
	button.Font =  GetFont("default")
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
	self.portrait.Texture = texture;
	self.portrait.X = (self.dialogueWin.x - self.portrait.Width) / 2;
	self.portrait.y = self.frame.Height - self.dialogueWin.Height - 20 + 
					  ((self.dialogueWin.Height - self.portrait.Height) / 2);
end

function ShopView:ClearDialogueText()
	self.dialogueWin:Clear()
end

function ShopView:SetDialogueText(text)
	self.dialogueWin:Print(text)
end


function ShopView:ShowDialogue(show)
	self.dialogueWin.Visible = show;
	self.dialogueWin.Enabled = show;
	self.portrait.Visible = show;
	self.portrait.Enabled = show;
end


function ShopView:AddItem(buttonName, buttonText)
	self.itemListView:Add(self:CreateItemButton(buttonName, buttonText));
end

function ShopView:SetSelectedEvent(event)
	self.selectedEvent = event;
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


function ShopView:SetDetailText(text)
    self.detailviewframe.text = text;
end
