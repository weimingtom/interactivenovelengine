-- schedule UI component implemented in lua
require "Resources\\sampler\\components\\luaview"

ExecutionView = LuaView:New();

function ExecutionView:Init()
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

	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)
		end

	parent:AddComponent(self.frame)

	local dialogueWin = DialogueWindow:New("dialogueWin", self.frame);
	self.dialogueWin = dialogueWin;
	dialogueWin:Init();
	dialogueWin.frame.relative = true;
	dialogueWin.frame.x = 0;
	dialogueWin.frame.y = self.frame.height - dialogueWin.frame.height;
	dialogueWin:Hide();

	local statusWindow = TextWindow()
	statusWindow.name = "statusWindow"
	statusWindow.relative = true;
	statusWindow.width = 480;
	statusWindow.height = 100;
	statusWindow.x = (self.frame.width - statusWindow.width) / 2 + 20;
	statusWindow.y = dialogueWin.frame.y - statusWindow.height - 5;
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
	animatedWindow.x = (self.frame.width - animatedWindow.width) / 2 + 20;
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
		self.statusWindow:FadeIn(500);--, true);
	end
end

function ExecutionView:SetStatusText(text)
	self.statusWindow.text = text;
end

function ExecutionView:SetExecutionOverEvent(event)
	self.executionOverEvent = event;
end

function ExecutionView:ExecuteSchedule(name, beforeText, beforePortrait, baseAnimation, resultAnimation, resultText, afterText, afterPortrait)
	self:ShowAnimationView(false);
	self:ShowStatus(false);
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
			self:ShowAnimationView(true);
			local tempAnimation = AnimatedSprite();
			tempAnimation.Name = "scheduleAnimation"
			tempAnimation.Texture = baseAnimation
			tempAnimation.Width = 32;
			tempAnimation.Height = 48;
			tempAnimation.Rows = 4;
			tempAnimation.Cols = 4;
			tempAnimation.Layer = 10;
			tempAnimation.Visible = true

			self:SetAnimation(tempAnimation);
			self:SetAnimationOverEvent(
				function()
			        local tempAnimation = AnimatedSprite();
			        tempAnimation.Name = "scheduleAnimation"        
			        tempAnimation.Texture = resultAnimation
			        tempAnimation.Width = 32;
			        tempAnimation.Height = 48;
			        tempAnimation.Rows = 4;
			        tempAnimation.Cols = 4;
			        tempAnimation.Layer = 10;
			        tempAnimation.Visible = true
			        self:SetAnimation(tempAnimation);
			        self:SetAnimationOverEvent(
				        function()
	                        self:ShowStatus(true);
					        self:SetStatusText(resultText);
					        self.dialogueWin:SetDialogueOverEvent(
						        function ()
							        self:ShowAnimationView(false);
							        self:ShowStatus(false);
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
			);
		end
	)
end