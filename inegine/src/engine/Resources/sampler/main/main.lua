--Import
require "Resources\\sampler\\inventory\\inventory"
require "Resources\\sampler\\inventory\\inventorypresenter"
require "Resources\\sampler\\schedule\\schedule"
require "Resources\\sampler\\schedule\\execution"
require "Resources\\sampler\\schedule\\schedulepresenter"
require "Resources\\sampler\\schedule\\executionpresenter"
require "Resources\\sampler\\shopping\\shoplist"
require "Resources\\sampler\\shopping\\shop"
require "Resources\\sampler\\shopping\\shoppresenter"
require "Resources\\sampler\\status\\status"
require "Resources\\sampler\\status\\statuspresenter"
require "Resources\\sampler\\communication\\talklist"
require "Resources\\sampler\\communication\\talk"

Main = {}

function Main:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self

	self.gamestate = CurrentState();

    self:InitComponents()
    self:RegisterEvents()
	return o
end

--Component initialization
function Main:InitComponents()
	
	local gamestate = self.gamestate;

	
	local calendarBackground = SpriteBase();
	calendarBackground.Name = "calBackground";
	self.calendarBackground = background;
	calendarBackground.Texture = "Resources/sampler/resources/calendar.png"
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
	--datewin.WindowTexture = "Resources/sampler/resources/window.png"
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
	--statewin.WindowTexture = "Resources/sampler/resources/window.png"
	--statewin.RectSize = 40
	statewin.BackgroundColor = 0xFFFFFF
	
	statewin.Font = GetFont("state") --defaultFont
	InitComponent(statewin)
	
	local menu = ImageWindow()
	menu.Name = "mainmenu"
	menu.Alpha = 155
	menu.Width = 250
	menu.Height = 42*4
	menu.X = 50;
	menu.Y = 160;
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
	
	
	local button7 = self:CreateButton("System", nil);
	button7.X = 0;
	button7.Y = 42 * 3;	
	menu:AddComponent(button7);
	
end

