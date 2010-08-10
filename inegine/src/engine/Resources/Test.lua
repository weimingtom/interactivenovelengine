
--Scene & character managing functions

function LoadScene(id, image)
	local gameState = CurrentState();
	local status, bgimg = pcall(SpriteBase);
	bgimg.Name = id
	bgimg.Texture = image
	bgimg.Visible = false;
	bgimg.Layer = 0;
	InitComponent(bgimg);
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
		InitComponent(newCharacter);
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


--Text handling functions

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
	if (cursorSprite.Visible == false) then cursorSprite.Visible = true end
	cursorSprite.x = args[0] + 1;
	cursorSprite.y = args[1] + 1;
end

--Selection handling

function AddSelection(text)
	selectionMenu:Add(text)
end

function ShowSelection()
	selectionMenu:Show()
	YieldESS()
end

function SelectionOver(index)
	selected = selectionMenu.SelectedIndex
	selectionMenu:Clear()
	ResumeEss()
end

--GUI initialization

function InitComponents()
	local gamestate = CurrentState();
	
	gamestate.MouseMove = CursorHandler;
	
	local defaultFont = Font("c:\\windows\\fonts\\gulim.ttc")
	defaultFont.Size = 20;
	defaultFont.LineSpacing = 10;
	defaultFont.TextEffect = 1;
	AddResource(defaultFont);	
	
	local anis = AnimatedSprite();
	anis.Name = "cursor"
	anis.Texture = "Resources/sprite.png"
	anis.Width = 32;
	anis.Height = 48;
	anis.Rows = 4;
	anis.Cols = 4;
	anis.Layer = 10;
	anis.Visible = false
	InitComponent(anis);
	
	local button = Button();
	button.Name = "testButton"
	button.Texture = "Resources/button.png"	
	button.Layer = 3
	button.X = 10;
	button.Y = 10;
	button.State = {}
	button.MouseDown = 
		function (button, luaevent, args)
			button.State["mouseDown"] = true
			button.Pushed = true
		end
	button.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				Trace("button click!")
				button.Pushed = false
				button.Enabled = false
				BeginESS("Resources/test.ess");
			end
		end
	button.Text = "스크립트";
	button.Font = defaultFont
	button.TextColor = 0xEEEEEE
	
	InitComponent(button)
	
	button = Button();
	button.Name = "testButton2"
	button.Texture = "Resources/button.png"	
	button.Layer = 3
	button.X = 10;
	button.Y = 65;
	button.State = {}
	button.MouseDown = 
		function (button, luaevent, args)
			button.State["mouseDown"] = true
			button.Pushed = true
		end
	button.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				Trace("button click!")
				button.Pushed = false
				if (SoundStarted) then
					SoundStarted = false
					GetResource("testsound"):Stop()
					button.Text = "OFF";
				else
					SoundStarted = true
					GetResource("testsound"):Play()
					button.Text = "ON";
				end
			end
		end
	button.Text = "OFF";
	button.Font = defaultFont
	button.TextColor = 0xEEEEEE
	
	InitComponent(button)
	
	button = Button();
	button.Name = "testButton4"
	button.Texture = "Resources/button.png"	
	button.Layer = 3
	button.X = 20 + button.Width;
	button.Y = 65;
	button.State = {}
	button.MouseDown = 
		function (button, luaevent, args)
			button.State["mouseDown"] = true
			button.Pushed = true
		end
	button.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				Trace("button click!")
				button.Pushed = false
				if (SoundStarted) then
					SoundStarted = false
					GetResource("testsound").Volume = 0;
                    button.Text = "OFF";
				else
					SoundStarted = true
					GetResource("testsound").Volume = 100;
					button.Text = "ON";
				end
			end
		end
	button.Text = "VOLUME";
	button.Font = defaultFont
	button.TextColor = 0xEEEEEE
	
	InitComponent(button)


	button = Button();
	button.Name = "testButton3"
	button.Texture = "Resources/button.png"	
	button.Layer = 3
	button.X = 10;
	button.Y = 120;
	button.State = {}
	button.MouseDown = 
		function (button, luaevent, args)
			button.State["mouseDown"] = true
			button.Pushed = true
		end
	button.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				Trace("button click!")
				button.Pushed = false
				selectionMenu:Clear()
				selectionMenu:Add("1. 집에 간다")
				selectionMenu:Add("2. 학교에 간다")
				selectionMenu:Add("3. 일본을 공격한다")
				selectionMenu:Show()
			end
		end
	button.Text = "ADD";
	button.Font = defaultFont
	button.TextColor = 0xEEEEEE

	InitComponent(button)

	button = Button();
	button.Name = "testButton5"
	button.Texture = "Resources/button.png"	
	button.Layer = 3
	button.X = 10;
	button.Y = 175;
	button.State = {}
	button.MouseDown = 
		function (button, luaevent, args)
			button.State["mouseDown"] = true
			button.Pushed = true
		end
	button.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				Trace("button click!")
			button.State["mouseDown"] = false
			button.Pushed = false
            LoadState("test2", "Resources/Test2.lua");
			end
		end
	button.Text = "STATE 2";
	button.Font = defaultFont
	button.TextColor = 0xEEEEEE

	InitComponent(button)
	
	button = Button();
	button.Name = "testButton6"
	button.Texture = "Resources/button.png"	
	button.Layer = 3
	button.X = 20 + button.Width;
	button.Y = 175;
	button.State = {}
	button.MouseDown = 
		function (button, luaevent, args)
			button.State["mouseDown"] = true
			button.Pushed = true
		end
	button.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				Trace("button click!")
			button.State["mouseDown"] = false
			button.Pushed = false
            SwitchState("test2");
			end
		end
	button.Text = "SWITCH";
	button.Font = defaultFont
	button.TextColor = 0xEEEEEE

	InitComponent(button)
	

	local win = ImageWindow()
	win.Name = "testwindow"
	win.Alpha = 155
	win.Width = 780
	win.Height = 200
	win.x = (GetWidth() - win.Width) / 2;
	win.y = GetHeight() - win.Height - 10;
	win.Layer = 5
	win.LineSpacing = 20
	win.PrintOver = PrintOver
	win.MouseClick = MouseClick
	win.Visible = false
	win.WindowTexture = "Resources/win.png"
	win.Font = defaultFont
	win.Cursor = AnimatedSprite();
	win.Cursor.Name = "cursor"
	win.Cursor.Texture = "Resources/sprite.png"
	win.Cursor.Width = 32;
	win.Cursor.Height = 48;
	win.Cursor.Rows = 4;
	win.Cursor.Cols = 4;
	win.Cursor.Layer = 10;
	win.Cursor.Visible = true
	InitComponent(win)
	
	anis:Begin(100, 0, 4, true)
	
	local sound = Sound("Resources/test.mid")	
	--local sound = Sound("Resources/MusicMono.wav")
	--local sound = Sound("Resources/Track02.mp3")	
    sound.Name = "testsound"
	sound.Volume = 50
    sound.Loop = true;
	AddResource(sound)
	
	selectionMenu = Selector:New("selector", defaultFont)
	selectionMenu.Layer = 6
	selectionMenu.Width = 640
	selectionMenu.SelectionHeight = 70
	selectionMenu.MouseClick = 
		function()
			Trace("selected: " .. selectionMenu.SelectedIndex)
			SelectionOver(selectionMenu.SelectedIndex)
		end
end

function ESSOverHandler()
	Trace("ESS Over!!!!")
	local gamestate = CurrentState();
	GetComponent("testButton").Enabled = true;
end

InitComponents()

--state global variables
selected = -1
counter = 0
SoundStarted = false

Trace("State 1!");
Trace(GameTable["daughtet_name"]);