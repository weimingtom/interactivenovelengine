--Import
require "Resources\\sampler\\components\\inventory"

Main = {}

function Main:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self

    self:InitComponents()
   
	return o
end

--Component initialization
function Main:InitComponents()
    self:loadFonts();
	
	local gamestate = CurrentState();

	local datewin = ImageWindow()
	datewin.Name = "datedisplay"
	datewin.Alpha = 155
	datewin.Width = 100
	datewin.Height = 100
	datewin.x = 10;
	datewin.y = 10;
	datewin.Layer = 5
	datewin.LeftMargin = 20
	datewin.Margin = 15
	datewin.MouseClick =
        function(window, luaevent, args)	
	        Trace("datewindow clicked!")
        end;
	datewin.Visible = true
	datewin.WindowTexture = "Resources/sampler/resources/win.png"
	datewin.BackgroundColor = 0x3333CC
	
	datewin.Font = GetFont("date") --defaultFont
	InitComponent(datewin)
	
	local statewin = ImageWindow()
	statewin.Name = "statedisplay"
	statewin.Alpha = 155
	statewin.Width = 120
	statewin.Height = 100
	statewin.x = 112;
	statewin.y = 10;
	statewin.Layer = 5
	statewin.LeftMargin = 15
	statewin.Margin = 10
	statewin.MouseClick =
        function(window, luaevent, args)	
	        Trace("statewindow clicked!")
        end;
	statewin.Visible = true
	statewin.WindowTexture = "Resources/sampler/resources/win.png"
	statewin.BackgroundColor = 0x3399CC
	
	statewin.Font = GetFont("state") --defaultFont
	InitComponent(statewin)
	
	local menu = ImageWindow()
	menu.Name = "mainmenu"
	menu.Alpha = 155
	menu.Width = 250
	menu.Height = 42*4
	menu.X = 10;
	menu.Y = 135;
	menu.Layer = 5
	menu.LineSpacing = 20
	menu.Visible = true
	menu.Enabled = true
	menu.Font = GetFont("state")
	--menu.WindowTexture = "Resources/sampler/resources/win.png"
	menu.MouseLeave =
		function(selectionWindow, event, args)
		end
	AddComponent(menu)
	
	local button1 = Button()
	button1.Relative = true;
	button1.Name = "button1"
	button1.Texture = "Resources/sampler/resources/button.png"	
	button1.Layer = 3
	button1.X = 0;
	button1.Y = 0;
	button1.Width = 120;
	button1.Height = 40;
	button1.State = {}
	button1.MouseDown = 
		function (button1, luaevent, args)
			button1.State["mouseDown"] = true
			button1.Pushed = true
		end
	button1.MouseUp = 
		function (button1, luaevent, args)
			if (button1.State["mouseDown"]) then
				button1.Pushed = false
				Trace("button1 click!")
			end
		end
	button1.Text = "Schedule";
	button1.Font = GetFont("menu"); --defaultFont
	button1.TextColor = 0xEEEEEE;
	
	menu:AddComponent(button1);
	
	local button2 = Button()
	button2.Relative = true;
	button2.Name = "button2"
	button2.Texture = "Resources/sampler/resources/button.png"	
	button2.Layer = 3
	button2.X = 122;
	button2.Y = 42 * 0;
	button2.Width = 120;
	button2.Height = 40;
	button2.State = {}
	button2.MouseDown = 
		function (button2, luaevent, args)
			button2.State["mouseDown"] = true
			button2.Pushed = true
		end
	button2.MouseUp = 
		function (button2, luaevent, args)
			if (button2.State["mouseDown"]) then
				button2.Pushed = false
				Trace("button2 click!")
			end
		end
	button2.Text = "Talk";
	button2.Font = GetFont("menu"); --defaultFont
	button2.TextColor = 0xEEEEEE
	
	menu:AddComponent(button2);
	
	local button3 = Button()
	button3.Relative = true;
	button3.Name = "button3"
	button3.Texture = "Resources/sampler/resources/button.png"	
	button3.Layer = 3
	button3.X = 0;
	button3.Y = 42 * 1;
	button3.Width = 120;
	button3.Height = 40;
	button3.State = {}
	button3.MouseDown = 
		function (button3, luaevent, args)
			button3.State["mouseDown"] = true
			button3.Pushed = true
		end
	button3.MouseUp = 
		function (button3, luaevent, args)
			if (button3.State["mouseDown"]) then
				button3.Pushed = false
				Trace("button3 click!")
			end
		end
	button3.Text = "Status";
	button3.Font = GetFont("menu"); --defaultFont
	button3.TextColor = 0xEEEEEE
	
	menu:AddComponent(button3);
	
	local button4 = Button()
	button4.Relative = true;
	button4.Name = "button4"
	button4.Texture = "Resources/sampler/resources/button.png"	
	button4.Layer = 3
	button4.X = 122;
	button4.Y = 42 * 1;
	button4.Width = 120;
	button4.Height = 40;
	button4.State = {}
	button4.MouseDown = 
		function (button4, luaevent, args)
			button4.State["mouseDown"] = true
			button4.Pushed = true
		end
	button4.MouseUp = 
		function (button4, luaevent, args)
			if (button4.State["mouseDown"]) then
				button4.Pushed = false
				Trace("button4 click!")
				self:OpenInventory();
			end
		end
	button4.Text = "Inventory";
	button4.Font = GetFont("menu"); --menuFont
	button4.TextColor = 0xEEEEEE
	
	menu:AddComponent(button4);
	
	local button5 = Button()
	button5.Relative = true;
	button5.Name = "button5"
	button5.Texture = "Resources/sampler/resources/button.png"	
	button5.Layer = 3
	button5.X = 0;
	button5.Y = 42 * 2;
	button5.Width = 120;
	button5.Height = 40;
	button5.State = {}
	button5.MouseDown = 
		function (button5, luaevent, args)
			button5.State["mouseDown"] = true
			button5.Pushed = true
		end
	button5.MouseUp = 
		function (button5, luaevent, args)
			if (button5.State["mouseDown"]) then
				button5.Pushed = false
				Trace("button5 click!")
			end
		end
	button5.Text = "Shopping";
	button5.Font = GetFont("menu"); --menuFont
	button5.TextColor = 0xEEEEEE
	
	menu:AddComponent(button5);
	
	local button6 = Button()
	button6.Relative = true;
	button6.Name = "button6"
	button6.Texture = "Resources/sampler/resources/button.png"	
	button6.Layer = 3
	button6.X = 122;
	button6.Y = 42 * 2;
	button6.Width = 120;
	button6.Height = 40;
	button6.State = {}
	button6.MouseDown = 
		function (button6, luaevent, args)
			button6.State["mouseDown"] = true
			button6.Pushed = true
		end
	button6.MouseUp = 
		function (button6, luaevent, args)
			if (button6.State["mouseDown"]) then
				button6.Pushed = false
				Trace("button6 click!")
			end
		end
	button6.Text = "Goddess";
	button6.Font = GetFont("menu"); --menuFont
	button6.TextColor = 0xEEEEEE
	
	menu:AddComponent(button6);
	
	
	local button7 = Button()
	button7.Relative = true;
	button7.Name = "button7"
	button7.Texture = "Resources/sampler/resources/button.png"	
	button7.Layer = 3
	button7.X = 0;
	button7.Y = 42 * 3;
	button7.Width = 120;
	button7.Height = 40;
	button7.State = {}
	button7.MouseDown = 
		function (button7, luaevent, args)
			button7.State["mouseDown"] = true
			button7.Pushed = true
		end
	button7.MouseUp = 
		function (button7, luaevent, args)
			if (button7.State["mouseDown"]) then
				button7.Pushed = false
				Trace("button7 click!")
			end
		end
	button7.Text = "System";
	button7.Font = GetFont("menu"); --menuFont
	button7.TextColor = 0xEEEEEE
	
	menu:AddComponent(button7);
