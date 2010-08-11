--GUI initialization
-- Scene & character managing functions
function this.LoadScene(id, image)
	local status, bgimg = pcall(SpriteBase);
	bgimg.Name = id
	bgimg.Texture = image
	bgimg.Visible = false;
	bgimg.Layer = 0;
	InitComponent(bgimg);
end

function this.LoadCharacter(id, image)
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

function this.Show(id, delay)
	local component = GetComponent(id)
	if (component ~= nil) then
		component:LaunchTransition(delay, true) 
	else
		Trace("invalid id: " .. id);
	end
end

function this.Hide(id, delay)
	local component = GetComponent(id)
	if (component ~= nil) then
		component:LaunchTransition(delay, false)	
	else
		Trace("invalid id: " .. id);
	end
end

function this.Dissolve(id1, id2)
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
	this.Show(id2, 0)
	this.Hide(id1, 500)
end


--Text handling functions

function this.PrintOver(state, luaevent, args) --called by ESS scripts when printing is over after yielding
	ResumeEss();
end

function this.TextOut(value) --called by ESS scripts to output text
	if(GetComponent("testwindow"):Print(value)) then
		Trace "yielding because not over "
		YieldESS();
	else
		Trace "not yielding because over"
	end
end

function this.Clear() --called by ESS scripts to clear text
	GetComponent("testwindow"):Clear();
end

function this.ESSOverHandler() --called by ESS scripts when entire script is over
	Trace("ESS Over!!!!")
	GetComponent("testButton2").Enabled = true;
end


--etc...



function this.CursorHandler(state, luaevent, args)
	local cursorSprite = GetComponent("cursor")
	if (cursorSprite.Visible == false) then cursorSprite.Visible = true end
	cursorSprite.x = args[0] + 1;
	cursorSprite.y = args[1] + 1;
end

--Selection handling
function this.AddSelection(text)
	this.selectionMenu:Add(text)
end

function this.ShowSelection()
	this.selectionMenu:Show()
	YieldESS()
end

function this.SelectionOver(index)
	this.selected = this.selectionMenu.SelectedIndex
	this.selectionMenu:Clear()
	ResumeEss()
end




function InitComponents()
	local gamestate = CurrentState();
	
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
	
	gamestate.MouseMove =
        function(state, luaevent, args)
	        local cursorSprite = GetComponent("cursor")
	        if (cursorSprite.Visible == false) then cursorSprite.Visible = true end
	        cursorSprite.x = args[0] + 1;
	        cursorSprite.y = args[1] + 1;
        end;
	
	anis:Begin(100, 0, 4, true)

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

	anis:Begin(100, 0, 4, true)
	
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
				CloseState();
			end
		end
	button.Text = "닫기";
	button.Font = defaultFont
	button.TextColor = 0xEEEEEE
	
	InitComponent(button)

	local button = Button();
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
				button.Enabled = false
				BeginESS("Resources/test2.ess");
			end
		end
	button.Text = "스크립트";
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
	win.MouseClick =
        function(window, luaevent, args)	
	        Trace("click!")
            GetComponent("testwindow"):AdvanceText();
            --PlaySound("click", false);
            --state:BeginNarrate("Hello world, test\ntest test test3", 100);
        end;
	win.Visible = true
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
	

end

function this.Test()
    Trace("state2 test!");
end

InitComponents()
this.Test()
Trace("State 2!");