--event state

LoadScript "components\\eventview.lua"

event = EventView:New(); --initialize event view using current state
CurrentState().state = event;
event:DoEvent(argument);
event:SetEventClosingEvent(closingEvent);

