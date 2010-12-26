LoadScript "Resources\\sampler\\components\\luaview.lua"
LoadScript "Resources\\sampler\\components\\dialoguewindow.lua"

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
	self.frame.x = 0;--(GetWidth() - self.frame.Width) / 2;
	self.frame.y = 0;--(GetHeight() - self.frame.Height) / 2;
	self.frame.alpha = 155
	self.frame.layer = 3
	
	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)	
		end
	
	parent:AddComponent(self.frame)
	
	local viewframe = View();
	viewframe.Name = "viewframe"
	viewframe.Width = 450;
	viewframe.Height = 240;
	viewframe.Relative = true;
	viewframe.x = (self.frame.Width - viewframe.Width) / 2;
	viewframe.y = (self.frame.Height - viewframe.Height) / 2;
	viewframe.layer = 3;
	viewframe.visible = true;
	viewframe.enabled = true;
	self.viewframe = viewframe;
	self.frame:AddComponent(viewframe);
	
	local talkimage = SpriteBase();
	talkimage.Relative = true;
	talkimage.Name = "villageiamge";
	talkimage.Texture = "Resources/sampler/resources/images/musume.png";
	talkimage.Visible = true;
	talkimage.X = 0;
	talkimage.y = 0;
	talkimage.Layer = 2;
	self.talkimage = talkimage;
	viewframe:AddComponent(talkimage);
	
	self.talk1Button = self:CreateButton("shop1button", "대인관계", 
										 viewframe.width - 125, 5+45*0, 4)
	self.viewframe:AddComponent(self.talk1Button);
	
	
	self.talk2Button = self:CreateButton("shop2button", "공부", 
										 viewframe.width - 125, 5+45*1, 4)
	self.viewframe:AddComponent(self.talk2Button);

	
	self.talk3Button = self:CreateButton("shop3button", "불만", 
										 viewframe.width - 125, 5+45*2, 4)
	self.viewframe:AddComponent(self.talk3Button);

	
	self.closeButton = self:CreateButton("closeButton", "Close", 
										 viewframe.width - 125, 5+45*3, 4)
	self.closeButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false
				Trace("button click!")
				self:Dispose();
			end
		end
	self.viewframe:AddComponent(self.closeButton);
	
	local dialogueWin = DialogueWindow:New("dialogueWin", self.frame);
	self.dialogueWin = dialogueWin;
	dialogueWin:Init();
	dialogueWin.frame.relative = true;
	dialogueWin.frame.x = 0;
	dialogueWin.frame.y = self.frame.height - dialogueWin.frame.height;
	dialogueWin:Hide();
	
end

function TalkListView:SetTalkSelectedEvent(event)
	self.talkSelectedEvent = event;
end

function TalkListView:CreateButtonInternal(buttonName, buttonText, event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonName;
	newButton.Texture = "Resources/sampler/resources/button/button.png"	
	newButton.Layer = 3
	newButton.X = 0;
	newButton.Y = 0;
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



function TalkListView:CreateButton(buttonName, text, x, y, layer)
	local button = self:CreateButtonInternal(buttonName, text, 		
        function (button, luaevent, args)
			if (self.talkSelectedEvent ~= nil) then
				self.talkSelectedEvent(button, luaevent, args);
			end	
		end)
	button.X = x;
	button.Y = y;
	return button;	
end

function TalkListView:SetGreeting(portrait, name, text)	
	self.dialogueWin:Show();
	self.dialogueWin:SetPortraitTexture(portrait);
	self.dialogueWin:SetDialogueName(name);
	self.dialogueWin:ClearDialogueText();
	self.dialogueWin:SetDialogueText(text);	
end