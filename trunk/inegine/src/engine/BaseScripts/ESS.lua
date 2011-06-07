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
		Error "ESS interface undefined!"
		return
	end
	
	--save for debug
	scriptName = script;
	translatedScript = LoadESS(script);
	
	if (translatedScript == nil) then
		Error("ESScript execution error : " .. script);
		ESSOver()
		CloseState();
		return;
	end
	
	local func, msg = loadstring(translatedScript);
	
	if (func == nil) then
		if (msg ~= nil) then
			Error("ESScript execution error : " .. script);
			if (type(msg) == "userdata") then
				Error(msg:toString());
			elseif (type(msg) == "string") then
				Error(msg);
			end
		end
		ESSOver()
		CloseState();
		return;
	end
	
	local co = coroutine.create(func)
	if (CurrentState().state == nil) then
		CurrentState().state = {};
	end
	CurrentState().state["ess_path"] = script;
	CurrentState().state["ess"] = co;
	ResumeEss();
end

function TraceEss()
	if (scriptName ~= nil and translatedScript ~= nil) then
		Trace("[ESScript] : " .. scriptName);
		Trace(translatedScript);
	end
end

-- todo: need more elaborate error tracking system...
function ResumeEss()
	if (true ~= EssOver and CurrentState().state ~= nil and CurrentState().state["ess"] ~= nil) then
		local success, msg = coroutine.resume(CurrentState().state["ess"])
		if (success == false) then
            Error("error at " .. CurrentState().state["ess_path"] .. ":" .. currentLine)
            Error("(" .. EssLine(CurrentState().state["ess_path"], currentLine) .. ")")	
            if (msg ~= nil) then
				if (type(msg) == "userdata") then
					Error(msg:toString());
				elseif (type(msg) == "string") then
					Error(msg);
				end
            end
			ESSOver()
		end
	end
end

function YieldESS()
	Info("yielding (line:" .. currentLine .. ")");
	coroutine.yield();
end

 
--used to supress ESS over event when loading another ESS script  
--from ESS script by exiting current ESS script and executing another
SupressESSOver = false;
EssOver = false;
function ESSOver()
	Info("ESSOver called");
    EssOver = true;
	if (SupressESSOver) then
		Info("...ignoring ESSOver");
		SupressESSOver = false;
		return
	end
	return ESSOverHandler()
end

-- ESS text handling functions (used in string literals...)
function PrintOver(state, luaevent, args) --called by ESS scripts when printing is over after yielding
	ESSEventHandler:PrintOver(state, luaevent, args)
end

function TextOut(value) --called by ESS scripts to output text
	if (value ~= nil and value ~= "") then
		ESSEventHandler:TextOut(value)
	end
end

function Clear() --called by ESS scripts to clear text
	ESSEventHandler:Clear();
end

function ESSOverHandler() --called by ESS scripts when entire script is over
	if (ESSEventHandler ~= nil) then 
		ESSEventHandler:ESSOverHandler()
    end
end

function Wait(delay)
	Delay(delay, function() ResumeEss() end)
	coroutine.yield();
end

function wait(delay)
	Wait(delay)
end
AddESSCmd("wait");

function rand()
	return math.random() ;
end
AddESSCmd("rand");

--sound functions
function playbgm(id)
	if (currentbgm ~= nil) then
		currentbgm:Stop()
	end
	
	if (id ~= nil) then
		currentbgm = GetSound(id)
	end
	
	if (currentbgm ~= nil) then
		currentbgm:Play()
	end
end
AddESSCmd("playbgm");

function stopbgm(delay)
	if (currentbgm ~= nil) then
		if (delay ~= nil) then
			currentbgm:FadeOut(delay)
		else
			currentbgm:Stop()
		end
	end
	currentbgm = nil;
end
AddESSCmd("stopbgm");

function play(id)
	local sound = GetSound(id)
	if (sound ~=nil) then
		sound:Play()
	else
		Error("playing invalid sfx: " .. id);
	end
end
AddESSCmd("play");


function vol(id, vol)
	local sound = GetSound(id)
	if (sound ~= nil) then
		sound.Volume = vol;
	else
		Error("invalid id: " .. id);
	end
end
AddESSCmd("vol");

function sysvol(vol)
	SetVolume(vol);
end
AddESSCmd("sysvol");

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