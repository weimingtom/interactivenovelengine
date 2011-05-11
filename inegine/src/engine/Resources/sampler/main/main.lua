--main state
--Import
LoadScript "inventory\\inventory.lua"
LoadScript "inventory\\inventorypresenter.lua"
LoadScript "schedule\\schedule.lua"
LoadScript "schedule\\execution.lua"
LoadScript "schedule\\schedulepresenter.lua"
LoadScript "schedule\\executionpresenter.lua"
LoadScript "shopping\\shoplist.lua"
LoadScript "shopping\\shop.lua"
LoadScript "shopping\\shoppresenter.lua"
LoadScript "status\\status.lua"
LoadScript "status\\statuspresenter.lua"
LoadScript "communication\\talklist.lua"
LoadScript "communication\\talk.lua"
LoadScript "save\\saveview.lua"
LoadScript "save\\savepresenter.lua"

Main = {}

function Main:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self

	self.gamestate = CurrentState();

	--event toggle (reset each month)
	self.musumeEventAvailable = true;
	self.goddessEventAvailable = true;

    self:InitComponents()
    self:RegisterEvents()
    
    StopSounds(1000);
	    
	return o
end

--Component initialization
function Main:InitComponents()
	
	local gamestate = self.gamestate;

	
	local calendarBackground = SpriteBase();
	calendarBackground.Name = "calBackground";
	self.calendarBackground = background;
	calendarBackground.Texture = "resources/calendar.png"
	calendarBackground.Visible = true;
	calendarBackground.Layer = 3;
	InitComponent(calendarBackground)

	local datewin = TextWindow()
	datewin.Name = "datedisplay"
	datewin.Alpha = 0
	datewin.Width = 100
	datewin.Height = 100
	datewin.x = 15;
	datewin.y = 35;
	datewin.Layer = 5
	datewin.LeftMargin = 20
	datewin.Margin = 15
	datewin.MouseClick =
        function(window, luaevent, args)	
	        Trace("datewindow clicked!")
        end;
	datewin.Visible = true
	--datewin.WindowTexture = "resources/window.png"
	--datewin.RectSize = 40
	datewin.BackgroundColor = 0xFFFFFF
	
	datewin.Font = GetFont("verysmall") --defaultFont
	InitComponent(datewin)
	
	local statewin = TextWindow()
	statewin.Name = "statedisplay"
	statewin.Alpha = 0
	statewin.Width = 120
	statewin.Height = 100
	statewin.x = 112;
	statewin.y = 25;
	statewin.Layer = 5
	statewin.LeftMargin = 15
	statewin.Margin = 10
	statewin.MouseClick =
        function(window, luaevent, args)	
	        Trace("statewindow clicked!")
        end;
	statewin.Visible = true
	--statewin.WindowTexture = "resources/window.png"
	--statewin.RectSize = 40
	statewin.BackgroundColor = 0xFFFFFF
	
	statewin.Font = GetFont("calstate") --defaultFont
	InitComponent(statewin)
	
	local menu = ImageWindow()
	menu.Name = "mainmenu"
	menu.Alpha = 155
	menu.Width = 250
	menu.Height = 42*5
	menu.X = 50;
	menu.Y = 160;
	menu.Layer = 5
	menu.LineSpacing = 20
	menu.Visible = true
	menu.Enabled = true
	menu.Font = GetFont("state")
	menu.MouseLeave =
		function(selectionWindow, event, args)
		end
	AddComponent(menu)

	local button1 = self:CreateButton("Schedule",
 		function (button, luaevent, args)
			self:OpenSchedule();
		end);
	button1.X = 0;
	button1.Y = 42 * 0;
	menu:AddComponent(button1);

	
	local button2 = self:CreateButton("Talk",
 		function (button, luaevent, args)
			self:OpenCommunication();
		end);
	button2.X = 100;
	button2.Y = 42 * 0;
	menu:AddComponent(button2);

	local button3 = self:CreateButton("Status",
 		function (button, luaevent, args)
			self:OpenStatus();
		end);
	button3.X = 0;
	button3.Y = 42 * 1;
	menu:AddComponent(button3);

	local button4 = self:CreateButton("Inventory",
 		function (button, luaevent, args)
			self:OpenInventory();
		end);
	button4.X = 100;
	button4.Y = 42 * 1;
	menu:AddComponent(button4);

	local button5 = self:CreateButton("Shopping",
 		function (button, luaevent, args)
			self:OpenShopList();
		end);
	button5.X = 0;
	button5.Y = 42 * 2;
	menu:AddComponent(button5);
	
	local button6 = self:CreateButton("Goddess", nil);
	button6.X = 100;
	button6.Y = 42 * 2;	
	menu:AddComponent(button6);
	
	
	local button7 = self:CreateButton("System", 
 		function (button, luaevent, args)
			self:OpenSystem();
		end);
	button7.X = 0;
	button7.Y = 42 * 3;	
	menu:AddComponent(button7);

	local button8 = self:CreateButton("Log", 
 		function (button, luaevent, args)
			OpenState("log", "log/logstate.lua");
			--self:OpenEvent("resources/event/testevent.ess");
		end);
	button8.X = 100;
	button8.Y = 42 * 3;	
	menu:AddComponent(button8);
	
	local button9 = self:CreateButton("Test", 
 		function (button, luaevent, args)
			self:OpenEvent("resources/event/testevent.ess");
		end);
	button9.X = 0;
	button9.Y = 42 * 4;	
	menu:AddComponent(button9);
	
	--tachie
	self.tachie = Tachie()
	self.tachie.layer = 10;
	gamestate:AddComponent(self.tachie);
	self.tachie.Position = 0.5;
