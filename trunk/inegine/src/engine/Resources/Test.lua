function LoadScene(id, image)
	local gameState = CurrentState();
	local status, bgimg = pcall(SpriteBase);
	bgimg.Name = id
	bgimg.Texture = image
	bgimg.Visible = false;
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

function Show(id, delay)
	local component = GetComponent(id)
	if (component ~= nil) then
		component:LaunchTransition(delay, true) 
	else
		Trace("invalid id: " .. id);
	end
end

function Hide(id, delay)
	local component = GetComponent(id)
	if (component ~= nil) then
		component:LaunchTransition(delay, false)	
	else
		Trace("invalid id: " .. id);
	end
end

function Dissolve(id1, id2)
	local first = GetComponent(id1)
	local second = GetComponent(id2)
	
	if (second.Layer > first.Layer) then
		local swap = first.Layer
		first.Layer = second.Layer
		second.Layer = swap
	elseif(second.Layer == first.Layer) then
		first.Layer = first.Layer + 1
	end
	--Trace(first.Layer .. " vs " .. second.Layer)
	Show(id2, 0)
	Hide(id1, 500)
end

function PrintOver(state, luaevent, args)
	ResumeEss();
end

function TextOut(value)
	if(GetComponent("testwindow"):Print(value)) then
		Trace "yielding because not over "
		YieldESS();
	else
		Trace "not yielding because over"
	end
end

function Clear()
	GetComponent("testwindow"):Clear();
end

function MouseClick(window, luaevent, args)	
	Trace("click!")
    window:AdvanceText();
    --PlaySound("click", false);
    --state:BeginNarrate("Hello world, test\ntest test test3", 100);
end;

function CursorHandler(state, luaevent, args)
	local cursorSprite = GetComponent("cursor")
	cursorSprite.x = args[0] + 1;
	cursorSprite.y = args[1] + 1;
end

function InitComponents()
	local gamestate = CurrentState();
	
	gamestate.MouseMove = CursorHandler;
	
	local anis = AnimatedSprite();
	anis.Name = "cursor"
	anis.Texture = "Resources/sprite.png"
	anis.Width = 32;
	anis.Height = 48;
	anis.Rows = 4;
	anis.Cols = 4;
	anis.Layer = 3;
	AddComponent(anis);	
	
	local win = ImageWindow()
	win.Name = "testwindow"
	win.Alpha = 155
	win.Width = 780
	win.Height = 200
	win.x = (GetWidth() - win.Width) / 2;
	win.y = GetHeight() - win.Height - 10;
	win.Layer = 100
	win.LineSpacing = 20
	win.PrintOver = PrintOver
	win.MouseClick = MouseClick
	win.Visible = true
	win.WindowTexture = "Resources/win.png"
	win.Font = Font("c:\\windows\\fonts\\gulim.ttc")
	win.Font.Size = 20;
	win.Font.LineSpacing = 10;
	win.Font.TextEffect = 0;
	AddResource(win.Font);	
	AddComponent(win)
	
	anis:Begin(100, 0, 4, true)
end

InitComponents();
counter = 0

Trace(GameTable["daughtet_name"]);

BeginESS("Resources/test.ess");