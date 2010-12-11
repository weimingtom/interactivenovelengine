-- ESS font manager module

function LoadCsv(alias, path)
	Trace("loading csv file!");
	local csvMan = CsvManager();
	if (csvMan ~= nil) then 
		local ok, ret_or_err = pcall(csvMan.LoadCsv, alias, path)
		if ok then
			Trace("???");
		else
			local info = DebugString();
			Trace(info .. ":" .. ret_or_err);
		end 
	else
		Trace("csv manager nil!");
	end
end

function GetCsv(alias)
	return CsvManager():GetCsv(alias);
end