end

function Main:CreateButton(buttonText, event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonText;
	newButton.Texture = "resources/button/button.png"	
	newButton.Layer = 3
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 100;
	newButton.Height = 40;
	newButton.State = {}
	newButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
			newButton.Pushed = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
                if (event~=nil) then 
					event(button, luaevent, args);
				end
			end
		end
	newButton.Text = buttonText;
	newButton.Font = GetFont("menu"); --menuFont
	newButton.TextColor = 0xEEEEEE
	return newButton;
end

function Main:RegisterEvents()
	calendar:SetUpdateEvent(function() self:InvalidateDate() end);
	character:SetLookEvent(function() self:InvalidateTachie() end);
	
	CurrentState().KeyDown = function(handler, luaevent, args) 
		self:KeyDown(handler, luaevent, args);
	end
	
end

function Main:KeyDown(handler, luaevent, args)
	if (self.keyDownEvent ~= nil) then
		self.keyDownEvent(handler, luaevent, args);
	end
end

--mainmenu
function Main:OpenSchedule()
	self:Disable();
	local schedule = ScheduleView:New("scheduleView", self.gamestate);
	schedule:Init();
	
	self.schedulePresenter = SchedulePresenter:New();
	self.schedulePresenter:Init(self, schedule, scheduleManager);
	self.schedulePresenter:SetClosingEvent(
		function()
			Trace("disposing schedule presenter!");
			self.schedulePresenter = nil;
			self:Enable();
		end
	)
end

function Main:OpenScheduleExecution()
	local execution = ExecutionView:New("executionView", CurrentState());
	execution:Init();

	self.executionPresenter = ExecutionPresenter:New();
	self.executionPresenter:SetClosingEvent(
		function()
			Trace("disposing execution presenter!");
            self:PostScheduleTrigger();
		end
	)
	self.executionPresenter:Init(self, execution, scheduleManager);
end

function Main:OpenCommunication()
	self:Disable();
	local talkListView = TalkListView:New("talkListView", CurrentState());
	self.talkListView = talkListView;
	
	talkListView:Init();
	
	self.musumeevents = eventManager:GetMusumeEvents();
	self.goddessevents = eventManager:GetGoddessEvents();
	
	if (table.getn(self.musumeevents) > 0 and self.musumeEventAvailable) then
		talkListView:ToggleMusumeEvent();	
	end
	
	if (table.getn(self.goddessevents) > 0 and self.goddessEventAvailable) then
		talkListView:ToggleGoddessEvent();	
	end

	talkListView:SetTalkSelectedEvent(
		function(button, luaevent, args)
	
			if (button.Name == "musumeButton") then
				Trace("musume button!");		
				if (table.getn(self.musumeevents) > 0 and self.musumeEventAvailable) then			
					self.eventList = self.musumeevents
					self:ProcessEvents();
					self.musumeEventAvailable = false;
				else	
					self:MusumeTalk();
				end
			else
				Trace("goddess button!");		
				if (table.getn(self.goddessevents) > 0 and self.goddessEventAvailable) then
					self.eventList = self.goddessevents
					self:ProcessEvents();
					self.goddessEventAvailable = false;
				else
					self:GoddessTalk();
				end
			end
			self.musumeevents = nil;
			self.goddessevents = nil;
			talkListView:Hide();
		end
	)
	
	talkListView:SetClosingEvent( 
		function()
			Trace("closing talk list view");
			self:Enable();
		end
	);
	talkListView:Show();
end

function Main:MusumeTalk()
	local line = talkManager:GetMusumeLine();
	self:NormalTalk(line.pic, line.name, line.line);
end

function Main:GoddessTalk()
	local line = talkManager:GetGoddessLine();
	self:NormalTalk(line.pic, line.name, line.line);
end

function Main:NormalTalk(pic, name, line)
	self:Disable();
	local talkView = TalkView:New("talkView", CurrentState());
	self.talkView = talkView;
	talkView:Init();
	self:SetKeyDownEvent(
		function()
			talkView:Advance()
		end
	)
	
	talkView:SetTalk(pic, name, line);
	talkView:SetTalkOverEvent(
		function()
			talkView:Dispose();
			self.talkListView:Dispose();
			self:SetKeyDownEvent(nil);
		end
	)
	
	talkView:SetClosingEvent( 
		function()
			self.talkListView:Dispose();
			self:Enable();
		end
	);
	talkView:Show();
end

function Main:OpenStatus()
	
	self:Disable();
	
	local statusView = StatusView:New("statusView", self.gamestate);
	statusView:Init();
	
	self.statusPresenter = StatusPresenter:New();
	self.statusPresenter:Init(self, statusView, character);
	self.statusPresenter:SetClosingEvent(
		function()
			Trace("disposing schedule presenter!");
			self.statusPresenter = nil;
			self:Enable();
		end
	)
end

function Main:OpenShop(shopName)
	local shopView = ShopView:New("shopView", self.gamestate);
	shopView:Init();
	
	self.shopPresenter = ShopPresenter:New();
	self.shopPresenter:Init(self, shopView, itemManager, shopManager, inventoryManager, shopName);
	self.shopPresenter:SetClosingEvent(
		function()
			Trace("disposing shop presenter!");
			self.shopPresenter = nil;
			self.shoplist:Show();
		end
	)
end

function Main:OpenShopList()
	self:Disable();
	local shoplist = ShopListView:New("shoplistview", CurrentState());
	self.shoplist = shoplist;
	shoplist:Init();
	shoplist:SetGreeting("resources/images/f2.png", main_shop_greeting_name,
						 main_shop_greeting_msg);
	shoplist:SetShopSelectedEvent(
		function(button, luaevent, arg)
			Trace(arg);
			shoplist:Hide();
			self:OpenShop(arg);
		end
	)
	shoplist:SetClosingEvent( 
		function()
			Trace("shop closing!")
			self:Enable();
		end
	);
	shoplist:Show();
end

function Main:OpenGoddess()
end

function Main:OpenSystem()
	local saveView = SaveView:New("saveView", CurrentState());
	saveView:Init();
	
	self:Disable();

	
	self.savePresenter = SavePresenter:New();
	self.savePresenter:Init(saveView, saveManager);
	self.savePresenter:SetClosingEvent(
		function()
			Trace("disposing save presenter!");
			self:Enable();
			self.savePresenter = nil;
		end
	)
	self.savePresenter:SetTitleEvent(
		function()
			Trace("going back to title!");
		end
	)
end

function Main:OpenInventory()
	self:Disable(false);
	self:SetTachiePosition(0.75);
	local inventory = InventoryView:New("inventory", self.gamestate);
	inventory:Init();
	
	self.inventoryPresenter = InventoryPresenter:New();
	self.inventoryPresenter:Init(self, inventory, itemManager, inventoryManager);
	self.inventoryPresenter:SetClosingEvent(
		function()
			Trace("disposing schedule presenter!");
			self.inventoryPresenter = nil;
			self:Enable();
			self:SetTachiePosition(0.5);
		end
	)
end

--datewindow
function Main:InvalidateDate()
	self:SetDate(calendar:GetYear(), calendar:GetWordMonth(), calendar:GetDay(), calendar:GetWeek());
	--reset talk event toggle
	self.musumeEventAvailable = true;
	self.goddessEventAvailable = true;
end
	
--statuswindow
function Main:InvalidateStatus()
	self:SetState(character:GetFirstName(), character:GetLastName(), character:Read("age"), character:Read("gold"),
				  character:Read("stress", 1), character:Read("mana", 1));
end

--event functions
function Main:PostScheduleTrigger()
	self.executionPresenter = nil;
	self.eventList = eventManager:GetPostEvents();
	self:ProcessEvents();
end

function Main:ProcessEvents(first)
	local delay = 0;
	if (first == nil) then
		FadeOut(1000)
		delay = 1000;
	end
	
	local events = self.eventList;
	if (table.getn(events) > 0) then
		local nextItem = table.remove(events);
		Trace("executing event: " .. nextItem.id);
		Delay(delay,
			function()
				self:OpenEvent(nextItem.script);
			end
		)
	else
		FadeIn(1000)
		self:Enable();
	end
end

function Main:OpenEvent(eventScript)
    OpenState("event", "event/eventstate.lua", eventScript,
    function()     
		self:ProcessEvents(false);		
    end)
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
function Main:InvalidateTachie()
	self.tachie.BodyTexture = character:GetBody();
	self.tachie.DressTexture = itemManager:GetItem(character:GetDress()).dressImage;
end

function Main:SetTachiePosition(pos)
	self.tachie.Position = pos;
end

--function Main:EquipDress()
	--local id = character:GetDress();
	--Trace("equipping dress to tachie " .. id);
	--local tachiBodyImage = itemManager:GetItem(id).dressImage;
	--self:SetTachieBody(tachiBodyImage);
--end
--
--function Main:SetTachieBody(filename)
	--local tachie = GetComponent("tachie");
	--if (tachie == nil) then
		--local tachie = SpriteBase();
		--tachie.Name = "tachie";
		--tachie.Texture = filename
		--tachie.Visible = true;
		--tachie.Layer = 2;
		--InitComponent(tachie);
	--else
		--tachie.Texture = filename;
	--end
	--
	--if (self.tachieMargin ~= nil) then
		--self:SetTachiePosition(self.tachieMargin);
	--else
		--self:CenterTachie();
	--end
--end
--
--function Main:SetTachieFace(filename)
--end
--
--function Main:SetTachieDress(filename)
--end
--
function Main:ShowTachie(show)
	if (show == true) then
		Trace("showing tachie");
		self.tachie:Show();
	else
		Trace("hiding tachie");
		self.tachie:Hide();
	end
end
--
--function Main:SetTachiePosition(leftMargin)
	--self.tachieMargin = leftMargin;
	--local tachie = GetComponent("tachie");
	--if (tachie ~= nil) then
		--tachie.X = leftMargin;
		--tachie.Y = (GetHeight() - tachie.Height);
	--end
--end
--
--function Main:CenterTachie()
	--local tachie = GetComponent("tachie");
	--if (tachie ~= nil) then
		--self:SetTachiePosition((GetWidth() - tachie.Width)/2);
	--end
--end
--


--private/helper functions
function Main:Enable()
	self:ShowTachie(true);
	self:ToggleMainMenu(true);
end

function Main:Disable(hideTachie)
	if (hideTachie == nil or hideTachie == true) then
		self:ShowTachie(false);
	end
	
	self:ToggleMainMenu(false);
end

function Main:ToggleMainMenu(enabled)
	GetComponent("mainmenu").enabled = enabled;
	GetComponent("mainmenu").visible = enabled;
end


function Main:SetDate(year, month, day, week)
	GetComponent("datedisplay").text = year .. "\n" 
									   .. month .. " " .. day .. "\n"
									   .. "Week " ..  week;
end

function Main:SetState(firstname, lastname, age, gold, stress, mana)
	GetComponent("statedisplay").text = firstname .. " " 
										.. lastname .. "\n" 
										.. main_state_age .. age .. "\n"
										.. main_state_gold .. gold .. "\n"
										.. main_state_stress .. stress .. "\n"
										.. main_state_mana .. mana;
end

function Main:SetKeyDownEvent(event)
	self.keyDownEvent = event;
end

function Main:Invalidate()
	self:InvalidateDate();
	self:InvalidateStatus();
	self:InvalidateTachie();
end

--entry point
main = Main:New();
CurrentState().state = main;

--extra actions
main:Invalidate();
main:SetBackground("resources/images/room03.jpg");