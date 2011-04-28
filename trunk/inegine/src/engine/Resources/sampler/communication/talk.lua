LoadScript "components\\luaview.lua"
LoadScript "components\\dialoguewindow.lua"

TalkView = LuaView:New();

function TalkView:Init()
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
	
	local dialogueWin = DialogueWindow:New("dialogueWin", self.frame);
	self.dialogueWin = dialogueWin;
	dialogueWin:Init();
	dialogueWin.frame.relative = true;
	dialogueWin.frame.x = 0;
	dialogueWin.frame.y = self.frame.height - dialogueWin.frame.height;
	dialogueWin:Hide();
end

function TalkView:SetTalk(portrait, name, text)	
	self.dialogueWin:Show();
	self.dialogueWin:SetPortraitTexture(portrait);
	self.dialogueWin:SetDialogueName(name);
	self.dialogueWin:ClearDialogueText();
	self.dialogueWin:SetDialogueText(text);	
end

function TalkView:SetTalkOverEvent(event)
	self.dialogueWin:SetDialogueOverEvent(event);
end

function TalkView:Advance()
	self.dialogueWin:Advance();
end