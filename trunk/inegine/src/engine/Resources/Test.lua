function InitComponents()
	local gamestate = CurrentState();
	LoadScene("bgimg", "Resources/daughterroom.png");
	LoadCharacter("musume", "Resources/after.png");
	ShowCharacter("musume", 1000);
	
	local anis = AnimatedSprite();
	anis.Name = "cursor"
	anis.Texture = "Resources/sprite.png"
	anis.Width = 32;
	anis.Height = 48;
	anis.Rows = 4;
	anis.Cols = 4;
	anis.Layer = 3;
	AddComponent(anis);	
	
	anis:Begin(100, 0, 4, true)
end

function LoadScene(id, image)
	local status, bgimg = pcall(SpriteBase);
	bgimg.Name = id
	bgimg.Texture = image
	bgimg.Visible = true;
	bgimg.Layer = 0;
	AddComponent(bgimg);
end

function LoadCharacter(id, image)
	local status, newCharacter = pcall(SpriteBase);
	if (status) then
		newCharacter.Name = id;
		newCharacter.Texture = image;
		newCharacter.X = (GetWidth() - newCharacter.Width)/2;
		newCharacter.Y = (GetHeight() - newCharacter.Height);
		newCharacter.Layer = 2;
		newCharacter.Visible = false;
		AddComponent(newCharacter);
		Trace("loading " .. id .. " done (" .. newCharacter.Width .. "," .. newCharacter.Height .. ")");
	else
		Trace("loading " .. id .. " failed");
	end
end

function ShowCharacter(id, delay)
	local component = GetComponent(id)
	if (component ~= nil) then
		component:LaunchTransition(delay, true) 
	else
		Trace("invalid id: " .. id);
	end
end

function HideCharacter(id, delay)
	local component = GetComponent(id)
	if (component ~= nil) then
		component:LaunchTransition(delay, false)	
	else
		Trace("invalid id: " .. id);
	end
end

function Dissolve(id1, id2)
	ShowCharacter(id2, 0)
	HideCharacter(id1, 500)
end

InitState("test");
InitComponents();