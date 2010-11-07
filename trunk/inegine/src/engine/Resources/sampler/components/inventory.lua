-- InventoryView UI component implemented in lua
require "Resources\\sampler\\components\\tabview"
require "Resources\\sampler\\components\\flowview"

InventoryView = {}


function InventoryView:New (name, font, parent)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.parent = parent;
	o.name = name
	o.font = font;
	
	o:Init();
	
	return o
end

function InventoryView:Init()
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local font = self.font; 
	local name = self.name;
	
	self.frame = TextWindow()
	self.frame.Name = name
	self.frame.LineSpacing = 20
	
	self.frame.x = 10;
	self.frame.y = 135;
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
	
	
	local background = TextWindow()
	background.name = "backround"
	background.relative = true;
	background.width = self.frame.width - 10;
	background.height = self.frame.height - 50 - 50;
	background.x = 5;
	background.y = 50;
	background.alpha = 155
	background.layer = 6;
	self.frame:AddComponent(background);
	
	
	local tabView = Tabview:New("tabView", GetFont("default"));
	tabView.frame.relative = true
	tabView.frame.X = 0;
	tabView.frame.Y = 0;
	tabView.frame.Width = self.frame.Width;
	tabView.frame.Height = self.frame.Height - 50;
	tabView.frame.layer = 10;
	self.frame:AddComponent(tabView.frame);
	tabView:Show();
		
	local dressView = Flowview:New("dressview")
	dressView.frame.relative = true;
	dressView.frame.width = self.frame.width - 10;
	dressView.frame.height = self.frame.height - 50 - 50;
	dressView.frame.x = 5;
	dressView.frame.y = 50;
	dressView.frame.layer = 10;
	dressView.spacing = 5;
	dressView.padding = 10;
	dressView.frame.visible = true;
	dressView.frame.enabled = true;
	self.dressView = dressView;
	tabView:AddTab("Dress", dressView.frame);
	
	local itemView = Flowview:New("itemview")
	itemView.frame.relative = true;
	itemView.frame.width = self.frame.width - 10;
	itemView.frame.height = self.frame.height - 50 - 50;
	itemView.frame.x = 5;
	itemView.frame.y = 50;
	itemView.frame.alpha = 155
	itemView.frame.layer = 4;
	itemView.spacing = 5;
	itemView.padding = 10;
	itemView.frame.visible = false;
	itemView.frame.enabled = false;
	self.itemView = itemView;
	tabView:AddTab("Item", itemView.frame);
	
	local furnitureView = Flowview:New("furnitureview");
	furnitureView.frame.relative = true;
	furnitureView.frame.width = self.frame.width - 10;
	furnitureView.frame.height = self.frame.height - 50 - 50;
	furnitureView.frame.x = 5;
	furnitureView.frame.y = 50;
	furnitureView.frame.alpha = 155
	furnitureView.frame.layer = 4;	
	furnitureView.spacing = 5;
	furnitureView.padding = 10;
	furnitureView.frame.visible = false;
	furnitureView.frame.enabled = false;
	self.furnitureView = furnitureView;
	tabView:AddTab("Furniture", furnitureView.frame);
	
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
end

function InventoryView:AddTestDressItems()
	local dressView = self.dressView;
	local testButton = Button()
	
	Trace("adding test items to : " .. dressView.frame.Name);
	
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

function InventoryView:SetClosingEvent(event)
	self.closebutton.MouseUp = event;
end

function InventoryView:Dispose()
	self.parent:RemoveComponent(self.name)
end

function InventoryView:Show()
	Trace("showing InventoryView!")
	self.frame.Visible = true
	self.frame.Enabled = true
end


function InventoryView:Hide()
	self.frame.Visible = false
	self.frame.Enabled = false
end
