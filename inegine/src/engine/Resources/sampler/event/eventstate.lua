require "Resources\\sampler\\components\\eventview"

event = EventView:New();
CurrentState().state = event;
event:DoEvent(argument);
event:SetEventClosingEvent(closingEvent);

