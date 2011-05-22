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
LoadScript "system\\system.lua"

--font
--calendar date font
main_calendar_date = "calendar_date"
main_calendar_state_name = "calendar_state_name"
main_calendar_state_state = "calendar_state_state"

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
	self.calendarBackground = calendarBackground;
	calendarBackground.Texture = "resources/ui/state_window.png"
	calendarBackground.Visible = true;
	calendarBackground.Layer = 3;
	InitComponent(calendarBackground)

	local datewin = TextWindow()
	self.datewin = datewin;
	datewin.Alpha = 0
	datewin.Width = 100
	datewin.Height = 100
	datewin.x = 15;
	datewin.y = 35;
	datewin.Layer = 5
	datewin.LeftMargin = 20
	datewin.Margin = 15
	datewin.Visible = true
	datewin.BackgroundColor = 0xFFFFFF
	
	datewin.Font = GetFont(main_calendar_date)
	InitComponent(datewin)
	
	local statewinName = TextWindow()
	self.statewinName = statewinName;
	statewinName.Alpha = 0
	statewinName.Width = 110
	statewinName.Height = 100
	statewinName.x = 105;
	statewinName.y = 25;
	statewinName.Layer = 5
	statewinName.LeftMargin = 15
	statewinName.Margin = 10
	statewinName.Visible = true
	statewinName.TextColor = 0x000000
	
	statewinName.Font = GetFont(main_calendar_state_name)
	InitComponent(statewinName)

	local statewinState = TextWindow()
	self.statewinState = statewinState;
	statewinState.Alpha = 0
	statewinState.Width = 110
	statewinState.Height = 50
	statewinState.x = 105;
	statewinState.y = 65;
	statewinState.Layer = 5
	statewinState.LeftMargin = 15
	statewinState.Margin = 10
	statewinState.Visible = true
	statewinState.TextColor = 0x000000
	
	statewinState.Font = GetFont(main_calendar_state_state)
	InitComponent(statewinState)

	local menuSprite = SpriteBase()
	self.menuSprite = menuSprite;
	menuSprite.Width = 196
	menuSprite.Height = 228
	menuSprite.X = 10;
	menuSprite.Y = 150;
	menuSprite.Layer = 4
	menuSprite.Visible = true
	menuSprite.Enabled = true
	menuSprite.Texture = "resources/ui/main_menu.png"
	AddComponent(menuSprite)
	
	local menuSprite = SpriteBase()
	self.menuItemSprite = menuSprite;
	menuSprite.Width = 196
	menuSprite.Height = 228
	menuSprite.X = 10;
	menuSprite.Y = 150;
	menuSprite.Layer = 5
	menuSprite.Visible = false
	menuSprite.Enabled = true
	menuSprite.Texture = "resources/ui/main_menu_item.png"
	AddComponent(menuSprite)
	
	local menuSprite = SpriteBase()
	self.menuScheduleSprite = menuSprite;
	menuSprite.Width = 196
	menuSprite.Height = 228
	menuSprite.X = 10;
	menuSprite.Y = 150;
	menuSprite.Layer = 5
	menuSprite.Visible = false
	menuSprite.Enabled = true
	menuSprite.Texture = "resources/ui/main_menu_schedule.png"
	AddComponent(menuSprite)
	
	local menuSprite = SpriteBase()
	self.menuStateSprite = menuSprite;
	menuSprite.Width = 196
	menuSprite.Height = 228
	menuSprite.X = 10;
	menuSprite.Y = 150;
	menuSprite.Layer = 5
	menuSprite.Visible = false
	menuSprite.Enabled = true
	menuSprite.Texture = "resources/ui/main_menu_state.png"
	AddComponent(menuSprite)
	
	local menuSprite = SpriteBase()
	self.menuStoreSprite = menuSprite;
	menuSprite.Width = 196
	menuSprite.Height = 228
	menuSprite.X = 10;
	menuSprite.Y = 150;
	menuSprite.Layer = 5
	menuSprite.Visible = false
	menuSprite.Enabled = true
	menuSprite.Texture = "resources/ui/main_menu_store.png"
	AddComponent(menuSprite)
	
	local menuSprite = SpriteBase()
	self.menuSystemSprite = menuSprite;
	menuSprite.Width = 196
	menuSprite.Height = 228
	menuSprite.X = 10;
	menuSprite.Y = 150;
	menuSprite.Layer = 5
	menuSprite.Visible = false
	menuSprite.Enabled = true
	menuSprite.Texture = "resources/ui/main_menu_system.png"
	AddComponent(menuSprite)
	
	local menuSprite = SpriteBase()
	self.menuTalkSprite = menuSprite;
	menuSprite.Width = 196
	menuSprite.Height = 228
	menuSprite.X = 10;
	menuSprite.Y = 150;
	menuSprite.Layer = 5
	menuSprite.Visible = false
	menuSprite.Enabled = true
	menuSprite.Texture = "resources/ui/main_menu_talk.png"
	AddComponent(menuSprite)
	

	local menu = View()
	menu.Name = "mainmenu"
	menu.Width = 196
	menu.Height = 228
	menu.X = 10;
	menu.Y = 150;
	menu.Layer = 6
	menu.Visible = true
	menu.Enabled = true
	AddComponent(menu)	
	

	local button = self:CreateMenuButton(
 		function (button, luaevent, args)
			self:OpenSchedule();
		end,
		self.menuScheduleSprite);
	button.X = 120;
	button.Y = 40;
	button.Width = 70;
	button.Height = 40;
	menu:AddComponent(button);
	
	local button = self:CreateMenuButton(
 		function (button, luaevent, args)
			self:OpenCommunication();
		end,
		self.menuTalkSprite);
	button.X = 120;
	button.Y = 100;
	button.Width = 50;
	button.Height = 30;
	menu:AddComponent(button);
	
	local button = self:CreateMenuButton(
 		function (button, luaevent, args)
			self:OpenStatus();
		end,
		self.menuStateSprite);
	button.X = 72;
	button.Y = 130;
	button.Width = 50;
	button.Height = 40;
	menu:AddComponent(button);	
	
	local button = self:CreateMenuButton(
 		function (button, luaevent, args)
			self:OpenInventory();
		end,
		self.menuItemSprite);
	button.X = 25;
	button.Y = 105;
	button.Width = 55;
	button.Height = 25;
	menu:AddComponent(button);
	
	local button = self:CreateMenuButton(
 		function (button, luaevent, args)
			self:OpenShopList();
		end,
		self.menuStoreSprite);
	button.X = 23;
	button.Y = 54;
	button.Width = 55;
	button.Height = 30;
	menu:AddComponent(button);
	
	local button = self:CreateMenuButton(
 		function (button, luaevent, args)
			self:OpenSystem();
		end,
		self.menuSystemSprite);
	button.X = 66;
	button.Y = 17;
	button.Width = 70;
	button.Height = 30;
	menu:AddComponent(button);	
	
	--tachie
	self.tachie = Tachie()
	self.tachie.layer = 5
	gamestate:AddComponent(self.tachie);
	self.tachie.Position = 0.5;
