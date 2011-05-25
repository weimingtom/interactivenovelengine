-- ESS lua module

function RegisterESSEventHandler(handler)
	ESSEventHandler = handler;
end

function UnregisterESSEventHandler()
	ESSEventHandler = nil;
end

-- lua functions for managing ESS execution (called by lua/ESS scripts)
function BeginESS(script)
    EssOver = false;
	if (ESSEventHandler == nil or ESSEventHandler.TextOut == nil or ESSEventHandler.Clear == nil) then
		Trace "ESS interface undefined!"
		return
	end
	Trace(script)
	local translatedScript = LoadESS(script);
	if (translatedScript == nil) then
		error("ESScript execution error");
	end
	local co = coroutine.create(assert(loadstring(translatedScript)))
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
            --Trace("error at " .. CurrentState().state["ess_path"] .. ":" .. currentLine)
            --Trace("(" .. EssLine(CurrentState().state["ess_path"], currentLine) .. ")")	
			ESSOver()
		end
	end
end

function YieldESS()
	Trace("----yielding!----");
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

-- ESS text handling functions (used in string literals...)
function PrintOver(state, luaevent, args) --called by ESS scripts when printing is over after yielding
	ESSEventHandler:PrintOver(state, luaevent, args)
end

function TextOut(value) --called by ESS scripts to output text
	ESSEventHandler:TextOut(value)
end

function Clear() --called by ESS scripts to clear text
	ESSEventHandler:Clear();
end

function ESSOverHandler() --called by ESS scripts when entire script is over
	if (ESSEventHandler ~= nil and ESSEventHandler.ESSOverHandler ~= nil) then 
		ESSEventHandler:ESSOverHandler()
    end
end

-- ESS function synonyms (called by ESS as functions i.e. "#loadscene "bgimg1", "Resources/daughterroom.png""

function wait(delay)
	Delay(delay, function() ResumeEss() end)
	coroutine.yield();
end
AddESSCmd("wait");

--sound functions

function play(id)
	GetSound(id):Play()
end
AddESSCmd("play");

function stop(id, delay)
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
AddESSCmd("stop");

function mute(delay)
	if (delay == nil) then
		delay = 0;
	end
	StopSounds(delay);
end
AddESSCmd("mute");

function vol(id, vol)
	local sound = GetResource(id)
	if (sound ~= nil) then
		sound.Volume = vol;
	else
		Trace("invalid id: " .. id);
	end
end
AddESSCmd("vol");

function sysvol(id, vol)
	SetVolume(vol);
end
AddESSCmd("sysvol");

---- for selection window
--function AddSelection(text)
	--CurrentState().state:AddSelection(text)
--end
--
--function ShowSelection()
	--CurrentState().state:ShowSelection()
--end
--
--function SelectionOver(index)
	--CurrentState().state:SelectionOver(index)
--end

--transition control functions

function foi(duration, color)
    FadeOutIn(duration, color);
end
AddESSCmd("foi");

function fo(duration, color)
	FadeOut(duration, color);
end
AddESSCmd("fo");

function fi(duration, color)
    FadeIn(duration, color);
end
AddESSCmd("fi");