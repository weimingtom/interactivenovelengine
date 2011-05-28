--Import
Room = {}

function Room:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self
		
	return o
end

function Room:SetSeason(season)

end

function Room:SetTime(time)

end

function Room:SetWallpaper(season, time, image)

end

function Room:GetWallpaper()

end