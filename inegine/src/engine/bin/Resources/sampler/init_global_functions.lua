function OpenEvent(eventScript, closingEvent)
	Info("executing event: " .. eventScript);
	if (closingEvent == nil) then
		closingEvent = 
		function()     
			FadeIn(1000)
		end
	end
    OpenState("event", "event/eventstate.lua", eventScript, closingEvent);
end

--set global actions
function Event(event)
	OpenEvent(event);
end