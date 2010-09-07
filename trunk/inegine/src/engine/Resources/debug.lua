--GUI initialization

function this.InitComponents()	

	LoadFont("default", "c:\\windows\\fonts\\gulim.ttc", 17);
	--LoadFont("default", "c:\\windows\\fonts\\gulim.ttc", 12, "c:\\windows\\fonts\\gulim.ttc", 10) --ruby font
	GetFont("default").LineSpacing = 10;
	GetFont("default").TextEffect = 1;

	local testsprite = SpriteBase();
	testsprite.Name = "test"
	testsprite.Texture = "Resources/before.png"
	testsprite.Layer = 10;
	testsprite.Visible = false
	InitComponent(testsprite);


	local win = WindowBase()
	win.Name = "basewindow"
	win.Alpha = 155
	win.Width = 760
	win.Height = 200
	win.x = (GetWidth() - win.Width) / 2;
	win.y = GetHeight() - win.Height - 20;
	win.Layer = 5
	win.Visible = false
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


end

this.InitComponents()
