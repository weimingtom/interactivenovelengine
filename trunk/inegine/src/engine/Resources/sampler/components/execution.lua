-- schedule UI component implemented in lua

ExecutionView = {}

function ExecutionView:New (name, parent)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.parent = parent;
	o.name = name
	
	o:Init();
	
	return o
end

function ExecutionView:Init()
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
	
	local dialogueWin = ImageWindow()
	dialogueWin.Name = "dialogueWindow"
	dialogueWin.Alpha = 155
	dialogueWin.Width = 600
	dialogueWin.Height = 120
	dialogueWin.x = self.frame.Width - dialogueWin.Width - 20;
	dialogueWin.y = self.frame.Height - dialogueWin.Height - 20;
	dialogueWin.Layer = 5
	dialogueWin.LineSpacing = 20
	dialogueWin.MouseClick = 
        function(window, luaevent, args)
			Trace(window.name .. " clicked!");	
            window:AdvanceText();
        end
	dialogueWin.Visible = true
	dialogueWin.WindowTexture = "Resources/sampler/resources/win.png"
	dialogueWin.Font = GetFont("dialogue")
	
	dialogueWin.Cursor = AnimatedSprite();
	dialogueWin.Cursor.Name = "cursor"
	dialogueWin.Cursor.Texture = "Resources/sampler/resources/cursor.png"
	dialogueWin.Cursor.Width = 32;
	dialogueWin.Cursor.Height = 48;
	dialogueWin.Cursor.Rows = 4;
	dialogueWin.Cursor.Cols = 4;
	dialogueWin.Cursor.Layer = 10;
	dialogueWin.Cursor.Visible = true
	dialogueWin.PrintOver = 
		function (window, luaevent, args)
                if (self.dialogueOverEvent~=nil) then 
					self.dialogueOverEvent(window, luaevent, args);
				end
		end
	dialogueWin.narrationSpeed = 30;
	self.frame:AddComponent(dialogueWin);
	self.dialogueWin = dialogueWin;
	
	
	local portrait = SpriteBase();
	portrait.Name = "portrait";
	portrait.Texture = "Resources/sampler/images/f2.png"
	portrait.Visible = true;
	portrait.X = (dialogueWin.x - portrait.Width) / 2;
	portrait.y = self.frame.Height - dialogueWin.Height - 20 + ((dialogueWin.Height - portrait.Height) / 2);
	portrait.Layer = 2;
	self.portrait = portrait;
	self.frame:AddComponent(portrait);

	self:ShowDialogue(false);	
	
	local statusWindow = TextWindow()
	statusWindow.name = "statusWindow"
	statusWindow.relative = true;
	statusWindow.width = 480;
	statusWindow.height = 100;
	statusWindow.x = (self.frame.width - statusWindow.width) / 2;
	statusWindow.y = dialogueWin.y - statusWindow.height - 5;
	statusWindow.alpha = 155
	statusWindow.layer = 6;
	statusWindow.BackgroundColor = 0xFFFFFF
	statusWindow.TextColor = 0x000000
	statusWindow.font = GetFont("state");
	self.statusWindow = statusWindow;
	self.frame:AddComponent(statusWindow);
	self:ShowStatus(false);
	
	local animatedWindow = TextWindow()
	animatedWindow.name = "animatedwindow"
	animatedWindow.relative = true;
	animatedWindow.width = 320;
	animatedWindow.height = 240;
	animatedWindow.x = (self.frame.width - animatedWindow.width) / 2;
	animatedWindow.y = statusWindow.y - animatedWindow.height - 5;
	animatedWindow.alpha = 200
	animatedWindow.layer = 6;
	self.frame:AddComponent(animatedWindow);
	self.animatedWindow = animatedWindow;
	self:ShowAnimationView(false);
	
end

function ExecutionView:Dispose()
	self.parent:RemoveComponent(self.name)
end

function ExecutionView:Show()
	Trace("showing schedule!")
	self.frame.Visible = true
	self.frame.Enabled = true
end


function ExecutionView:Hide()
	self.frame.Visible = false
	self.frame.Enabled = false
end

function ExecutionView:SetDialogueOverEvent(event)
	self.dialogueOverEvent = event;
end

function ExecutionView:SetDialogueText(text)
	--self.dialogueWin:Clear()
	self.dialogueWin:Print(text)
	--self:ShowDialogue(true);
end

function ExecutionView:ClearDialogueText()
	self.dialogueWin:Clear()
end

function ExecutionView:ShowDialogue(show)
	self.dialogueWin.Visible = show;
	self.dialogueWin.Enabled = show;
	self.portrait.Visible = show;
	self.portrait.Enabled = show;
end

function ExecutionView:SetAnimation(animation)
	animation.name = "currentanimation"
	animation.relative = true;
	animation.x = (self.animatedWindow.width - animation.width) / 2
	animation.y = (self.animatedWindow.height - animation.height) / 2;
	
	animation.AnimationOver = 
		function (animation, luaevent, args)
			Trace(animation.name .. "animation over!")
                if (self.animationOverEvent~=nil) then 
                    self.animationOverEvent(animation, luaevent, args);
                end
		end
	self.animatedWindow:RemoveComponent("currentanimation");
	self.animatedWindow:AddComponent(animation);
	animation:Begin(100, 0, 10);
end

function ExecutionView:SetAnimationOverEvent(event)
	self.animationOverEvent = event;
end

function ExecutionView:ShowAnimationView(show)
	self.animatedWindow.Enabled = show;
	self.animatedWindow.Visible = show;
end

function ExecutionView:ShowStatus(show)
	self.statusWindow.Enabled = show;
	if (show == false) then
		self.statusWindow.Visible = false;
	else
		self.statusWindow:LaunchTransition(500, true);
	end
end

function ExecutionView:SetStatusText(text)
	self.statusWindow.text = text;
end
