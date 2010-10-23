-- selection UI component implemented in lua

Inventory = {}

function Inventory:New (name, font, parent)
	local o = {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	
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
	
	
	local tabView = Tabview:New("tabView", GetFont("default"), self.frame);
	tabView.frame.relative = true
	tabView.frame.X = 0;
	tabView.frame.Y = 0;
	tabView.frame.Width = self.frame.Width;
	tabView.frame.Height = self.frame.Height - 50;
	tabView:Show();
	
	local dressView = TextWindow()
	dressView.name = "dressview"
	dressView.relative = true;
	dressView.width = self.frame.width - 10;
	dressView.height = self.frame.height - 50 - 50;
	dressView.x = 5;
	dressView.y = 50;
	dressView.alpha = 155
	dressView.layer = 4;
	
	dressView.Text = "DRESS VIEW!"
	dressView.font = font
	
	self.dressView = dressView;
	tabView:AddTab("Dress", dressView);
	
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
	
	return o
end

function Inventory:SetClosingEvent(event)
	self.closebutton.MouseUp = event;
end

function Inventory:Dispose()
	RemoveComponent(self.name)
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
