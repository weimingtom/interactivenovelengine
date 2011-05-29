--event state
LoadScript "components\\dialoguewindow.lua"
LoadScript "components\\selector.lua"

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

function EventView:InitComponents()
	local gamestate = CurrentState();
	self.gamestate = gamestate;
	
	local background = FadingSprite();
	self.background = background;
	self.background.BackgroundColor = 0x000000
	self.background.layer = 1
	AddComponent(background);
	
	self.tachie = {};
	self.tachie[0] = Tachie()
	self.tachie[0].Name = "tachie0";
	self.tachie[0].layer = 5
	self.tachie[0].Position = 0.5;
	self.tachie[0]:Hide();
	AddComponent(self.tachie[0]);
	
	self.tachie[1] = Tachie()
	self.tachie[1].Name = "tachie1";
	self.tachie[1].layer = 5
	self.tachie[1].Position = 0.25;
	self.tachie[1]:Hide();
	AddComponent(self.tachie[1]);
	
	self.tachie[2] = Tachie()
	self.tachie[2].Name = "tachie2";
	self.tachie[2].layer = 5
	self.tachie[2].Position = 0.75;
	self.tachie[2]:Hide();
	AddComponent(self.tachie[2]);
		
	local cg = FadingSprite();
	self.cg = cg;
	self.cg.Width = GetWidth();
	self.cg.Height = GetHeight();
	self.cg.layer = 7
	self.cg:Hide();
	AddComponent(cg);
	
	local dialogueWin = DialogueWindow:New("dialogueWin", self.gamestate);
	self.dialogueWin = dialogueWin;
	dialogueWin:Init();
	dialogueWin.frame.relative = true;
	dialogueWin.frame.x = 0;
	dialogueWin.frame.y = GetHeight() - dialogueWin.frame.height;
	dialogueWin.frame.layer = 10;
    dialogueWin:SetDialogueOverEvent(self.PrintOver);
    
    
	self.selector = Selector:New("selector", CurrentState());
	self.selector:Init();
	self.selector:SetMouseClick(
	function()
		self.selector:Hide();
		ResumeEss();
	end);
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
    if (logManager ~= nil) then logManager:SetLine(value); end
	YieldESS();
end

function EventView:Clear() --called by ESS scripts to clear text
    self.dialogueWin:ClearDialogueText();
end

function EventView:ESSOverHandler() --called by ESS scripts when entire script is over
    if (self.eventClosingEvent ~= nil) then
        self:eventClosingEvent();
    end
end

function EventView:Nar()
    self.dialogueWin:ClearDialogueName();
    self.dialogueWin:ClearPortraitTexture();
    if (logManager ~= nil) then
		logManager:SetName(nil);
	end
end

function EventView:Name(name, portrait)
    self.dialogueWin:SetDialogueName(name);
    if (portrait ~= nil) then
		self.dialogueWin:SetPortraitTexture(portrait);
    end
    
    if (logManager ~= nil) then
		logManager:SetName(name, portrait);
	end
end

function EventView:CursorHandler(state, luaevent, args)
	local cursorSprite = self.cursor;
	if (cursor ~= nil) then
		cursorSprite.x = args[0] + 1;
		cursorSprite.y = args[1] + 1;
	end
end

function EventView:HideCursor()
	local cursorSprite = self.cursor;
	if (cursor ~= nil) then
		cursorSprite.Visible = false;
	end
end

function EventView:ShowCursor()
	local cursorSprite = self.cursor;
	if (cursor ~= nil) then
		cursorSprite.Visible = true;
	end
end

function EventView:HideDialogue()
    self.dialogueWin:Hide();
end

function EventView:ShowDialogue()
    self.dialogueWin:Show();
end

function EventView:InitHandlers()
	CurrentState().KeyDown = function(handler, luaevent, args)
		local code = args[0];
		if (code == 32) then --space
			self:Advance();
		end
	end
end

function EventView:DoEvent(script)
    if (script ~= nil) then
		--log date		
        BeginESS(script);
    end
end

function EventView:Advance()
	self.dialogueWin:Advance();
end

function EventView:SetBackground(image, delay)
	self.background:Show();
	self.background.FadeTime = delay;
	self.background.texture = image;
end

function EventView:SetTachie(index, body, dress)
	assert(index < 3 and index >= 0, "wrong tachie index");
	self.tachie[index].BodyTexture = body;
	self.tachie[index].DressTexture = dress;
end

function EventView:SetTachiePosition(index, position)
	assert(index < 3 and index >= 0, "wrong tachie index");
	if (position ~= nil) then
		self.tachie[index].Position = position;
	end
end



function EventView:HideTachie(index, delay)
	assert(index < 3 and index >= 0, "wrong tachie index");
	if (delay == nil) then
		self.tachie[index]:Hide();
	else
		self.tachie[index]:FadeOut(delay);	
	end
end

function EventView:ShowTachie(index, delay)
	assert(index < 3 and index >= 0, "wrong tachie index");
	if (delay == nil) then
		self.tachie[index]:Show();
	else
		self.tachie[index]:FadeIn(delay);	
	end
end

function EventView:SetCG(image, delay)
	self.cg:Show();
	self.cg.FadeTime = delay;
	self.cg.texture = image;
end

function EventView:HideCG(delay)
	if (delay ~= nil) then
		self.cg:FadeOut(delay);
	else
		self.cg:Hide();
	end
end

function EventView:AddSelection(text)
	self.selector:Add(text);
end

function EventView:AskSelection(question)
	self.selector:Ask(question);
	self.selector:Show();
	YieldESS();
end

function EventView:GetSelectionResult()
	return self.selector:GetSelected();
end

event = EventView:New(); --initialize event view using current state

--dialogue control functions
function name(name, image)
	event:Name(name, image)
end
AddESSCmd("name");

function nar()
	event:Nar()
end
AddESSCmd("nar");

function hd()
	event:HideDialogue()
end
AddESSCmd("hd");

function sd()
	event:ShowDialogue()
end
AddESSCmd("sd");

--cursor control functions
function hc()
	event:HideCursor()
end
AddESSCmd("hc");

function sc()
	event:ShowCursor()
end
AddESSCmd("sc");

--gfx functions
function bg(image, delay)
	event:SetBackground(image, delay);	
end
AddESSCmd("bg");

function cg(image, delay)
	event:SetCG(image, delay);	
end
AddESSCmd("cg");

function hcg(delay)
	event:HideCG(delay);	
end
AddESSCmd("hcg");

function ld(index, body, dress)
	if (body ~= nil and dress ~= nil) then
		event:SetTachie(index, body, dress);
	end
end
AddESSCmd("ld");

function pl(index, position)
	event:SetTachiePosition(index, position);
end
AddESSCmd("pl");

function cl(pos, delay)
	event:HideTachie(pos, delay);
end
AddESSCmd("cl");

function sl(pos, delay)
	event:ShowTachie(pos, delay);
end
AddESSCmd("sl");

function sel(text)
	event:AddSelection(text);
end
AddESSCmd("sel");

function ask(text)
	event:AskSelection(text);
end
AddESSCmd("ask");

function selres()
	return event:GetSelectionResult();
end
AddESSCmd("selres");

RegisterESSEventHandler(event);
event:DoEvent(argument);
event:SetEventClosingEvent(closingEvent);
