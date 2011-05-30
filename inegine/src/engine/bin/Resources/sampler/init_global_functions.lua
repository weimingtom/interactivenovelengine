function OpenEvent(eventScript, closingEvent)
	Info("executing event: " .. eventScript);
	if (closingEvent == nil) then
		closingEvent = 
		function()
			FadeIn(1000);
			CloseState();  
		end
	end
	OpenState("event", "event/eventstate.lua", eventScript, closingEvent)
end

--ess functions
function openevent(script)
	OpenEvent(script);
end
AddESSCmd("openevent");

function opening()
	CloseStates();
	openevent("resources/event/opening.ess");
end
AddESSCmd("opening");

function prologue()
	FadeOut(1000)
	Delay(1000, 
		function()
			CloseStates();
			openevent("resources/event/prologue.ess");
		end)
end
AddESSCmd("prologue");

function charmake()
	CloseStates();
	OpenState("character making", "intro/makingstate.lua");
end
AddESSCmd("charmake");

function startgame()
	CloseStates();
	LoadScript("startgame.lua");
end
AddESSCmd("startgame");

function title()
	CloseStates();
	OpenState("title", "intro/titlestate.lua");
end
AddESSCmd("title");

function startmain()
	CloseStates();
	OpenState("main", "main/main.lua");
end
AddESSCmd("startmain");