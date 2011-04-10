function LoadSound(alias, path)
	try(function() SoundManager():LoadSound(alias, path) end, "loading sound failed");
end

function GetSound(alias)
	if (try(function() res = SoundManager():GetSound(alias) end, "retrieving sound failed")) then
		return res;
	else
		return nil;
	end
end

function StopSounds(duration)	
	try(function() SoundManager():Fade(duration) end, "stopping all sound failed");
end