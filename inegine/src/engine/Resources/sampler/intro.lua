--GUI initialization


--Text handling functions

function this.PrintOver(state, luaevent, args) --called by ESS scripts when printing is over after yielding
	ResumeEss();
end

function this.TextOut(value) --called by ESS scripts to output text
	if(GetComponent("textwindow"):Print(value)) then
		Trace "yielding because not over "
		YieldESS();
	else
		Trace "not yielding because over"
	end
end

function this.Clear() --called by ESS scripts to clear text
	GetComponent("textwindow"):Clear();
end

function this.ESSOverHandler() --called by ESS scripts when entire script is over
	Trace("ESS Over!!!!")
	--GetComponent("testButton2").Enabled = true;
end

function this.Name(name)
	GetComponent("textwindow"):GetComponent("namewindow").Text = name;
end

function this.CursorHandler(state, luaevent, args)
	local cursorSprite = GetComponent("cursor")
	--if (cursorSprite.Visible == false) then cursorSprite.Visible = true end
	cursorSprite.x = args[0] + 1;
	cursorSprite.y = args[1] + 1;
end

function this.HideCursor()
	local cursorSprite = GetComponent("cursor")
	cursorSprite.Visible = false;
end

function this.ShowCursor()
	local cursorSprite = GetComponent("cursor")
	cursorSprite.Visible = true;
end

function this.InitComponents()
	local gamestate = CurrentState();
	
	--init font
	LoadFont("default", "Resources\\sampler\\fonts\\NanumGothicBold.ttf", 17);
	--LoadFont("default", "c:\\windows\\fonts\\gulim.ttc", 12, "c:\\windows\\fonts\\gulim.ttc", 10) --ruby font
	GetFont("default").LineSpacing = 10;
	GetFont("default").TextEffect = 1;
	
	LoadFont("small", "Resources\\sampler\\fonts\\NanumMyeongjoBold.ttf", 15);
	--LoadFont("small", "c:\\windows\\fonts\\meiryo.ttc", 15);
	GetFont("small").LineSpacing = 10;
	GetFont("small").TextEffect = 0;
	
	
    local anis = AnimatedSprite();
	anis.Name = "cursor"
	anis.Texture = "Resources/sampler/resources/cursor.png"
	anis.Width = 32;
	anis.Height = 48;
	anis.Rows = 4;
	anis.Cols = 4;
	anis.Layer = 10;
	anis.Visible = false
	InitComponent(anis);
	anis:Begin(100, 0, 2, true) --start animation
	
	--set cursor handler
	gamestate.MouseMove = this.CursorHandler;
	HideWinCursor()
	
	--create text window
	local win = ImageWindow()
	win.Name = "textwindow"
	win.Alpha = 155
	win.Width = 760
	win.Height = 200
	win.x = (GetWidth() - win.Width) / 2;
	win.y = GetHeight() - win.Height - 20;
	win.Layer = 5
	win.LineSpacing = 20
	win.PrintOver = PrintOver
	win.MouseClick =
        function(window, luaevent, args)	
	        Trace("click!")
            window:AdvanceText();
        end;
	win.Visible = false
	win.WindowTexture = "Resources/sampler/resources/win.png"
	win.Font = GetFont("default")
	win.Cursor = AnimatedSprite();
		win.Cursor.Name = "newcursor"
		win.Cursor.Texture = "Resources/sampler/resources/cursor.png"
		win.Cursor.Width = 32;
		win.Cursor.Height = 48;
		win.Cursor.Rows = 4;
		win.Cursor.Cols = 4;
		win.Cursor.Layer = 10;
		win.Cursor.Visible = true
	win.Margin = 45;
	win.LeftMargin = 20;
	InitComponent(win)

	--a small window for displaying character name in text window...
	local namewin = Button()
	namewin.Name = "namewindow"
	--namewin.Texture = "Resources/sampler/resources/button.png"	
	namewin.Alpha = 255
	namewin.Width = 150
	namewin.Height = 40
	namewin.Relative = true
	namewin.x = 10;
	namewin.y = 5;
	namewin.Layer = 6
	--namewin.LineSpacing = 20
	namewin.Visible = true
	namewin.Font = GetFont("small")
	--namewin.Text = "Sampler:"
	namewin.TextColor = 0xFFFFFF
	namewin.Alignment = 0
	win:AddComponent(namewin)	

	local button = Button()
	button.Name = "skipbutton"
	button.Texture = "Resources/sampler/resources/button.png"	
	button.Alpha = 255
	--button.Width = 150
	button.Height = 40
	button.Relative = true
	button.x = win.width - 374;
	button.y = win.height - 40;
	button.Layer = 6
	--namewin.LineSpacing = 20
	button.Visible = true
	button.Font = GetFont("small")
	button.Text = "SKIP"
	button.TextColor = 0xFFFFFF
	button.Alignment = 1
	win:AddComponent(button)	

	--a small window for displaying character name in text window...
	local button = Button()
	button.Name = "autobutton"
	button.Texture = "Resources/sampler/resources/button.png"	
	button.Alpha = 255
	button.Height = 40
	button.Relative = true
	button.x = win.width - 252;
	button.y = win.height - 40;
	button.Layer = 6
	--namewin.LineSpacing = 20
	button.Visible = true
	button.Font = GetFont("small")
	button.Text = "AUTO"
	button.TextColor = 0xFFFFFF
	button.Alignment = 1
	win:AddComponent(button)	

	--a small window for displaying character name in text window...
	local button = Button()
	button.Name = "logbutton"
	button.Texture = "Resources/sampler/resources/button.png"	
	button.Alpha = 255
	button.Height = 40
	button.Relative = true
	button.x = win.width - 130;
	button.y = win.height - 40;
	button.Layer = 6
	--namewin.LineSpacing = 20
	button.Visible = true
	button.Font = GetFont("small")
	button.Text = "LOG..."
	button.TextColor = 0xFFFFFF
	button.Alignment = 1
	win:AddComponent(button)	


end

this.InitComponents()
--this.ESSOverHandler = this.ESSOverTest;
BeginESS("Resources/sampler/intro.ess");
--GetComponent("textwindow"):Print("hi!");
--name("Sampler:")