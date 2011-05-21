-- UI factory for commonly used components
UIFactory = {}

function UIFactory.CreateButton(texture, rolloverTexture, event, width, height)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Texture = texture
	local rollOverButton = Button()
	rollOverButton.Relative = true;
	rollOverButton.State = {}
	rollOverButton.Texture = rolloverTexture;
	rollOverButton.layer = 5;
	rollOverButton.MouseDown = 
		function (rollOverButton, luaevent, args)
			rollOverButton.State["mouseDown"] = true
		end
	rollOverButton.MouseUp = 
		function (rollOverButton, luaevent, args)
			if (rollOverButton.State["mouseDown"]) then
                if (event~=nil) then 
					event(rollOverButton, luaevent, args);
				end
			end
		end
	newButton:AddComponent(rollOverButton);
	rollOverButton:Hide();
		
	newButton.MouseLeave =
		function (button, luaevent, args)
			rollOverButton:Hide();
		end
	newButton.MouseEnter =
		function (button, luaevent, args)
			rollOverButton:Show();
		end
		
	if (width ~=nil) then
		newButton.width = width;
		rollOverButton.width = width;
	end
			
	if (height ~=nil) then
		newButton.height = height;
		rollOverButton.height = height;
	end
		
	return newButton;
end

function UIFactory.CreateConfirmWindow(text, okEvent, closeEvent)
	local view = View();
	view.BackgroundColor = 0x000000
	view.Alpha = 155;
	view.Width = GetWidth();
	view.Height = GetHeight();
	local frame = SpriteBase();
	frame.Texture = "resources/ui/confirm_window.png"
	view:AddComponent(frame);
	
	
	local textButton = Button();
	textButton.Width = 265;
	textButton.Height = 85;
	textButton.X = 275
	textButton.Y = 226
	textButton.font = GetFont("small");
	textButton.textColor = 0x000000
	textButton.Alignment = 1;
	textButton.VerticalAlignment = 1;
	textButton.Layer = 10
	textButton:Show();
	textButton.text = text;
	view:AddComponent(textButton);
		
	local okRollover = SpriteBase();
	okRollover.Texture = "resources/ui/confirm_window_rollover.png"
	okRollover.Visible = true;
	okRollover.Layer = 4;
	view:AddComponent(okRollover)
	okRollover:Hide();
	
	local okButton = UIFactory.CreateRollOverButton(
		function()
			okEvent();
		end,
		function ()
			okRollover:Show();
		end,
		function ()
			okRollover:Hide();
		end);
	okButton.X =  449
	okButton.Y = 322
	okButton.Width = 51
	okButton.Height = 30
	okButton.Layer = 5
	view:AddComponent(okButton);	
		
	local backButton = UIFactory.CreateBackButton(
		function (button, luaevent, args)
				closeEvent();
		end
	)
	backButton.X = 540
	backButton.Y = 235
	backButton.Layer = 10
	view:AddComponent(backButton);
	return view;
end

function UIFactory.CreateBackButton(event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Texture = "resources/ui/back_button.png"
	newButton.State = {}
	newButton.X = 723;
	newButton.Y = 469
	
	newButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.Pushed = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.Pushed == true) then
				button.Pushed = false;
                if (event~=nil) then 
					event(button, luaevent, args);
				end
			end
		end
	newButton.MouseLeave =
		function (button, luaevent, args)
				button.Pushed = false;
		end
	return newButton;
end

function UIFactory.CreateRollOverButton(clickEvent, rollOnEvent, rollOffEvent)
	local newButton = View()
	--newButton.BackgroundColor = 0x000000
	--newButton.Alpha = 155
	newButton.Relative = true;
	newButton.Layer = 3
	newButton.State = {}
	newButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"] and button.State["mouseIn"]) then
                if (clickEvent~=nil) then 
					clickEvent(button, luaevent, args);
				end
			end
		end
	newButton.MouseLeave =
		function (button, luaevent, args)
			newButton.State["mouseIn"] = false
			rollOffEvent();
		end
	newButton.MouseEnter =
		function (button, luaevent, args)
			newButton.State["mouseIn"] = true
			rollOnEvent();
		end
	return newButton;
end


function UIFactory.CreateItemButton(id, name, icon, price, count, effect, event, equipped, rollOverEvent)
	local frame = View();
	--frame.BackgroundColor = 0x000000
	--frame.Alpha = 155
	frame.Name = id;
	frame.Relative = true;
	frame.Width = 170;
	frame.Height = 60;
	frame.Enabled = true;
	
	local pic = Button();
	pic.Name = "picture";
	pic.Texture = icon
	pic.Visible = true;
	pic.Width = 60;
	pic.Height = 60;
	pic.X = 0
	pic.Y = 0
	pic.MouseDoubleClick = 
		function (button, luaevent, args)
			if (event ~= nil) then
				event(button, luaevent, id);
			end
		end
	pic.MouseMove =
		function (button, luaevent, args)
			if (rollOverEvent ~= nil) then
				rollOverEvent(button, luaevent, id);
			end
		end
		
	frame:AddComponent(pic);
	
	local star = Button();
	star.Texture = "resources/ui/inventory_star.png"
	star.Visible = true;
	star.Width = 20;
	star.Height = 20
	star.Layer = 10;
	star.X = 40
	star.Y = 40
	
	if (equipped == nil or equipped == false) then
		star:Hide();
	else
		star:Show();
	end
	
	frame:AddComponent(star);
	
	local button = View();
	button.Width = 20;
	button.Height = 22;
	button.X = 40
	button.Y = 40;
	button.BackgroundColor = 0xFFFFFF
	button.Alpha = 100
	if (count > 1) then
		button:Show();
	else
		button:Hide();
	end
	frame:AddComponent(button);
	
	local button = Button();
	button.Width = 20;
	button.Height = 22;
	button.X = 40
	button.Y = 40;
	button.font = GetFont("item_desc");
	button.TextColor = 0x000000
	if (count > 1) then
		button.Text = count
		button:Show();
	else
		button:Hide();
	end
	button.Alignment = 0;
	button.VerticalAlignment = 1;
	frame:AddComponent(button);
	
	
	
	local button = Button();
	button.Width = 110;
	button.Height = 21;
	button.X = 60
	button.Y = 0;
	button.font = GetFont("item_name");
	button.TextColor = 0x000000
	button.Text = name
	button.Alignment = 0;
	button.VerticalAlignment = 1;
	frame:AddComponent(button);
	
	local button = Button();
	button.Width = 110;
	button.Height = 20;
	button.X = 60
	button.Y = 20;
	button.font = GetFont("item_desc");
	button.TextColor = 0x000000
	button.Text = price .. "G"
	button.Alignment = 0;
	button.VerticalAlignment = 1;
	frame:AddComponent(button);
	
	local button = Button();
	button.Width = 110;
	button.Height = 20;
	button.X = 60
	button.Y = 40;
	button.font = GetFont("item_desc");
	button.TextColor = 0x000000
	button.Text = effect
	button.Alignment = 0;
	button.VerticalAlignment = 1;
	frame:AddComponent(button);
	
	return frame;
end