end

function Main:ShowMenu(menu, show)
	self.menuItemSprite:Hide();
	self.menuScheduleSprite:Hide();
	self.menuStateSprite:Hide();
	self.menuStoreSprite:Hide();
	self.menuSystemSprite:Hide();
	self.menuTalkSprite:Hide();
	
	if (show) then
		menu:Show();
	else
		menu:Hide();
	end
end

function Main:CreateMenuButton(event, texture)
	return UIFactory.CreateRollOverButton(event,
		function ()
			self:ShowMenu(texture, true);
		end,
		function ()
			self:ShowMenu(texture, false);
		end);
end

function Main:RegisterEvents()
	calendar:SetUpdateEvent(function() self:InvalidateDate() end);
	character:SetLookEvent(function() self:InvalidateTachie() end);
	character:SetTriggerEvent("gold", function() self:InvalidateStatus() end);
	character:SetTriggerEvent("stress", function() self:InvalidateStatus() end);
	character:SetTriggerEvent("mana", function() self:InvalidateStatus() end);
	
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
	self:Disable(true, false);
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
	self:Disable(false, false);
	local execution = ExecutionView:New("executionView", CurrentState());
	execution:Init();

	self.executionPresenter = ExecutionPresenter:New();
	self.executionPresenter:SetClosingEvent(
		function()
			self:Enable();
            self:PostScheduleTrigger();
		end
	)
	self.executionPresenter:Init(self, execution, scheduleManager);
	execution:Show();
	
	--reset talk event toggle
	self.musumeEventAvailable = true;
	self.goddessEventAvailable = true;
end

