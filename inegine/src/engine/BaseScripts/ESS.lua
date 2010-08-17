-- ESS lua module

-- lua functions for managing ESS execution (called by lua/ESS scripts)
function BeginESS(script)
	if (this.TextOut == nil or this.Clear == nil) then
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
	CurrentState().state["ess"] = co;
	ResumeEss();
end

-- todo: need more elaborate error tracking system...
function ResumeEss()
	if (CurrentState().state["ess"] ~= nil) then
		--Trace "resuming!..."
		local success, msg = coroutine.resume(CurrentState().state["ess"])
		if (success == false) then
			Trace "error in ESS - terminating!"
			Trace(msg)
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
function ESSOver()
	Trace("ESSOver called");
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
	this.PrintOver(state, luaevent, args)
end

function TextOut(value) --called by ESS scripts to output text
	this.TextOut(value)
end

function Clear() --called by ESS scripts to clear text
	this.Clear();
end

function ESSOverHandler() --called by ESS scripts when entire script is over
	this.ESSOverHandler()
end

-- ESS function synonyms (called by ESS as functions i.e. "#LoadScene "bgimg1", "Resources/daughterroom.png""

-- for image handling
-- Scene & character managing functions
function LoadScene(id, image)
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

function Show(id, delay)
	local component = GetComponent(id)
    if (delay == nil) then delay = 0; end
	if (component ~= nil) then
		component:LaunchTransition(delay, true) 
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
	this.AddSelection(text)
end

function ShowSelection()
	this.ShowSelection()
end

function SelectionOver(index)
	this.SelectionOver(index)
end
