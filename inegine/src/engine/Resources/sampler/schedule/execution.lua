-- schedule UI component implemented in lua
LoadScript "components\\luaview.lua"

ExecutionView = LuaView:New();

function ExecutionView:Init()
	StopSounds(1000);
    
    self:InitComponents();
end

function ExecutionView:InitComponents()
   
	local gamestate = CurrentState();
	local parent = self.parent;
	local name = self.name;

	self.frame = View()
	self.frame.Name = name

	self.frame.X = 0;
	self.frame.Y = 0;
	self.frame.Width = GetWidth();
	self.frame.Height = GetHeight();
	self.frame.alpha = 155
	self.frame.layer = 10

	self.frame.Visible = true
	self.frame.Enabled = true

	parent:AddComponent(self.frame)

	local dialogueWin = DialogueWindow:New("dialogueWin", self.frame);
	self.dialogueWin = dialogueWin;
	dialogueWin:Init();
	dialogueWin.frame.relative = true;
	dialogueWin.frame.x = 0;
	dialogueWin.frame.y = self.frame.height - dialogueWin.frame.height;
	dialogueWin:Hide();

	local statusMenu = SpriteBase();
	self.statusMenu = statusMenu;
	statusMenu.Texture = "resources/ui/execution_menu.png"
	statusMenu.Visible = true;
	statusMenu.X = 537;
	statusMenu.Y = 154;
	statusMenu.Width = 257;
	statusMenu.Height = 232;
	statusMenu.Layer = 3;
	self.frame:AddComponent(statusMenu)	

	local statusWindow = TextWindow()
	statusWindow.name = "statusWindow"
	statusWindow.relative = true;
	statusWindow.width = 182
	statusWindow.height = 151
	statusWindow.x = 575
	statusWindow.y = 200
	statusWindow.alpha = 155
	statusWindow.layer = 10;
	statusWindow.BackgroundColor = 0xFFFFFF
	statusWindow.TextColor = 0x000000
	statusWindow.font = GetFont("verysmall");
	self.statusWindow = statusWindow;
	self.frame:AddComponent(statusWindow);
	
	
	self:ShowStatus(false);

	local animatedWindow = View()
	animatedWindow.name = "animatedwindow"
	animatedWindow.relative = true;
	animatedWindow.width = 320;
	animatedWindow.height = 240;
	animatedWindow.x = 215
	animatedWindow.y = 150
	animatedWindow.alpha = 0
	animatedWindow.layer = 10;
	self.frame:AddComponent(animatedWindow);
	self.animatedWindow = animatedWindow;
	self:ShowAnimationView(false);

end

function ExecutionView:Dispose()
	self.parent:RemoveComponent(self.name)
end

function ExecutionView:Show()
	self.frame.Visible = true
	self.frame.Enabled = true
end


function ExecutionView:Hide()
	self.frame.Visible = false
	self.frame.Enabled = false
end

function ExecutionView:SetAnimation(animation)
	self.animation = animation;
	animation.name = "currentanimation"
	animation.relative = true;
    animation.x = 5;
    animation.y = 5;
	animation.AnimationOver =
		function (animation, luaevent, args)
                if (self.animationOverEvent~=nil) then
                    self.animationOverEvent(animation, luaevent, args);
                end
		end
	animation:Show();
	self.animatedWindow:RemoveComponent("currentanimation");
	self.animatedWindow:AddComponent(animation);
	animation:FadeIn(100);
	animation:Begin(200, 0);
end

function ExecutionView:SetAnimationOverEvent(event)
	self.animationOverEvent = event;
end

function ExecutionView:ShowAnimationView(show, immediate)
	self.animatedWindow.Enabled = show;
	
	if (immediate == true or immediate == nil) then
		if (show == false) then
			self.animatedWindow:Hide();
		else
			self.animatedWindow:Show();
		end
		return;
	end
	
	if (show == false) then
		self.animatedWindow:FadeOut(100);
	else
		self.animatedWindow:FadeIn(100);
	end
end

function ExecutionView:ShowStatus(show, immediate)
	self.statusWindow.Enabled = show;
	
	if (immediate == true or immediate == nil) then
		if (show == false) then
			self.statusMenu:Hide();
			self.statusWindow:Hide();
		else
			self.statusMenu:Show();
			self.statusWindow:Show();
		end
		return;
	end
	
	if (show == false) then
		self.statusMenu:FadeOut(200);
		self.statusWindow:FadeOut(100);
	else
		self.statusMenu:FadeIn(200);
		self.statusWindow:FadeIn(100);
	end
end

function ExecutionView:SetStatusText(text)
	self.statusWindow.text = text;
end

function ExecutionView:SetExecutionOverEvent(event)
	self.executionOverEvent = event;
end

function ExecutionView:ExecuteSchedule(name, beforeText, beforePortrait, baseAnimation, resultText, afterText, afterPortrait, sound, result, order)
	if (order == 1) then
		self:ShowAnimationView(false);
		self:ShowStatus(false);
	else
		self:ShowAnimationView(false, false);
		self:ShowStatus(false, false);
	end
	
	self.dialogueWin:Hide();

	self:Show();

	self.dialogueWin:ClearDialogueText();
	self.dialogueWin:Show();
	self.dialogueWin:SetDialogueName(name);
	self.dialogueWin:SetPortraitTexture(beforePortrait);
	self.dialogueWin:SetDialogueText(beforeText);

	self.dialogueWin:SetDialogueOverEvent(
		function ()
			self.dialogueWin:Hide();
			self:ShowAnimationView(true, false);

	        local tempAnimation = AnimatedSprite();
	        tempAnimation.Name = "scheduleAnimation"        
	        tempAnimation.Texture = baseAnimation
	        tempAnimation.Layer = 10;
	        tempAnimation.Visible = true
	        self:SetAnimation(tempAnimation);
	        self:SetAnimationOverEvent(
		        function()
					if (result ~= nil) then
						result();
					end
					GetSound(sound):Play();
                    self:ShowStatus(true, false);
			        self:SetStatusText(resultText);
			        self.dialogueWin:SetDialogueOverEvent(
				        function ()
					        self:ShowAnimationView(false, false);
					        self:ShowStatus(false, false);
					        self.dialogueWin:Hide();

					        if (self.executionOverEvent ~= nil) then
						        self:executionOverEvent();
					        end
				        end
			        )
			        self.dialogueWin:ClearDialogueText();
			        self.dialogueWin:SetPortraitTexture(afterPortrait);
			        self.dialogueWin:Show();

			        self.dialogueWin:SetDialogueText(afterText);
		        end
	        );
		end
	)
end

function ExecutionView:Advance()
	if (self.animation ~= nil) then
		self.animation:Stop();
	end
	
	self.dialogueWin:Advance();
end