--GUI initialization
function CursorHandler(state, luaevent, args)
	local cursorSprite = GetComponent("cursor")
	if (cursorSprite.Visible == false) then cursorSprite.Visible = true end
	cursorSprite.x = args[0] + 1;
	cursorSprite.y = args[1] + 1;
end

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
	button.Text = "´Ý±â";
	button.Font = defaultFont
	button.TextColor = 0xEEEEEE
	
	InitComponent(button)
end

function this.Test()
    Trace("state2 test!");
end

InitComponents()
this.Test()
Trace("State 2!");