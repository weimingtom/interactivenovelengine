function LoadCsv(alias, path, encoding)
	try(function() CsvManager():LoadCsv(alias, path, encoding) end, "loading csv failed");
end

function GetCsv(alias)
	if (try(function() res = CsvManager():GetCsv(alias) end, "retrieving csv failed")) then
		return res;
	else
		return nil;
	end
end