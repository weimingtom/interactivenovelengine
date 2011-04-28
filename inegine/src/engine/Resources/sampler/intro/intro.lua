--intro state

LoadScript "components\\eventview.lua"

intro = EventView:New();
CurrentState().state = intro;
intro:DoEvent(argument);

