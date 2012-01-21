-- ESS lua module

function RegisterESSEventHandler(handler)
	ESSEventHandler = handler;
end

function UnregisterESSEventHandler()
	ESSEventHandler = nil;
end

-- lua functions for managing ESS execution (called by lua/ESS scripts)
function BeginESS(script)
	currentLine = 0;
	currentCol = 0;
    
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
			Error("resuming script "  .. CurrentState().state["ess_path"] .. " failed");
            --Error("error at " .. CurrentState().state["ess_path"] .. ":" .. currentLine)
            --Error("(" .. EssLine(CurrentState().state["ess_path"], currentLine) .. ")")	
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
	if (CurrentState().state ~= nil and CurrentState().state["ess"] ~= nil) then
		Info("yielding (line:" .. currentLine .. ")");
		coroutine.yield();
	end
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
	if (ESSEventHandler ~= nil and ESSOverCanceled ~= true) then 
		ESSEventHandler:ESSOverHandler()
    end
    ESSOverCanceled = false;
end

function Wait(delay)
	Delay(delay, function() ResumeEss() end)
	coroutine.yield();
end

function wait(delay)
	Wait(delay)
end
AddESSCmd("wait");

function rand(max)
	if (max == nil) then
		return math.random();
	else
		return math.random(max);
	end
end
AddESSCmd("rand");

function updateBGMVolume()
	if (currentbgmId ~= nil) then
		local currentbgm = GetSound(currentbgmId)
		currentbgm.volume = bgmBaseVolume * optionManager:GetOption("bgmVolume") / 7
	end
end

--sound functions
function playbgm(id)
	if (id == nil) then
		return;
	end
	
	--return since bgm is already playing
	if (currentbgmId == id) then
		return;
	end
	
	if (currentbgmId ~= nil) then
		Info("stopping existing bgm : " .. currentbgmId);
		local currentbgm = GetSound(currentbgmId)
		if (currentbgm == nil) then
			Error("cannot find bgm " .. id .. " to play");
			error("cannot find bgm " .. id .. " to play")
		return;
	end
		currentbgm:Stop()
	else
		Info("not stopping existing bgm since it's null");
	end
	
	currentbgmId = id;
	local currentbgm = GetSound(id)
	if (currentbgm == nil) then
		currentbgmId = nil;
		Error("cannot find bgm " .. id .. " to play");
		error("cannot find bgm " .. id .. " to play")
		return;
	end
	Info("playing bgm : " .. id);
	
	Delay(500, function()
		 currentbgm.volume = bgmBaseVolume * optionManager:GetOption("bgmVolume") / 7;
		 currentbgm:Play(); 
		 currentbgm = nil; 
	end)

end
AddESSCmd("playbgm");

function stopbgm(delay)
	if (currentbgmId ~= nil) then
		local currentbgm = GetSound(currentbgmId)
		if (currentbgm == nil) then
			Error("cannot find " .. id .. " to stop");
			return;
		end
		Info("stopping current bgm : " .. currentbgmId);
		if (delay ~= nil) then
			currentbgm:FadeOut(delay)
		else
			currentbgm:Stop()
		end
		currentbgmId = nil;
		currentbgm = nil;
	else
		Error("current bgm is nil");
	end
end
AddESSCmd("stopbgm");

function play(id)
	local sound = GetSound(id)
	if (sound ~=nil) then
		sound.volume = effectBaseVolume * optionManager:GetOption("sfxVolume") / 7;
		sound:Play()
	else
		Error("playing invalid sfx: " .. id);
	end
end
AddESSCmd("play");

function stop(id)
	local sound = GetSound(id)
	if (sound ~=nil) then
		sound:Stop()
	else
		Error("stopping invalid sfx: " .. id);
	end
end
AddESSCmd("stop");

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