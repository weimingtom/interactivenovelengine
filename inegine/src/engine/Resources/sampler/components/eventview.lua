LoadScript "components\\dialoguewindow.lua"

--GUI initialization

EventView = {}

function EventView:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self

    self:InitComponents()
    self:InitHandlers()
    
	return o
end

function EventView:SetEventClosingEvent(event)
    self.eventClosingEvent = event;
end

--Text handling functions

function EventView:PrintOver(state, luaevent, args) --called by ESS scripts when printing is over after yielding
	ResumeEss();
end

function EventView:TextOut(value) --called by ESS scripts to output text
    self.dialogueWin:SetDialogueText(value);
    logManager:SetLine(value);
	YieldESS();
end

function EventView:Clear() --called by ESS scripts to clear text
    self.dialogueWin:ClearDialogueText();
end

function EventView:ESSOverHandler() --called by ESS scripts when entire script is over
	Trace("ESS Over!!!!")
    Trace("event view essover handler called!");
    CloseState()
    if (self.eventClosingEvent ~= nil) then
        self:eventClosingEvent();
    end
end

function EventView:Nar()
    self.dialogueWin:ClearDialogueName();
    self.dialogueWin:ClearPortraitTexture();
	logManager:SetName(nil);
end

function EventView:Name(name, portrait)
    self.dialogueWin:SetDialogueName(name);
    self.dialogueWin:SetPortraitTexture(portrait);
    
    logManager:SetName(name, portrait);
end

function EventView:CursorHandler(state, luaevent, args)
	local cursorSprite = GetComponent("cursor")
	--if (cursorSprite.Visible == false) then cursorSprite.Visible = true end
	cursorSprite.x = args[0] + 1;
	cursorSprite.y = args[1] + 1;
end

function EventView:HideCursor()
	local cursorSprite = GetComponent("cursor")
	cursorSprite.Visible = false;
end

function EventView:ShowCursor()
	local cursorSprite = GetComponent("cursor")
	cursorSprite.Visible = true;
end

function EventView:HideDialogue()
    self.dialogueWin:Hide();
end

function EventView:ShowDialogue()
    self.dialogueWin:Show();
end

function EventView:InitHandlers()
	CurrentState().KeyDown = function(handler, luaevent, args)
		Trace("key down : " .. args[0]);
		local code = args[0];
		if (code == 32) then --space
			self:Advance();
		end
	end
end

function EventView:InitComponents()
	local gamestate = CurrentState();
	self.gamestate = gamestate;
	--init font
	
	local dialogueWin = DialogueWindow:New("dialogueWin", self.gamestate);
	self.dialogueWin = dialogueWin;
	dialogueWin:Init();
	dialogueWin.frame.relative = true;
	dialogueWin.frame.x = 0;
	dialogueWin.frame.y = GetHeight() - dialogueWin.frame.height;
    dialogueWin:SetDialogueOverEvent(self.PrintOver);

end

function EventView:DoEvent(script)
    if (script ~= nil) then
		--log date
		logManager:SetDate(calendar:GetYear(), calendar:GetMonth(), calendar:GetWeek());
		
        BeginESS(script);
    end
end

function EventView:Advance()
	self.dialogueWin:Advance();
end