function Main:CreateButton(buttonText, event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonText;
	newButton.Texture = "Resources/sampler/resources/button/button.png"	
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
	inventoryManager:SetDressEquippedEvent(function(id) self:EquipDress(id) end);
end

--mainmenu
function Main:OpenSchedule()
	local schedule = ScheduleView:New("scheduleView", self.gamestate);
	schedule:Init();
	
	self.schedulePresenter = SchedulePresenter:New();
	self.schedulePresenter:Init(self, schedule, scheduleManager);
	self.schedulePresenter:SetClosingEvent(
		function()
			Trace("disposing schedule presenter!");
			self.schedulePresenter = nil;
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
			self:ShowTachie(true);
			self:ToggleMainMenu(true);
			self.executionPresenter = nil;
		end
	)
	self.executionPresenter:Init(self, execution, scheduleManager);
end

function Main:OpenCommunication()
	self:ShowTachie(false);
	self:ToggleMainMenu(false);
	local talkListView = TalkListView:New("talkListView", CurrentState());
	talkListView:Init();
	talkListView:SetGreeting("Resources/sampler/resources/images/f2.png","�Ժ�", "���԰� ��ȭ�Ͻ� ������ �������ּ���.");
	self.talkListView = talkListView;
	
	talkListView:SetTalkSelectedEvent(
		function(button, luaevent, args)
			talkListView:Dispose();
			self:TestTalk();
		end
	)
	
	talkListView:SetClosingEvent( 
		function()
			Trace("closing talk list view");
			self:ShowTachie(true);
			self:ToggleMainMenu(true);
		end
	);
	talkListView:Show();
end

function Main:TestTalk()
	self:ShowTachie(false);
	self:ToggleMainMenu(false);
	local talkView = TalkView:New("talkView", CurrentState());
	self.talkView = talkView;
	talkView:Init();
	
	talkView:SetTalk("Resources/sampler/resources/images/f2.png","�Ժ�", "������ �̾߱��ϰ� �;����� �ʳ׿�.@");
	talkView:SetTalkOverEvent(
		function()
			talkView:SetTalk("Resources/sampler/resources/images/f3.png","�Ժ�", "�� �����̳� �÷��ֽ���?@");
			talkView:SetTalkOverEvent(
				function()
					talkView:Dispose();
					self:ShowTachie(true);
					self:ToggleMainMenu(true);
				end
			)
		end
	)
	
	talkView:SetClosingEvent( 
		function()
			self:ShowTachie(true);
			self:ToggleMainMenu(true);
		end
	);
	talkView:Show();
end

function Main:OpenStatus()

	local statusView = StatusView:New("statusView", self.gamestate);
	statusView:Init();
	
	self.statusPresenter = StatusPresenter:New();
	self.statusPresenter:Init(self, statusView, character);
	self.statusPresenter:SetClosingEvent(
		function()
			Trace("disposing schedule presenter!");
			self.statusPresenter = nil;
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
	self:ToggleMainMenu(false);
	self:ShowTachie(false);
	local shoplist = ShopListView:New("shoplistview", CurrentState());
	self.shoplist = shoplist;
	shoplist:Init();
	shoplist:SetGreeting("Resources/sampler/resources/images/f2.png","�Ժ�", "�����Ͻ� ���� �������ּ���.");
	shoplist:SetShopSelectedEvent(
		function(button, luaevent, arg)
			Trace(arg);
			shoplist:Hide();
			self:OpenShop(arg);
			--local shop = ShopView:New("shop", CurrentState());
			--self.shop = shop;
			--shop:Init();
			--shop:SetPortraitTexture("Resources/sampler/resources/images/f2.png");
			--shop:SetDialogueText("������ ���Ű��� ȯ���մϴ�.");	
			--shop:ShowDialogue(true);
			--shop:AddItem("item1", "item 1", "100G", "Resources/sampler/resources/icon.png");
			--shop:AddItem("item2", "item 2", "100G", "Resources/sampler/resources/icon.png");
			--shop:AddItem("item3", "item 3", "100G", "Resources/sampler/resources/icon.png");
			--
			--shop:SetSelectedEvent(
				--function(button, luaevent, args)
					--self.itemSelected = args;
					--shop:SetDetailText("SELECTED " .. args)
				--end
			--);
			--
			--shop:SetBuyingEvent(
				--function()
					--Trace("buying something!")
					--shop:ClearDialogueText();
					--shop:SetDialogueText(self.itemSelected .. " �� �����ϼ̽��ϴ�.");	
				--end
			--);
			--shop:SetClosingEvent(
				--function()
					--shoplist:Show()
					--Trace("shop closing!")
				--end
			--);
			--shop:Show();
		end
	)
	shoplist:SetClosingEvent( 
		function()
			Trace("shop closing!")
			self:ShowTachie(true);
			self:ToggleMainMenu(true);
		end
	);
	shoplist:Show();
end

function Main:OpenGoddess()
end

function Main:OpenSystem()
end

function Main:OpenInventory()
	local inventory = InventoryView:New("inventory", self.gamestate);
	inventory:Init();
	
	self.inventoryPresenter = InventoryPresenter:New();
	self.inventoryPresenter:Init(self, inventory, itemManager, inventoryManager);
	self.inventoryPresenter:SetClosingEvent(
		function()
			Trace("disposing schedule presenter!");
			self.inventoryPresenter = nil;
		end
	)
end


function Main:EquipDress(id)
	Trace("equipping item " .. id);
	local tachiBodyImage = itemManager:GetItem(id).dressImage;
	self:SetTachieBody(tachiBodyImage);
end

--datewindow
function Main:InvalidateDate()
	Main:SetDate(calendar:GetModifiedYear(), calendar:GetWordMonth(), calendar:GetDay(), calendar:GetWeek());
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
	if (self.tachieMargin ~= nil) then
		RemoveComponent("tachie");
	end
	
	local tachie = SpriteBase();
	tachie.Name = "tachie";
	tachie.Texture = filename
	tachie.Visible = true;
	tachie.Layer = 2;
	InitComponent(tachie);
	
	if (self.tachieMargin ~= nil) then
		self:SetTachiePosition(self.tachieMargin);
	else
		self:CenterTachie();
	end
		
	
end

function Main:SetTachieFace(filename)
end

function Main:SetTachieDress(filename)
end

function Main:ShowTachie(show)
	local tachie = GetComponent("tachie");
	if (tachie ~= nil) then
		tachie.visible = show;
		tachie.enabled = show;
	end
end

function Main:SetTachiePosition(leftMargin)
	self.tachieMargin = leftMargin;
	local tachie = GetComponent("tachie");
	if (tachie ~= nil) then
		tachie.X = leftMargin;
		tachie.Y = (GetHeight() - tachie.Height);
	end
end

function Main:CenterTachie()
	local tachie = GetComponent("tachie");
	if (tachie ~= nil) then
		self:SetTachiePosition((GetWidth() - tachie.Width)/2);
	end
end



--private/helper functions
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
										.. lastname .. "\nAge " .. age .. "\nGold "
										.. gold .. "\nStress " .. stress .. "%\nMana " .. mana .."%";
end


main = Main:New();
CurrentState().state = mainView;

--extra actions
main:InvalidateDate();
main:InvalidateStatus();

main:SetBackground("Resources/sampler/resources/images/room03.jpg");
main:SetTachieBody("Resources/sampler/resources/images/1.png");