function Main:OpenCommunication()
	self:Disable(true, false);
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
			if (args == "musumeButton") then
				if (table.getn(self.musumeevents) > 0 and self.musumeEventAvailable) then
					self.eventList = self.musumeevents
					self.talkListView:Dispose();
					self:ProcessEvents();
					self.musumeEventAvailable = false;
				else		
					self.talkListView:Dispose();
					self:MusumeTalk();
				end
			elseif (args == "goddessButton") then	
				if (table.getn(self.goddessevents) > 0 and self.goddessEventAvailable) then
					self.eventList = self.goddessevents
					self.talkListView:Dispose();
					self:ProcessEvents();
					self.goddessEventAvailable = false;
				else
					self.talkListView:Dispose();
					self:GoddessTalk();
				end
			end
			self.musumeevents = nil;
			self.goddessevents = nil;
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
	self:Enable();
	self:Disable(false, false);
	local talkView = TalkView:New("talkView", CurrentState());
	self.talkView = talkView;
	talkView:Init();
	self:SetKeyDownEvent(
		function()
			talkView:Advance()
		end
	)
	Trace("outputting log");
	
	talkView:SetTalk(pic, name, line);
	logManager:SetDate();
    logManager:SetName(name, pic);
    logManager:SetLine(line);
	
	talkView:SetTalkOverEvent(
		function()
			talkView:Dispose();
			self:SetKeyDownEvent(nil);
		end
	)
	
	talkView:SetClosingEvent( 
		function()
			self:Enable();
		end
	);
	Trace("showing talk view");
	talkView:Show();
end

function Main:OpenStatus()
	
	self:Disable(false);
	
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
	self:Disable(true, false);
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

function Main:OpenSystem()
	self:Disable(true, false);
	local shoplist = SystemView:New("SystemView", CurrentState());
	self.shoplist = shoplist;
	shoplist:Init();
	shoplist:SetClosingEvent( 
		function()
			self:Enable();
		end
	);
	shoplist:Show();
end

function Main:OpenInventory()
	self:Disable(false, false);
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
	self:SetDate(calendar:GetYear(), calendar:GetMonth(), calendar:GetDay());
end
	
--statuswindow
function Main:InvalidateStatus()
	self:SetState(character:GetFirstName(), character:GetLastName(), character:Read("age"), character:Read("gold"),
				  character:Read("stress"), character:Read("mana"));
end

--event functions
function Main:PostScheduleTrigger()
	self.executionPresenter = nil;
	self.eventList = eventManager:GetPostEvents();
	Trace("got list of events");
	self:ProcessEvents();
end

function Main:ProcessEvents(first)
	Trace("processing events");
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
		Trace("no more event to process - returning to main ");
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

function Main:ShowTachie(show)
	if (show == true) then
		Trace("showing tachie");
		self.tachie:Show();
	else
		Trace("hiding tachie");
		self.tachie:Hide();
	end
end

--private/helper functions
function Main:Enable()
	self:ShowTachie(true);
	self:ToggleCalendar(true);
	self:ToggleMainMenu(true);
end

function Main:Disable(hideTachie, hideCalendar)
	if (hideTachie == nil or hideTachie == true) then
		self:ShowTachie(false);
	end
	
	if (hideCalendar == nil or hideCalendar == true) then
		self:ToggleCalendar(false);
	end
	
	self:ToggleMainMenu(false);
end

function Main:ToggleCalendar(enabled)
	if (enabled) then
		self.calendarBackground:Show();
		self.datewin:Show();
		self.statewinName:Show();
		self.statewinState:Show();
	else
		self.calendarBackground:Hide();
		self.datewin:Hide();
		self.statewinName:Hide();
		self.statewinState:Hide();
	end
end

function Main:ToggleMainMenu(enabled)
	GetComponent("mainmenu").enabled = enabled;
	GetComponent("mainmenu").visible = enabled;
	
	if (enabled) then
		self:ShowMenu(self.menuSprite, true);
	else
		self:ShowMenu(self.menuSprite, false);
	end
end


function Main:SetDate(year, month, day)
	self.datewin.text = year .. main_state_year .. "\n" ..
						month .. main_state_month .. day .. main_state_day
end

function Main:SetState(firstname, lastname, age, gold, stress, mana)
	self.statewinName.text = firstname .. "\n" .. lastname .. "\n";
	self.statewinState.text = main_state_gold .. gold .. "\n" ..
							  main_state_stress .. stress .. "\n" ..
							  main_state_mana .. mana;
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