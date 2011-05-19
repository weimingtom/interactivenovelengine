LoadScript "components\\luaview.lua"
LoadScript "components\\dialoguewindow.lua"

TalkListView = LuaView:New();

function TalkListView:Init()
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local font = GetFont("default")
	local name = self.name;
	
	self.frame = View()
	self.frame.Name = name
	
	self.frame.Width = GetWidth();--450
	self.frame.Height = GetHeight();--240
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
	talkListMenu.Texture = "resources/ui/talk_list.png"
	talkListMenu.Visible = true;
	talkListMenu.Layer = 3;
	self.frame:AddComponent(talkListMenu)
	
	local talkList = Flowview:New("talkList")
	talkList.frame.relative = true;
	talkList.frame.width = 229;
	talkList.frame.height = 80;
	talkList.frame.x = 320;
	talkList.frame.y = 251;
	talkList.frame.layer = 4;
	talkList.spacing = 20;
	talkList.padding = 2;
	self.talkList = talkList;
	self.frame:AddComponent(self.talkList.frame);
	self.talkList:Show();
	
	self.musumeButton = self:CreateButton("musumeButton", "resources/icon/talk01a.png", "resources/icon/talk01b.png");
	self.goddessButton = self:CreateButton("goddessButton", "resources/icon/talk02a.png", "resources/icon/talk02b.png", false);
	
	talkList:Add(self.musumeButton);
	talkList:Add(self.goddessButton);
	

	self.backButton = UIFactory.CreateBackButton(
		function (button, luaevent, args)
				self:Dispose();
		end
	)
	self.backButton.X = 491
	self.backButton.Y = 259
	self.backButton.Layer = 10
	self.frame:AddComponent(self.backButton);
	
end

function TalkListView:ToggleMusumeEvent()
	local eventButton = Button();
	eventButton.texture = "resources/icon/talk_event.png";
	eventButton.layer = 10;
	eventButton.enabled = false;
	self.musumeButton:AddComponent(eventButton);
end

function TalkListView:ToggleGoddessEvent()
	local eventButton = Button();
	eventButton.texture = "resources/icon/talk_event.png";
	eventButton.layer = 10;
	eventButton.enabled = false;
	self.goddessButton:AddComponent(eventButton);
end

function TalkListView:SetTalkSelectedEvent(event)
	self.talkSelectedEvent = event;
end

function TalkListView:CreateButton(name, texture, rolloverTexture, enabled)
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

function TalkListView:SetGreeting(portrait, name, text)	
end