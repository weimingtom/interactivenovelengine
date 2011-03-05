-- ESS lua module

-- lua functions for managing ESS execution (called by lua/ESS scripts)
function BeginESS(script)
    EssOver = false;
    local currentState = CurrentState().state;
	if (currentState.TextOut == nil or currentState.Clear == nil) then
		Trace "ESS interface undefined!"
		return
	end
	Trace(script)
	Trace "trying to load another script..."
	local co = coroutine.create(assert(loadstring(LoadESS(script))))
	Trace "resuming!..."
	if (CurrentState().state == nil) then
		CurrentState().state = {};
	end
	CurrentState().state["ess_path"] = script;
	CurrentState().state["ess"] = co;
	ResumeEss();
end

-- todo: need more elaborate error tracking system...
function ResumeEss()
	if (true ~= EssOver and CurrentState().state ~= nil and CurrentState().state["ess"] ~= nil) then
		local success, msg = coroutine.resume(CurrentState().state["ess"])
		if (success == false) then
            Trace("error at " .. CurrentState().state["ess_path"] .. ":" .. currentLine)
            Trace("(" .. EssLine(CurrentState().state["ess_path"], currentLine) .. ")")	
			ESSOver()
		end
	end
end

function YieldESS()
	Trace "yielding..."
	coroutine.yield();
end

 
--used to supress ESS over event when loading another ESS script  
--from ESS script by exiting current ESS script and executing another
SupressESSOver = false;
EssOver = false;
function ESSOver()
	Trace("ESSOver called");
    EssOver = true;
	if (SupressESSOver) then
		Trace("...ignoring ESSOver");
		SupressESSOver = false;
		return
	end
	if (ESSOverHandler ~= nil) then
		Trace("...ESSOver!");
		return ESSOverHandler()
	end
end

function Wait(delay)
	Delay(delay, function() ResumeEss() end)
	coroutine.yield();
end


-- ESS text handling functions (used in string literals...)
function PrintOver(state, luaevent, args) --called by ESS scripts when printing is over after yielding
	CurrentState().state:PrintOver(state, luaevent, args)
end

function TextOut(value) --called by ESS scripts to output text
	CurrentState().state:TextOut(value)
end

function Clear() --called by ESS scripts to clear text
	CurrentState().state:Clear();
end

function ESSOverHandler() --called by ESS scripts when entire script is over
	if (CurrentState().state ~= nil) then
        CurrentState().state:ESSOverHandler()
    end
end

-- ESS function synonyms (called by ESS as functions i.e. "#LoadScene "bgimg1", "Resources/daughterroom.png""

-- for image handling
-- Scene & character managing functions

function LoadSound(id, path)
	try(function()
		local sound = Sound();
		sound.Name = id
		sound.FileName = path;
		sound.Loop = false;
		InitResource(sound)	
	end, "loading sound failed", 3);
end

function Load(id, image)
	local status, bgimg = pcall(SpriteBase);
	bgimg.Name = id
	bgimg.Texture = image
	bgimg.Visible = false;
	bgimg.Layer = 0;
	InitComponent(bgimg);
end

function LoadCharacter(id, image)
	local status, newCharacter = pcall(SpriteBase);
	if (status) then
		newCharacter.Name = id;
		newCharacter.Texture = image;
		newCharacter.X = (GetWidth() - newCharacter.Width)/2;
		newCharacter.Y = (GetHeight() - newCharacter.Height);
		newCharacter.Layer = 2;
		newCharacter.Visible = false;
		InitComponent(newCharacter);
		Trace("loading " .. id .. " done (" .. newCharacter.Width .. "," .. newCharacter.Height .. ")");
	else
		Trace("loading " .. id .. " failed");
	end
end

function Center(id)
	local component = GetComponent(id)
	if (component ~= nil) then
		component.X = (GetWidth() - component.Width)/2;
		component.Y = (GetHeight() - component.Height)/2;
	else
		Trace("invalid id: " .. id);
	end
end

function Play(id)
	local sound = GetResource(id)
	if (sound ~= nil) then	
		try(function()
			if (delay == nil) then
				sound:Play()
			end
		end, "playing sound " .. id  .. " failed", 3);
	else
		Trace("invalid id: " .. id);
	end
end

function Volume(id, vol)

	local sound = GetResource(id)
	if (sound ~= nil) then
		sound.Volume = vol;
	else
		Trace("invalid id: " .. id);
	end
end

function Stop(id, delay)
	local sound = GetResource(id)
	if (sound ~= nil) then
		if (delay == nil) then
			sound:Stop()
		else
			sound:Fadeout(delay)
		end 
	else
		Trace("invalid id: " .. id);
	end
end

function Show(id, delay)
	local component = GetComponent(id)
    if (delay == nil) then delay = 0; end
	if (component ~= nil) then
		component:LaunchTransition(delay, true) 
	else
		Trace("invalid id: " .. id);
	end
end

function Alpha(id, level)
	local component = GetComponent(id)
	if (component ~= nil) then
		component.Alpha = level 
	else
		Trace("invalid id: " .. id);
	end
end

function Hide(id, delay)
	local component = GetComponent(id)
    if (delay == nil) then delay = 0; end
	if (component ~= nil) then
		component:LaunchTransition(delay, false)	
	else
		Trace("invalid id: " .. id);
	end
end

function Dissolve(id1, id2)
	local first = GetComponent(id1)
	local second = GetComponent(id2)
	
	if (second.Layer > first.Layer) then
		local swap = first.Layer
		first.Layer = second.Layer
		second.Layer = swap
	elseif(second.Layer == first.Layer) then
		first.Layer = first.Layer + 1
	end
	--Trace(first.Layer .. " vs " .. second.Layer)
	Show(id2, 0)
	Hide(id1, 500)
end


-- for selection window

function AddSelection(text)
	CurrentState().state:AddSelection(text)
end

function ShowSelection()
	CurrentState().state:ShowSelection()
end

function SelectionOver(index)
	CurrentState().state:SelectionOver(index)
end

function Name(name, image)
	CurrentState().state:Name(name, image)
end

function Nar()
	CurrentState().state:Nar()
end

function HideCursor()
	CurrentState().state:HideCursor()
end

function ShowCursor()
	CurrentState().state:ShowCursor()
end

function HideDialogue()
	CurrentState().state:HideDialogue()
end

function ShowDialogue()
	CurrentState().state:ShowDialogue()
end

function FadeOutIn(duration, color)
    if color == nil then color = 0xFFFFFF end
    GetFader():FadeOutIn(GetWidth(), GetHeight(), duration, color);
end

function FadeOut(duration, color)
    if color == nil then color = 0xFFFFFF end
    GetFader():Fade(GetWidth(), GetHeight(), duration, false, color);
end

function FadeIn(duration, color)
    if color == nil then color = 0xFFFFFF end
    GetFader():Fade(GetWidth(), GetHeight(), duration, true, color);
end