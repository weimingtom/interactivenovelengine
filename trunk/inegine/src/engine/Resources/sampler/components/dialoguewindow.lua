require "Resources\\sampler\\components\\luaview"

DialogueWindow = LuaView:New();

function DialogueWindow:Init()
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local font = GetFont("default")
	local name = self.name;
	
	self.frame = View()
	self.frame.Name = name
	self.frame.Width = 800;
	self.frame.Height = 160;
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
	
	local background = SpriteBase();
	background.Name = "background";
	self.background = background;
	background.Texture = "Resources/sampler/resources/windows/dialoguewin.png"
	background.Visible = true;
	background.Layer = 0;
	background.x = self.frame.Width - background.Width - 20;
	self.frame:AddComponent(background)
	
	
	local dialogueWin = TextWindow()
	dialogueWin.Name = "dialogueWindow"
	dialogueWin.relative = true;
	dialogueWin.Alpha = 0
	dialogueWin.Width = 570
	dialogueWin.Height = 93
	dialogueWin.x = 15;
	dialogueWin.y = 40;
	dialogueWin.Layer = 5
	dialogueWin.LineSpacing = 20
	dialogueWin.Margin = 0
	dialogueWin.MouseClick = 
        function(window, luaevent, args)
			Trace(window.name .. " clicked!");	
            window:AdvanceText();
        end
	dialogueWin.Visible = true
	--dialogueWin.WindowTexture = "Resources/sampler/resources/win.png"
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
	background:AddComponent(dialogueWin);
	self.dialogueWin = dialogueWin;
	
	local namewin = Button()
	namewin.Name = "namewindow"	
	namewin.Alpha = 255
	namewin.Width = 150
	namewin.Height = 40
	namewin.Relative = true
	namewin.x = 15;
	namewin.y = -2;
	namewin.Layer = 6
	namewin.Visible = true
	namewin.Font = GetFont("small")
	namewin.TextColor = 0xFFFFFF
	namewin.Alignment = 0
	background:AddComponent(namewin)
	self.namewin = namewin;	
		
	local portrait = SpriteBase();
	portrait.Name = "portrait";
	portrait.Visible = true;
	portrait.relative = true;
	portrait.Layer = 2;
	self.portrait = portrait;
	self.frame:AddComponent(portrait);		
end

function DialogueWindow:SetPortraitTexture(texture)
	self.portrait.Texture = texture;
	self.portrait.X = (self.background.x - self.portrait.Width) / 2;
	self.portrait.y = self.frame.Height - self.background.Height - 20 + 
					  ((self.background.Height - self.portrait.Height) / 2);
end

function DialogueWindow:ClearDialogueText()
	self.dialogueWin:Clear()
end

function DialogueWindow:SetDialogueText(text)
	self.dialogueWin:Print(text)
end

function DialogueWindow:SetDialogueName(name)
	self.namewin.Text = name
end

function DialogueWindow:SetDialogueOverEvent(event)
	self.dialogueOverEvent = event;
end
