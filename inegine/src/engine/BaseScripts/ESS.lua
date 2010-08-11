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
function LoadScene(id, image)
	this.LoadScene(id, image)
end

function LoadCharacter(id, image)
	this.LoadCharacter(id, image)
end

function Show(id, delay)
	this.Show(id, delay)
end

function Hide(id, delay)
	this.Hide(id, delay)
end

function Dissolve(id1, id2)
    this.Dissolve(id1, id2)
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
