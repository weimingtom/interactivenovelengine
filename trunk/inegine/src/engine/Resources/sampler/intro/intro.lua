--intro state

LoadScript "Resources\\sampler\\components\\eventview.lua"

intro = EventView:New();
CurrentState().state = intro;
intro:DoEvent(argument);

