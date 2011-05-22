LoadScript "components\\luaview.lua"

SystemView = LuaView:New();

function SystemView:Init()
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local name = self.name;
	
	self.frame = View()
	self.frame.Name = name
	
	self.frame.Width = GetWidth();
	self.frame.Height = GetHeight();
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
	
	local talkListMenu = SpriteBase();
	self.talkListMenu = talkListMenu;
	talkListMenu.Texture = "resources/ui/system_menu.png"
	talkListMenu.Visible = true;
	talkListMenu.Layer = 3;
	self.frame:AddComponent(talkListMenu)
	
	self.saveButton = UIFactory.CreateRollOverButton(
		function()
		end,
		function ()
			self.saveRollover:Show();
		end,
		function ()
			self.saveRollover:Hide();
		end);
	self.saveButton.X =  320
	self.saveButton.Y = 240
	self.saveButton.Width = 58
	self.saveButton.Height = 26
	self.saveButton.Layer = 5
	self.frame:AddComponent(self.saveButton);	
	
	local saveRollover = SpriteBase();
	self.saveRollover = saveRollover;
	saveRollover.Texture = "resources/ui/system_save_rollover.png"
	saveRollover.Visible = true;
	saveRollover.Layer = 4;
	self.frame:AddComponent(saveRollover)
	saveRollover:Hide();
		
	self.loadButton = UIFactory.CreateRollOverButton(
		function()
		end,
		function ()
			self.loadRollover:Show();
		end,
		function ()
			self.loadRollover:Hide();
		end);
	self.loadButton.X =  320
	self.loadButton.Y = 269
	self.loadButton.Width = 58
	self.loadButton.Height = 26
	self.loadButton.Layer = 5
	self.frame:AddComponent(self.loadButton);	
	
	local loadRollover = SpriteBase();
	self.loadRollover = loadRollover;
	loadRollover.Texture = "resources/ui/system_load_rollover.png"
	loadRollover.Visible = true;
	loadRollover.Layer = 4;
	self.frame:AddComponent(loadRollover)
	loadRollover:Hide();
	
	self.optionButton = UIFactory.CreateRollOverButton(
		function()
		end,
		function ()
			self.optionRollover:Show();
		end,
		function ()
			self.optionRollover:Hide();
		end);
	self.optionButton.X =  320
	self.optionButton.Y = 298
	self.optionButton.Width = 58
	self.optionButton.Height = 26
	self.optionButton.Layer = 5
	self.frame:AddComponent(self.optionButton);	
	
	local optionRollover = SpriteBase();
	self.optionRollover = optionRollover;
	optionRollover.Texture = "resources/ui/system_option_rollover.png"
	optionRollover.Visible = true;
	optionRollover.Layer = 4;
	self.frame:AddComponent(optionRollover)
	optionRollover:Hide();
		
	self.confirmWindow = UIFactory.CreateConfirmWindow(
		system_confirm_title,
		function() saveManager:Title(); end,
		function() self.confirmWindow:Hide() end);
	self.confirmWindow:Hide();
	self.confirmWindow.layer = 10;
	self.frame:AddComponent(self.confirmWindow);
			
	self.titleButton = UIFactory.CreateRollOverButton(
		function()
			self.confirmWindow:Show();
		end,
		function ()
			self.titleRollover:Show();
		end,
		function ()
			self.titleRollover:Hide();
		end);
	self.titleButton.X =  320
	self.titleButton.Y = 326
	self.titleButton.Width = 58
	self.titleButton.Height = 26
	self.titleButton.Layer = 5
	self.frame:AddComponent(self.titleButton);	
	
	local titleRollover = SpriteBase();
	self.titleRollover = titleRollover;
	titleRollover.Texture = "resources/ui/system_title_rollover.png"
	titleRollover.Visible = true;
	titleRollover.Layer = 4;
	self.frame:AddComponent(titleRollover)
	titleRollover:Hide();
	
	self.backButton = UIFactory.CreateBackButton(
		function (button, luaevent, args)
				self:Dispose();
		end
	)
	self.backButton.X = 483
	self.backButton.Y = 256
	self.backButton.Layer = 10
	self.frame:AddComponent(self.backButton);
	
end

function SystemView:CreateButton(name, texture, rolloverTexture, enabled)
	local button = UIFactory.CreateButton(texture, rolloverTexture,	
        function (button, luaevent, args)
			if (self.talkSelectedEvent ~= nil) then
				if (enabled == nil or enabled == true) then
					self.talkSelectedEvent(button, luaevent, name);
				end
			end
		end, 60, 72)
	return button;	
end