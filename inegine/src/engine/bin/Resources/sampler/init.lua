LoadScript("init_sound.lua")
LoadScript("init_csv.lua")
LoadScript("init_font.lua");
LoadScript("init_masterdata.lua")
LoadScript("init_global_functions.lua");



--test code
--main:OpenEvent("resources/event/testevent.ess",
function test()
	Event("resources/event/testevent.ess");
end

function prologue()
	Event("resources/event/prologue.ess");
end

OpenState("title", "intro/titlestate.lua");