require "Resources\\sampler\\components\\luaview"

ShopListView = LuaView:New();

function ShopListView:Init()
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local font = GetFont("default")
	local name = self.name;
	
	self.frame = View()
	self.frame.Name = name
	
	self.frame.Width = 450
	self.frame.Height = 240
	self.frame.x = (GetWidth() - self.frame.Width) / 2;
	self.frame.y = (GetHeight() - self.frame.Height) / 2;
	self.frame.alpha = 155
	self.frame.layer = 3
	
	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)	
		end
	
	parent:AddComponent(self.frame)
	
	local villageimage = SpriteBase();
	villageimage.Relative = true;
	villageimage.Name = "villageiamge";
	villageimage.Texture = "Resources/sampler/resources/images/village.png";
	villageimage.Visible = true;
	villageimage.X = 0;
	villageimage.y = 0;
	villageimage.Layer = 2;
	self.villageimage = villageimage;
	self.frame:AddComponent(villageimage);
	
	self.shop1Button = self:CreateButton("shop1button", "옷집", 
										 self.frame.width - 125, 5+45*0, 4)
	Trace(self.shop1Button.Name);
	self.frame:AddComponent(self.shop1Button);
	
	
	self.shop2Button = self:CreateButton("shop2button", "무기점", 
										 self.frame.width - 125, 5+45*1, 4)
	self.frame:AddComponent(self.shop2Button);

	
	self.shop3Button = self:CreateButton("shop3button", "잡화점", 
										 self.frame.width - 125, 5+45*2, 4)
	self.frame:AddComponent(self.shop3Button);

	self.shop4Button = self:CreateButton("shop4button", "가구점", 
										 self.frame.width - 125, 5+45*3, 4)
	self.frame:AddComponent(self.shop4Button);


	
	self.closeButton = self:CreateButton("closeButton", "Close", 
										 self.frame.width - 125, 5+45*4, 4)
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
	self.frame:AddComponent(self.closeButton);
	
	
end

function ShopListView:SetShopSelectedEvent(event)
	self.shopSelectedEvent = event;
end

function ShopListView:CreateButton(buttonName, text, x, y, layer)
	local button = Button()
	button.Relative = true;
	button.Name = buttonName
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
	
	button.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false
				Trace("button click!")
				
				if (self.shopSelectedEvent ~= nil) then
					self.shopSelectedEvent(button, luaevent, args);
				end
				
			end
		end

	return button;	
end