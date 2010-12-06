require "Resources\\sampler\\components\\luaview"

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
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)	
		end
	
	parent:AddComponent(self.frame)
	
	
	local viewframe = View();
	viewframe.Name = "viewframe"
	viewframe.Width = 450;
	viewframe.Height = 240;
	viewframe.Relative = true;
	viewframe.x = (self.frame.Width - viewframe.Width) / 2;
	viewframe.y = (self.frame.Height - viewframe.Height) / 2;
	viewframe.layer = 3;
	viewframe.visible = true;
	viewframe.enabled = true;
	self.viewframe = viewframe;
	self.frame:AddComponent(viewframe);
	
	
	local villageimage = SpriteBase();
	villageimage.Relative = true;
	villageimage.Name = "villageiamge";
	villageimage.Texture = "Resources/sampler/resources/images/village.png";
	villageimage.Visible = true;
	villageimage.X = 0;
	villageimage.y = 0;
	villageimage.Layer = 2;
	self.villageimage = villageimage;
	self.viewframe:AddComponent(villageimage);
	
	self.shop1Button = self:CreateButton("shop1button", "옷집", 
										 self.viewframe.width - 125, 5+45*0, 4)
	self.viewframe:AddComponent(self.shop1Button);
	
	
	self.shop2Button = self:CreateButton("shop2button", "무기점", 
										 self.viewframe.width - 125, 5+45*1, 4)
	self.viewframe:AddComponent(self.shop2Button);

	
	self.shop3Button = self:CreateButton("shop3button", "잡화점", 
										 self.viewframe.width - 125, 5+45*2, 4)
	self.viewframe:AddComponent(self.shop3Button);

	self.shop4Button = self:CreateButton("shop4button", "가구점", 
										 self.viewframe.width - 125, 5+45*3, 4)
	self.viewframe:AddComponent(self.shop4Button);


	
	self.closeButton = self:CreateButton("closeButton", "Close", 
										 self.viewframe.width - 125, 5+45*4, 4)
	self.closeButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false
				Trace("button click!")
				self:Dispose();
			end
		end
	self.viewframe:AddComponent(self.closeButton);
	
	local dialogueWin = DialogueWindow:New("dialogueWin", self.frame);
	self.dialogueWin = dialogueWin;
	dialogueWin:Init();
	dialogueWin.frame.relative = true;
	dialogueWin.frame.x = 0;
	dialogueWin.frame.y = self.frame.height - dialogueWin.frame.height;
	dialogueWin:Hide();
end

function ShopListView:SetShopSelectedEvent(event)
	self.shopSelectedEvent = event;
end

function ShopListView:CreateButtonInternal(buttonName, buttonText, event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonName;
	newButton.Texture = "Resources/sampler/resources/button/button.png"	
	newButton.Layer = 3
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 100;
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
                if (event~=nil) then 
					event(button, luaevent, args);
				end
			end
		end
	newButton.Text = buttonText;
	newButton.Font = GetFont("menu"); --menuFont
	newButton.TextColor = 0xEEEEEE
	return newButton;
end



function ShopListView:CreateButton(buttonName, text, x, y, layer)
	local button = self:CreateButtonInternal(buttonName, text, 		
        function (button, luaevent, args)
			if (self.shopSelectedEvent ~= nil) then
				self.shopSelectedEvent(button, luaevent, args);
			end
		end)
	button.X = x;
	button.Y = y;
	return button;	
end

function ShopListView:SetGreeting(portrait, name, text)	
	self.dialogueWin:Show();
	self.dialogueWin:SetPortraitTexture(portrait);
	self.dialogueWin:SetDialogueName(name);
	self.dialogueWin:ClearDialogueText();
	self.dialogueWin:SetDialogueText(text);	
end