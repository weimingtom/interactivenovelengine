LoadScript "components\\luaview.lua"

StatusView = LuaView:New();

function StatusView:Init()
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
		end

	parent:AddComponent(self.frame)
	
	local descriptionWindow = ImageWindow()
	self.descriptionWindow = descriptionWindow;
	descriptionWindow.name = "descriptionWindow"
	descriptionWindow.relative = true;
	descriptionWindow.width = 240;
	descriptionWindow.height = 320;
    descriptionWindow.WindowTexture = "resources/window.png"
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
    graphWindow.WindowTexture = "resources/window.png"
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

function StatusView:SetDescriptionText(text)
	self.descriptionWindow.text = text;
end

function StatusView:CreateButton(buttonText, event, x, y, layer)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonText;
	newButton.Texture = "resources/button/button.png"	
	newButton.Layer = layer
	newButton.X = x;
	newButton.Y = y;
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

function StatusView:AddGraphItem(key, value, percentage, color)
	self.itemListView:Add(self:CreateGraphItem(key, value, percentage, color));
end

function StatusView:CreateItemButton(buttonName, buttonText)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonName;
	newButton.Texture = "resources/button.png"	
	newButton.Layer = 3
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 120;
	newButton.Height = 40;
	newButton.State = {}
	newButton.Text = buttonText;
	newButton.Font = GetFont("default");
	newButton.TextColor = 0xEEEEEE
	return newButton;
end

function StatusView:CreateGraphItem(key, value, percentage, color)
	local frame = View();
	frame.Relative = true;
	frame.Name = key;
	frame.Width = 240;
	frame.Height = 20;
	local textButton = Button()
	textButton.Relative = true;
	textButton.Name = "text";
	textButton.Layer = 3
	textButton.Alignment = 0;
	textButton.X = 0;
	textButton.Y = 2;
	textButton.Width = 100;
	textButton.Height = 10;
	textButton.Text = key;
	textButton.Font = GetFont("state");
	textButton.TextColor = 0xEEEEEE
	
	frame:AddComponent(textButton);
	
	local valueButton = Button()
	valueButton.Relative = true;
	valueButton.Name = "value";
	valueButton.Layer = 3
	valueButton.Alignment = 0;
	valueButton.X = textButton.Width;
	valueButton.Y = 2;
	valueButton.Width = 50;
	valueButton.Height = 10;
	valueButton.Text = value;
	valueButton.Font = GetFont("state");
	valueButton.TextColor = 0xEEEEEE
	
	frame:AddComponent(valueButton);
	
	
	local graphView = View();
	graphView.Relative = true;
	graphView.Name = key;
	graphView.X = valueButton.X + valueButton.Width;
	graphView.Y = 2;
	graphView.Width = percentage / 100 * (frame.Width - graphView.X);
	graphView.Height = 12;
	valueButton.Layer = 2;
	graphView.BackgroundColor = color
	
	frame:AddComponent(graphView);
	
	return frame;
end

