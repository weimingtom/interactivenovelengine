function save()
	saveManager:Save("debug_save", "save file for debugging");
end

function load()
	CloseStates();
	saveManager:Load("debug_save");
end