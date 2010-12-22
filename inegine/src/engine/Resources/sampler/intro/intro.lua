require "Resources\\sampler\\components\\eventview"

intro = EventView:New();
CurrentState().state = intro;
intro:DoEvent(argument);

