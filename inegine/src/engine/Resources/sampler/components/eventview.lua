LoadScript "Resources\\sampler\\components\\dialoguewindow.lua"

--GUI initialization

EventView = {}

function EventView:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self

    self:InitComponents()
   
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

function EventView:Name(name)
    self.dialogueWin:SetDialogueName(name);
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

function EventView:Portrait(image)
    self.dialogueWin:SetPortraitTexture(image)
end

function EventView:InitComponents()
	local gamestate = CurrentState();
	self.gamestate = gamestate;
	--init font
	LoadFont("default", "Resources\\sampler\\resources\\fonts\\NanumGothicBold.ttf", 17);
	--LoadFont("default", "c:\\windows\\fonts\\gulim.ttc", 12, "c:\\windows\\fonts\\gulim.ttc", 10) --ruby font
	GetFont("default").LineSpacing = 10;
	GetFont("default").TextEffect = 1;
	
	LoadFont("small", "Resources\\sampler\\resources\\fonts\\NanumMyeongjoBold.ttf", 15);
	--LoadFont("small", "c:\\windows\\fonts\\meiryo.ttc", 15);
	GetFont("small").LineSpacing = 10;
	GetFont("small").TextEffect = 0;
	
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
        BeginESS(script);
    end
end

function EventView:Advance()
	self.dialogueWin:Advance();
end