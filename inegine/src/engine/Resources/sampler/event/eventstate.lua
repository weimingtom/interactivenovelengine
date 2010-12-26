LoadScript "Resources\\sampler\\components\\eventview.lua"

event = EventView:New();
CurrentState().state = event;
CurrentState().KeyDown = function(handler, luaevent, args)
	Trace("key down : " .. args[0]);
	local code = args[0];
	if (code == 32) then --space
		event:Advance();
	end
end
event:DoEvent(argument);
event:SetEventClosingEvent(closingEvent);

