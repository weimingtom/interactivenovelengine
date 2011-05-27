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
	
	local background = SpriteBase();
	self.background = background;
	self.background.layer = 1
	AddComponent(background);
	
	self.tachie = Tachie()
	self.tachie.layer = 5
	self.tachie.Position = 0.5;
	self.tachie:Hide();
	AddComponent(self.tachie);
		
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
	Trace("[" .. value .. "]");
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

function EventView:SetBackground(image)
	self.background.texture = image;
end

function EventView:SetTachie(pos, body, dress)
	self.tachie.BodyTexture = body;
	self.tachie.DressTexture = dress;
end

function EventView:HideTachie(pos, delay)
	if (delay == nil) then
		self.tachie:Hide();
	else
		self.tachie:FadeOut(delay);	
	end
end

function EventView:ShowTachie(pos, delay)
	if (delay == nil) then
		self.tachie:Show();
	else
		self.tachie:FadeIn(delay);	
	end
end

function EventView:SetCG(image, delay)
	self.cg.texture = image;
	if (delay ~= nil) then
		self.cg:FadeIn(delay);
	else
		self.cg:Show();
	end
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
function bg(image)
	event:SetBackground(image);	
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

function ld(pos, body, dress)
	if (body ~= nil and dress ~= nil) then
		event:SetTachie(pos, body, dress);
	end
end
AddESSCmd("ld");

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

--game data related
function father()
	return Fathername();
end
AddESSCmd("father");

function lastname()
	return Lastname();
end
AddESSCmd("lastname");

function daughter()
	return Firstname();
end
AddESSCmd("daughter");

function stat(id, amount)
	if (id == nil) then
		--raise error?
		return -1;
	end

	if (amount == nil) then
		return GetStat(id);
	else
		SetStat(id, amount);
		return GetStat(id);
	end
end
AddESSCmd("stat");

function flag(id, value)
	if (id == nil) then
		--raise error?
		return false;
	end

	if (amount == nil) then
		return GetFlag(id);
	else
		SetFlag(id, value);
		return GetFlag(id);
	end
end
AddESSCmd("flag");

function itemget(id, count)
	ItemGet(id, count);
end
AddESSCmd("itemget");

function itemloss(id, count)
	ItemLoss(id, count);
end
AddESSCmd("itemloss");

function itemhas(id)
	ItemHas(id);
end
AddESSCmd("itemhas");



RegisterESSEventHandler(event);
event:DoEvent(argument);
event:SetEventClosingEvent(closingEvent);
