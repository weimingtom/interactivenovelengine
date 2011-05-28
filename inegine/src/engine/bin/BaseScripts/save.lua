function LoadString(path)
	if (try(function() res = LoadData(path) end, "loading string failed")) then
		return res;
	else
		return nil;
	end
end

function SaveString(data, path)
	try(function() SaveData(data, path) end, "saving string failed");
end