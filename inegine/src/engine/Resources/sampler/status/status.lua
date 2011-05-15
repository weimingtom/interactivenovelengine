LoadScript "components\\luaview.lua"
LoadScript "components\\uifactory.lua"

StatusView = LuaView:New();
statusview_state_item_font = "state_item"

function StatusView:Init()
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local name = self.name;
	
	self.frame = View()
	self.frame.Name = name
	
	self.frame.Width = GetWidth()
	self.frame.Height = GetHeight()
	self.frame.x = 0;
	self.frame.y = 0;
	self.frame.alpha = 155
	self.frame.layer = 10
	
	self.frame.Visible = false
	self.frame.Enabled = false

	parent:AddComponent(self.frame)
	
	--back button
	self.backButton = UIFactory.CreateBackButton(
		function (button, luaevent, args)
				self:Dispose();
		end
	)
	self.backButton.Layer = 5
	self.frame:AddComponent(self.backButton);
	
	local stateMenu = SpriteBase();
	stateMenu.Name = "calBackground";
	self.stateMenu = stateMenu;
	stateMenu.Texture = "resources/ui/state_menu.png"
	stateMenu.Visible = true;
	stateMenu.Layer = 3;
	self.frame:AddComponent(stateMenu)
	
	
	local nameWindow = TextWindow()
	self.nameWindow = nameWindow;
	nameWindow.name = "nameWindow"
	nameWindow.relative = true;
	nameWindow.width = 166;
	nameWindow.height = 100;
    nameWindow.TextColor = 0x000000
    nameWindow.x = 60;
	nameWindow.y = 70;
	nameWindow.alpha = 0;
	nameWindow.layer = 6;
	nameWindow.font = GetFont("calendar_state_name");
	self.frame:AddComponent(nameWindow);
	
	local descriptionWindow = TextWindow()
	self.descriptionWindow = descriptionWindow;
	descriptionWindow.name = "descriptionWindow"
	descriptionWindow.relative = true;
	descriptionWindow.width = 166;
	descriptionWindow.height = 96;
    descriptionWindow.TextColor = 0x000000
    descriptionWindow.x = 60;
	descriptionWindow.y = 90;
	descriptionWindow.alpha = 0;
	descriptionWindow.layer = 6;
	descriptionWindow.font = GetFont("calendar_state_state");
	self.frame:AddComponent(descriptionWindow);
	
	--local closeButton = self:CreateButton("Close", 
		--function (button, luaevent, args)
				--self:Dispose();
		--end,
		--descriptionWindow.width - 110, descriptionWindow.height - 50, 5)
	--descriptionWindow:AddComponent(closeButton);
	--
	--local graphWindow = ImageWindow()
	--graphWindow.name = "graphWindow"
	--graphWindow.relative = true;
	--graphWindow.width = 280;
	--graphWindow.height = 480;
    --graphWindow.WindowTexture = "resources/window.png"
    --graphWindow.RectSize = 40
    --graphWindow.BackgroundColor = 0xFFFFFF
    --graphWindow.Margin = 50;
	--graphWindow.x = GetWidth() - graphWindow.width - 20;
	--graphWindow.y = GetHeight() - graphWindow.height - 20;
	--graphWindow.alpha = 255
	--graphWindow.layer = 6;
	--self.frame:AddComponent(graphWindow);
--
	local itemListView = Flowview:New("itemListView")
	itemListView.frame.relative = true;
	itemListView.frame.width = 171
	itemListView.frame.height = 215
	itemListView.frame.x = 580;
	itemListView.frame.y = 111;
	itemListView.frame.layer = 4;
	itemListView.spacing = 2;
	itemListView.padding = 0;
	itemListView.frame.visible = true;
	itemListView.frame.enabled = true;
	self.itemListView = itemListView;
	self.frame:AddComponent(itemListView.frame);	
end

function StatusView:SetName(text)
	self.nameWindow.text = text;
end

function StatusView:SetDescriptionText(text)
	self.descriptionWindow.text = text;
end

function StatusView:AddGraphItem(key, value, percentage, color)
	self.itemListView:Add(self:CreateGraphItem(key, value, percentage, color));
end

function StatusView:AddEmpty()
	self.itemListView:Add(self:CreateEmptyGraphItem());
end

function StatusView:CreateEmptyGraphItem()
	local frame = View();
	frame.Relative = true;
	frame.Name = "empty"
	frame.Width = 170;
	frame.Height = 20;
	return frame;
end

function StatusView:CreateGraphItem(key, value, percentage, color)
	local frame = View();
	frame.Relative = true;
	frame.Name = key;
	frame.Width = 170;
	frame.Height = 20;
	
	local textButton = Button()
	textButton.Relative = true;
	textButton.Name = "text";
	textButton.Layer = 3
	textButton.Alignment = 0;
	textButton.X = 0;
	textButton.Y = 0;
	textButton.Width = 70;
	textButton.Height = 20;
	textButton.Text = key;
	textButton.Font = GetFont(statusview_state_item_font);
	textButton.TextColor = 0x000000
	
	frame:AddComponent(textButton);
	
	local valueButton = Button()
	valueButton.Relative = true;
	valueButton.Name = "value";
	valueButton.Layer = 3
	valueButton.Alignment = 0;
	valueButton.X = textButton.Width - 10;
	valueButton.Y = 0;
	valueButton.Width = 50;
	valueButton.Height = 20;
	valueButton.Text = value;
	valueButton.Font = GetFont(statusview_state_item_font);
	valueButton.TextColor = 0x000000
	
	frame:AddComponent(valueButton);
	
	
	local graphView = View();
	graphView.Relative = true;
	graphView.Name = key;
	graphView.X = valueButton.X + valueButton.Width - 10;
	graphView.Y = 4;
	graphView.Width = percentage / 100 * (frame.Width - graphView.X);
	graphView.Height = 12;
	valueButton.Layer = 2;
	graphView.BackgroundColor = color
	
	frame:AddComponent(graphView);
	
	return frame;
end

