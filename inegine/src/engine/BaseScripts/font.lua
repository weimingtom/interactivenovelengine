-- ESS font manager module

function LoadFont(alias, path, size, rubyPath, rubySize)
	if (rubyPath ~= nil) then
		FontManager():LoadFont(alias, path, size, rubyPath, rubySize)
	else
		FontManager():LoadFont(alias, path, size)
	end
end


function GetFont(alias)
	return FontManager():GetFont(alias);
end