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
	
	local dialogueWin = ImageWindow()
	dialogueWin.Name = "dialogueWindow"
	dialogueWin.relative = true;
	dialogueWin.Alpha = 155
	dialogueWin.Width = 600
	dialogueWin.Height = 120
	dialogueWin.x = self.frame.Width - dialogueWin.Width - 20;
	dialogueWin.y = self.frame.Height - dialogueWin.Height - 20;
	dialogueWin.Layer = 5
	dialogueWin.LineSpacing = 20
	dialogueWin.Margin = 30
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
	
	local namewin = Button()
	namewin.Name = "namewindow"	
	namewin.Alpha = 255
	namewin.Width = 150
	namewin.Height = 40
	namewin.Relative = true
	namewin.x = 5;
	namewin.y = -5;
	namewin.Layer = 6
	namewin.Visible = true
	namewin.Font = GetFont("small")
	namewin.TextColor = 0xFFFFFF
	namewin.Alignment = 0
	dialogueWin:AddComponent(namewin)
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
	self.portrait.X = (self.dialogueWin.x - self.portrait.Width) / 2;
	self.portrait.y = self.frame.Height - self.dialogueWin.Height - 20 + 
					  ((self.dialogueWin.Height - self.portrait.Height) / 2);
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
