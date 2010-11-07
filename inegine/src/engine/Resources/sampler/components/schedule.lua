-- schedule UI component implemented in lua
require "Resources\\sampler\\components\\tabview"
require "Resources\\sampler\\components\\flowview"

ScheduleView = {}

function ScheduleView:New (name, font, parent)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.parent = parent;
	o.name = name
	o.font = font;
	
	o:Init();
	
	return o
end

function ScheduleView:Init()
	local gamestate = CurrentState();
	local parent = self.parent;
	local font = self.font; 
	local name = self.name;
	
	self.frame = View()
	self.frame.Name = name
	
	self.frame.X = 0;
	self.frame.Y = 0;
	self.frame.Width = GetWidth();
	self.frame.Height = GetHeight();
	self.frame.alpha = 155
	self.frame.layer = 3
	
	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)	
		end
	
	parent:AddComponent(self.frame)
	
	self.tabviewframe = TextWindow()
	self.tabviewframe.Name = "tabviewframe"
	
	self.tabviewframe.X = 10;
	self.tabviewframe.Y = 300;
	self.tabviewframe.Width = 500
	self.tabviewframe.Height = 290
	self.tabviewframe.alpha = 155
	self.tabviewframe.layer = 3
	
	self.frame:AddComponent(self.tabviewframe)
	
	
	local tabView = Tabview:New("tabView", GetFont("default"));
	tabView.frame.relative = true
	tabView.frame.X = 0;
	tabView.frame.Y = 0;
	tabView.frame.Width = self.tabviewframe.Width;
	tabView.frame.Height = self.tabviewframe.Height - 50;
	self.tabviewframe:AddComponent(tabView.frame);
	tabView:Show();
	
	local dressViewFrame = TextWindow()
	dressViewFrame.name = "dressViewFrame"
	dressViewFrame.relative = true;
	dressViewFrame.width = tabView.frame.width - 10;
	dressViewFrame.height = tabView.frame.height - 50 - 50;
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
	dressView.frame.width = tabView.frame.width - 10;
	dressView.frame.height = tabView.frame.height - 50 - 50;
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
	
	tabView:AddTab("Dress", dressViewFrame);	
	
	local itemView = TextWindow()
	itemView.name = "itemView"
	itemView.relative = true;
	itemView.width = tabView.frame.width - 10;
	itemView.height = tabView.frame.height - 50 - 50;
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
	furnitureView.width = tabView.frame.width - 10;
	furnitureView.height = tabView.frame.height - 50 - 50;
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
end

function ScheduleView:SetClosingEvent(event)
	self.closebutton.MouseUp = event;
end

function ScheduleView:Dispose()
	self.parent:RemoveComponent(self.name)
end

function ScheduleView:Show()
	Trace("showing schedule!")
	self.frame.Visible = true
	self.frame.Enabled = true
end


function ScheduleView:Hide()
	self.frame.Visible = false
	self.frame.Enabled = false
end
