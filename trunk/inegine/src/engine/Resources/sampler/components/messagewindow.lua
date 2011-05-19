LoadScript "components\\luaview.lua"

MessageWindow = LuaView:New();

dialogue_font_name = "small"
dialogue_font_text = "dialogue"

function MessageWindow:Init()
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local name = self.name;
	
	self.frame = View()
	self.frame.Name = name
	self.frame.Width = 800;
	self.frame.Height = 600;
	self.frame.x = 0;
	self.frame.y = 0;
	self.frame.alpha = 155
	self.frame.layer = 3
	
	self.frame.Visible = false
	self.frame.Enabled = false
	
	parent:AddComponent(self.frame)
	
	local background = SpriteBase();
	background.Name = "background";
	self.background = background;
	background.Texture = "resources/ui/message_window.png"
	background.Visible = true;
	background.Layer = 0;
	self.frame:AddComponent(background)
	
	
	local dialogueWin = TextWindow()
	dialogueWin.Name = "MessageWindow"
	dialogueWin.relative = true;
	dialogueWin.Alpha = 0
	dialogueWin.Width = 503
	dialogueWin.Height = 98
	dialogueWin.x = 133;
	dialogueWin.y = 481;
	dialogueWin.Layer = 5
	dialogueWin.LineSpacing = 20
	dialogueWin.Margin = 0
	dialogueWin.MouseClick = 
        function(window, luaevent, args)
			Trace(window.name .. " clicked!");	
            window:AdvanceText();
        end
	dialogueWin.Visible = true
	dialogueWin.Font = GetFont(dialogue_font_text)
	
	dialogueWin.Cursor = AnimatedSprite();
	dialogueWin.Cursor.Name = "cursor"
	dialogueWin.Cursor.Texture = "resources/cursor.png"
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
	namewin.Width = 137
	namewin.Height = 33
	namewin.Relative = true
	namewin.x = 136;
	namewin.y = 441;
	namewin.Layer = 6
	namewin.Visible = true
	namewin.Font = GetFont(dialogue_font_name)
	namewin.TextColor = 0x000000
	namewin.Alignment = 1
	background:AddComponent(namewin)
	self.namewin = namewin;		
end

function MessageWindow:SetPortraitTexture(texture)
end

function MessageWindow:ClearDialogueText()
	self.dialogueWin:Clear()
end

function MessageWindow:ClearPortraitTexture()
end

function MessageWindow:ClearDialogueName()
	self.namewin.Text = "";
end

function MessageWindow:SetDialogueText(text)
	self.dialogueWin:Print(text)
end

function MessageWindow:SetDialogueName(name)
	self.namewin.Text = name
end

function MessageWindow:SetDialogueOverEvent(event)
	self.dialogueOverEvent = event;
end

function MessageWindow:Advance()
    self.dialogueWin:AdvanceText();
end