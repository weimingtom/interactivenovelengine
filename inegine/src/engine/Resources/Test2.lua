--GUI initialization


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
	button.Font = GetFont("default")
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
	button.Font = GetFont("default")
	button.TextColor = 0xEEEEEE
	
	InitComponent(button)


	local label = Label();
	label.Name = "testlabel"
	label.Alignment = 0
	label.VerticalAlignment = 0
	label.Layer = 3
	label.Margin = 10
	label.X = 10;
	label.Y = 120;
	label.Width = 300;
	label.Height = 100;
	label.Text = "LABEL\nLABEL2";
	label.Font = GetFont("default")
	label.TextColor = 0x000000
	
	InitComponent(label)

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
	win.Font = GetFont("default")
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