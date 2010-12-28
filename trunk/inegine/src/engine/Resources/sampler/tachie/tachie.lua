LoadScript "Resources\\sampler\\components\\luaview.lua"

TachieView = LuaView:New();

function TachieView:Init()
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
	
	local descriptionWindow = ImageWindow()
	self.descriptionWindow = descriptionWindow;
	descriptionWindow.name = "descriptionWindow"
	descriptionWindow.relative = true;
	descriptionWindow.width = 240;
	descriptionWindow.height = 320;
    descriptionWindow.WindowTexture = "Resources/sampler/resources/window.png"
    descriptionWindow.RectSize = 40
    descriptionWindow.BackgroundColor = 0xFFFFFF
    descriptionWindow.Margin = 20;
    descriptionWindow.Leftmargin = 20;
	descriptionWindow.x = 20;
	descriptionWindow.y = GetHeight() - descriptionWindow.height - 20;
	descriptionWindow.alpha = 255;
	descriptionWindow.layer = 6;
	descriptionWindow.font = GetFont("state");
	self.frame:AddComponent(descriptionWindow);
	local closeButton = self:CreateButton("Close", 
		function (button, luaevent, args)
				self:Dispose();
		end,
		descriptionWindow.width - 110, descriptionWindow.height - 50, 5)
	descriptionWindow:AddComponent(closeButton);
	
	local graphWindow = ImageWindow()
	graphWindow.name = "graphWindow"
	graphWindow.relative = true;
	graphWindow.width = 280;
	graphWindow.height = 480;
    graphWindow.WindowTexture = "Resources/sampler/resources/window.png"
    graphWindow.RectSize = 40
    graphWindow.BackgroundColor = 0xFFFFFF
    graphWindow.Margin = 50;
	graphWindow.x = GetWidth() - graphWindow.width - 20;
	graphWindow.y = GetHeight() - graphWindow.height - 20;
	graphWindow.alpha = 255
	graphWindow.layer = 6;
	self.frame:AddComponent(graphWindow);

	local itemListView = Flowview:New("itemListView")
	itemListView.frame.relative = true;
	itemListView.frame.width = graphWindow.width;
	itemListView.frame.height = graphWindow.height;
	itemListView.frame.x = 0;
	itemListView.frame.y = 10;
	itemListView.frame.layer = 4;
	itemListView.spacing = 5;
	itemListView.padding = 10;
	itemListView.frame.visible = true;
	itemListView.frame.enabled = true;
	self.itemListView = itemListView;
	graphWindow:AddComponent(itemListView.frame);	
end