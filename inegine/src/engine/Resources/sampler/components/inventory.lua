-- inventory UI component implemented in lua
require "Resources\\sampler\\components\\tabview"
require "Resources\\sampler\\components\\flowview"

Inventory = {}

function Inventory:New (name, font, parent)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	
	self.parent = parent;
	self.name = name
	self.font = font;
	
	local gamestate = CurrentState();
	
	self.frame = TextWindow()
	self.frame.Name = name
	self.frame.LineSpacing = 20
	self.frame.Width = 400
	self.frame.Height = 430
	self.frame.alpha = 155
	self.frame.layer = 3
	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.Font = font
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)	
		end
	
	parent:AddComponent(self.frame)
	
	
	local tabView = Tabview:New("tabView", GetFont("default"));
	tabView.frame.relative = true
	tabView.frame.X = 0;
	tabView.frame.Y = 0;
	tabView.frame.Width = self.frame.Width;
	tabView.frame.Height = self.frame.Height - 50;
	self.frame:AddComponent(tabView.frame);
	tabView:Show();
	
	local dressViewFrame = TextWindow()
	dressViewFrame.name = "dressViewFrame"
	dressViewFrame.relative = true;
	dressViewFrame.width = self.frame.width - 10;
	dressViewFrame.height = self.frame.height - 50 - 50;
	dressViewFrame.x = 5;
	dressViewFrame.y = 50;
	dressViewFrame.alpha = 155
	dressViewFrame.layer = 4;
	
	dressViewFrame.font = font

	dressViewFrame.visible = true;
	dressViewFrame.enabled = true;
	dressViewFrame.text = "TEST"
	
	local dressView = Flowview:New() --TextWindow()
	dressView.frame.name = "dressview"
	dressView.frame.relative = true;
	dressView.frame.width = self.frame.width - 10;
	dressView.frame.height = self.frame.height - 50 - 50;
	dressView.frame.x = 0;
	dressView.frame.y = 0;
	--dressView.frame.x = 5;
	--dressView.frame.y = 50;
	dressView.frame.layer = 10;
	
	dressView.spacing = 5;
	dressView.padding = 10;
	dressView.frame.visible = true;
	dressView.frame.enabled = true;
	self.dressView = dressView;
	dressViewFrame:AddComponent(dressView.frame);
	Trace("weasd!!! " .. dressViewFrame:GetComponent("dressview").name);
	
	tabView:AddTab("Dress", dressViewFrame);	
	
	local itemView = TextWindow()
	itemView.name = "itemView"
	itemView.relative = true;
	itemView.width = self.frame.width - 10;
	itemView.height = self.frame.height - 50 - 50;
	itemView.x = 5;
	itemView.y = 50;
	itemView.alpha = 155
	itemView.layer = 4;
	
	itemView.Text = "ITEM VIEW!"
	itemView.font = font

	itemView.visible = false;
	itemView.enabled = false;
	
	self.itemView = itemView;
	tabView:AddTab("Item", itemView);
	
	local furnitureView = TextWindow()
	furnitureView.name = "furnitureView"
	furnitureView.relative = true;
	furnitureView.width = self.frame.width - 10;
	furnitureView.height = self.frame.height - 50 - 50;
	furnitureView.x = 5;
	furnitureView.y = 50;
	furnitureView.alpha = 155
	furnitureView.layer = 4;
	
	furnitureView.Text = "FURNITURE VIEW!"
	furnitureView.font = font

	furnitureView.visible = false;
	furnitureView.enabled = false;
	
	self.furnitureView = furnitureView;
	tabView:AddTab("Furniture", furnitureView);
	
	local closeButton = Button()
	closeButton.Relative = true;
	closeButton.Name = "closeButton"
	closeButton.Texture = "Resources/sampler/resources/button.png"	
	closeButton.Layer = 4;
	closeButton.X = self.frame.width - 125;
	closeButton.Y = self.frame.height - 45;
	closeButton.Width = 120;
	closeButton.Height = 40;
	closeButton.State = {}
	closeButton.MouseDown = 
		function (closeButton, luaevent, args)
			closeButton.State["mouseDown"] = true
			closeButton.Pushed = true
		end
	closeButton.MouseUp = 
		function (closeButton, luaevent, args)
			if (closeButton.State["mouseDown"]) then
				closeButton.Pushed = false
				Trace("closeButton click!")
			end
		end
	closeButton.Text = "Close";
	closeButton.Font = font
	closeButton.TextColor = 0xEEEEEE
	
	self.closebutton = closeButton;
	self.frame:AddComponent(closeButton);
	self:AddTestDressItems();

	return o
end

function Inventory:AddTestDressItems()
	local dressView = self.dressView;
	local testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("dress 1")
				-- todo : connect to character controller insetead of main view
				main:SetTachieBody("Resources/sampler/images/1.png");
				main:SetTachiePosition(self.frame.X + self.frame.Width + 10);
			end
		end
	testButton.Text = "Dress 1";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	dressView:Add(testButton);
	
	
	testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton2"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("dress 2")
				-- todo : connect to character controller insetead of main view
				main:SetTachieBody("Resources/sampler/images/2.png");
				main:SetTachiePosition(self.frame.X + self.frame.Width + 10);
			end
		end
	testButton.Text = "Dress 2";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	dressView:Add(testButton);
	
	
	
	testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton3"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("Dress 3!");
			
				-- todo : connect to character controller insetead of main view
				main:SetTachieBody("Resources/sampler/images/3.png");
				main:SetTachiePosition(self.frame.X + self.frame.Width + 10);
			end
		end
	testButton.Text = "Dress 3";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	dressView:Add(testButton);
	
		
	testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton4"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("testButton click!")
			end
		end
	testButton.Text = "Dummy";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	dressView:Add(testButton);
	
		testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton5"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("testButton click!")
			end
		end
	testButton.Text = "Dummy";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	dressView:Add(testButton);
	
		testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton6"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("testButton click!")
			end
		end
	testButton.Text = "Dummy";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	dressView:Add(testButton);
	
	testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton7"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("testButton click!")
			end
		end
	testButton.Text = "Dummy";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	
	dressView:Add(testButton);
	
	
	testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton8"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("testButton click!")
			end
		end
	testButton.Text = "Dummy";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	
	dressView:Add(testButton);
	
end

function Inventory:SetClosingEvent(event)
	self.closebutton.MouseUp = event;
end

function Inventory:Dispose()
	self.parent:RemoveComponent(self.name)
end

function Inventory:Show()
	Trace("showing inventory!")
	self.frame.Visible = true
	self.frame.Enabled = true
end


function Inventory:Hide()
	self.frame.Visible = false
	self.frame.Enabled = false
end