end

--public interface

--mainmenu
function Main:OpenSchedule()
end

function Main:OpenCommunication()
end

function Main:OpenStatus()
end

function Main:OpenShop()
end

function Main:OpenGoddess()
end

function Main:OpenSystem()
end

function Main:OpenInventory()
	self:ToggleMainMenu(false);
	local inven = Inventory:New("inventory", GetFont("default"), CurrentState());
	inven.frame.X = 10;
	inven.frame.Y = 135;
	inven:SetClosingEvent( 
		function()
			Trace("inventory clicked!")
			self.inventory:Dispose();
			self.inventory = nil;
			self:ToggleMainMenu(true);
			self:CenterTachie();
		end
	);
	
	self:SetTachiePosition(inven.frame.X + inven.frame.Width + 10);
	inven:Show();
	
	self.inventory = inven;
end

--datewindow
function Main:InvalidateDate()
	Main:SetDate(calendar:GetYear(), calendar:GetMonth(), calendar:GetDay(), calendar:GetWeek());
end
	
--statuswindow
function Main:InvalidateStatus()
	Main:SetState(character:GetFirstName(), character:GetLastName(), character:GetAge(), character:GetGold(),
				  character:GetStress(), character:GetMana());
end

--wallpaper
function Main:SetBackground(filename)
	if (GetComponent("background") ~= nil) then
		RemoveComponent("background");
	end
	
	local background = SpriteBase();
	background.Name = "background";
	background.Texture = filename
	background.Visible = true;
	background.Layer = 0;
	InitComponent(background);
