LoadScript("init_sound.lua")
LoadScript("init_csv.lua")
LoadScript("init_font.lua");
LoadScript("init_masterdata.lua")
LoadScript("init_global_functions.lua");



--test code
function prologue()
	Event("resources/event/nightmare.ess");
end

OpenState("title", "intro/titlestate.lua");