end

--tachie
function Main:SetTachieBody(filename)
	if (GetComponent("tachie") ~= nil) then
		RemoveComponent("tachie");
	end
	
	local tachie = SpriteBase();
	tachie.Name = "tachie";
	tachie.Texture = filename
	tachie.Visible = true;
	tachie.X = (GetWidth() - tachie.Width)/2;
	tachie.Y = (GetHeight() - tachie.Height);
	tachie.Layer = 2;
	InitComponent(tachie);
end

function Main:SetTachieFace(filename)
end

function Main:SetTachieDress(filename)
end

function Main:SetTachiePosition(leftMargin)
	GetComponent("tachie").X = leftMargin;
end

function Main:CenterTachie()
	local tachie = GetComponent("tachie");
	tachie.X = (GetWidth() - tachie.Width)/2;
end

--private/helper functions
function Main:ToggleMainMenu(enabled)
	GetComponent("mainmenu").enabled = enabled;
	GetComponent("mainmenu").visible = enabled;
end

function Main:loadFonts()
	LoadFont("default", "Resources\\sampler\\fonts\\NanumGothicBold.ttf", 17);

	LoadFont("menu", "Resources\\sampler\\fonts\\NanumGothicBold.ttf", 18);
	GetFont("menu").TextEffect = 1
	
	LoadFont("date", "Resources\\sampler\\fonts\\NanumMyeongjoBold.ttf", 13);
	GetFont("date").LineSpacing = 13
	GetFont("date").TextEffect = 1

	LoadFont("state", "Resources\\sampler\\fonts\\NanumGothicBold.ttf", 12);
	GetFont("state").LineSpacing = 5
end

function Main:SetDate(year, month, day, week)
	GetComponent("datedisplay").text = year .. "\n" 
									   .. month .. " " .. day .. "\n"
									   .. "Week " ..  week;
end

function Main:SetState(firstname, lastname, age, gold, stress, mana)
	GetComponent("statedisplay").text = firstname .. " " 
										.. lastname .. "\nAge " .. age .. "\nGold "
										.. gold .. "\nStress " .. stress .. "%\nMana " .. mana .."%";
end


main = Main:New();
CurrentState().state = mainView;

--extra actions
main:InvalidateDate();
main:InvalidateStatus();

main:SetBackground("Resources/sampler/images/room01.png");
main:SetTachieBody("Resources/sampler/images/1.png");