--Import
require "Resources\\sampler\\inventory\\inventory"
require "Resources\\sampler\\schedule\\schedule"
require "Resources\\sampler\\schedule\\execution"
require "Resources\\sampler\\schedule\\schedulepresenter"
require "Resources\\sampler\\shopping\\shoplist"
require "Resources\\sampler\\shopping\\shop"
require "Resources\\sampler\\status\\status"
require "Resources\\sampler\\communication\\talklist"
require "Resources\\sampler\\communication\\talk"

Main = {}

function Main:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self

	self.gamestate = CurrentState();

    self:InitComponents()
   
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
			self:OpenShop();
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
	self.schedulePresenter:AddTestItems();
end

--mainmenu
function Main:OpenScheduleDeprecated()
	self:ToggleMainMenu(false);
	local schedule = ScheduleView:New("scheduleView", CurrentState());
	schedule:Init();
	schedule:SetClosingEvent( 
		function()
			Trace("closing cschedule view clicked!")
			self.schedule:Hide();
			self.schedule = nil;
			self:ToggleMainMenu(true);
		end
	);
	selectedIndex = 0;
    selectedItemCount = 0;
	schedule:SetSelectedEvent(
		function (button, luaevent, args)
			Trace("select event called from " .. args);
            if (selectedItemCount < 4) then
                schedule:AddSelectedItem(args .. selectedItemCount, "Resources/sampler/resources/icon.png");
                selectedIndex = selectedIndex + 1
                selectedItemCount = selectedItemCount + 1;
            end
		end
	)
	
	schedule:SetSelectedFocusEvent(
		function (button, luaevent, args)
			Trace("focus selected event called from " .. args);
            focusedSelectedIcon = args;          
            schedule:FocusSelectedItem(args);
            schedule:SetDetailText("detailed explanation: " .. args);
		end
	)

	schedule:SetDeletingEvent(
		function (button, luaevent, args)         
            if (focusedSelectedIcon ~= nil) then
                schedule:RemoveSelectedItem(focusedSelectedIcon);
                focusedSelectedIcon = nil;
                selectedItemCount = selectedItemCount - 1;
            end
		end
	)
	
    schedule:SetExecutingEvent(
		function (button, luaevent, args)
			schedule:Dispose();
			self:OpenScheduleExecution();
		end
    )
	
	--add test items
	schedule:AddEducationItem("education1", "Education01", "100G", "Resources/sampler/resources/icon.png");
	schedule:AddEducationItem("education2", "edu 2", "100G", "Resources/sampler/resources/icon.png");
	schedule:AddEducationItem("education3", "edu 3", "100G", "Resources/sampler/resources/icon.png");
	schedule:AddEducationItem("education4", "edu 4", "100G", "Resources/sampler/resources/icon.png");
	schedule:AddEducationItem("education5", "edu 5", "100G", "Resources/sampler/resources/icon.png");
	schedule:AddEducationItem("education6", "edu 6", "100G", "Resources/sampler/resources/icon.png");
	
	schedule:AddWorkItem("work1", "work 1", "100G", "Resources/sampler/resources/icon.png");
	
	schedule:AddVacationItem("vacation1", "vacation 1", "100G", "Resources/sampler/resources/icon.png");
	--
    --schedule:AddSelectedItem("test1", "test 1");
    --schedule:AddSelectedItem("test2", "test 2");
    --schedule:AddSelectedItem("test3", "test 3");
--
    --schedule:FocusSelectedItem("test2");
	
	schedule:Show();
	
	self.schedule = schedule;
end

function Main:OpenScheduleExecution()
	local execution = ExecutionView:New("executionView", CurrentState());
	execution:Init();
	self.execution = execution;
	self:TestExecution(execution);
end

function Main:TestExecution(execution)
	self:ShowTachie(false);
	self:ToggleMainMenu(false);
	execution:SetExecutionOverEvent(
		function ()
			calendar:AdvanceWeek()
			self:InvalidateDate()
			execution:SetExecutionOverEvent(
				function ()
			calendar:AdvanceWeek()
			self:InvalidateDate()		
					self:ShowTachie(true);
					self:ToggleMainMenu(true);
					execution:Dispose();
					Trace("execution over!");
				end
			)
			execution:ExecuteSchedule("강태공",
									  "이번주는 사공일을 합니다.\n잘 부탁 드립니다.@",
									  "Resources/sampler/resources/images/f3.png",
									  "Resources/sampler/resources/cursor.png",
									  "GOLD +0\nSTR +0, DEX +0, CON + 0",
									  "이번주는 잘 안되었습니다!\n아버지가 슬퍼하실거에요.@",
									  "Resources/sampler/resources/images/f1.png");
		end
	)
	execution:ExecuteSchedule("강태공", "이번주는 사공일을 합니다.\n잘 부탁 드립니다.@",
							  "Resources/sampler/resources/images/f3.png", 
							  "Resources/sampler/resources/cursor.png",
							  "GOLD +5,400\nSTR +10, DEX +10, CON + 10",
							  "이번주는 잘 되었습니다!\n아버지도 기뻐하실거에요.@",
							  "Resources/sampler/resources/images/f2.png");
	Trace("executed!");
end

function Main:OpenCommunication()
	self:ShowTachie(false);
	self:ToggleMainMenu(false);
	local talkListView = TalkListView:New("talkListView", CurrentState());
	talkListView:Init();
	talkListView:SetGreeting("Resources/sampler/resources/images/f2.png","규브", "따님과 대화하실 내용을 선택해주세요.");
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
	
	talkView:SetTalk("Resources/sampler/resources/images/f2.png","규브", "따님이 이야기하고 싶어하지 않네요.@");
	talkView:SetTalkOverEvent(
		function()
			talkView:SetTalk("Resources/sampler/resources/images/f3.png","규브", "제 월급이나 올려주시죠?@");
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
	self:ToggleMainMenu(false);
	self.statusView = StatusView:New("statusView", CurrentState());
	local statusView = self.statusView;
	statusView:Init();
	statusView:SetClosingEvent( 
		function()
			self:ShowTachie(true);
			self:ToggleMainMenu(true);
		end
	);
	statusView:Show();
	statusView:SetDescriptionText("TEST\nTEST2\nTEST3");
	statusView:AddGraphItem("기품", "900", 50, 0x990000);
	statusView:AddGraphItem("미모", "300", 100, 0x0099CC);
end

function Main:OpenShop()
	self:ToggleMainMenu(false);
	self:ShowTachie(false);
	local shoplist = ShopListView:New("shoplistview", CurrentState());
	self.shoplist = shoplist;
	shoplist:Init();
	shoplist:SetGreeting("Resources/sampler/resources/images/f2.png","규브", "쇼핑하실 곳을 선택해주세요.");
	shoplist:SetShopSelectedEvent(
		function(button, luaevent, arg)
			shoplist:Hide();
			local shop = ShopView:New("shop", CurrentState());
			self.shop = shop;
			shop:Init();
			shop:SetPortraitTexture("Resources/sampler/resources/images/f2.png");
			shop:SetDialogueText("옷집에 오신것을 환영합니다.");	
			shop:ShowDialogue(true);
			shop:AddItem("item1", "item 1", "100G", "Resources/sampler/resources/icon.png");
			shop:AddItem("item2", "item 2", "100G", "Resources/sampler/resources/icon.png");
			shop:AddItem("item3", "item 3", "100G", "Resources/sampler/resources/icon.png");
			
			shop:SetSelectedEvent(
				function(button, luaevent, args)
					self.itemSelected = args;
					shop:SetDetailText("SELECTED " .. args)
				end
			);
			
			shop:SetBuyingEvent(
				function()
					Trace("buying something!")
					shop:ClearDialogueText();
					shop:SetDialogueText(self.itemSelected .. " 를 구입하셨습니다.");	
				end
			);
			shop:SetClosingEvent(
				function()
					shoplist:Show()
					Trace("shop closing!")
				end
			);
			shop:Show();
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
	self:ToggleMainMenu(false);
	local inven = InventoryView:New("inventory", CurrentState());
	inven:Init();
	
	inven:SetClosingEvent( 
		function()
			Trace("inventory clicked!")
			self.inventory = nil;
			self:ToggleMainMenu(true);
			self:CenterTachie();
		end
	);
	
	inven:SetSelectedEvent(
		function (button, luaevent, args)
			Trace("select event called from " .. args);
			if (args == "dress1") then
				Trace("changing dress to dress 1")
				main:SetTachieBody("Resources/sampler/resources/images/1.png");
				main:SetTachiePosition(inven.frame.X + inven.frame.Width + 10);
			elseif (args == "dress2") then
				Trace("changing dress to dress 2")
				main:SetTachieBody("Resources/sampler/resources/images/2.png");
				main:SetTachiePosition(inven.frame.X + inven.frame.Width + 10);
			elseif (args == "dress3") then
				Trace("changing dress to dress 3")
				main:SetTachieBody("Resources/sampler/resources/images/3.png");
				main:SetTachiePosition(inven.frame.X + inven.frame.Width + 10);
			end

            button.pushed = false; 
		end
	)
	
	
	--add test items
	inven:AddDressItem("dress1", "Dress 1", "Resources/sampler/resources/icon.png");
	inven:AddDressItem("dress2", "Dress 2", "Resources/sampler/resources/icon.png");
	inven:AddDressItem("dress3", "Dress 2", "Resources/sampler/resources/icon.png");
	
	inven:AddItemItem("item1", "Item 1", "Resources/sampler/resources/icon.png");
	
	inven:AddFurnitureItem("furniture1", "Furniture 1", "Resources/sampler/resources/icon.png");
	
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

function Main:ShowTachie(show)
	local tachie = GetComponent("tachie");
	if (tachie ~= nil) then
		tachie.visible = show;
		tachie.enabled = show;
	end
end

function Main:SetTachiePosition(leftMargin)
	GetComponent("tachie").X = leftMargin;
end

function Main:CenterTachie()
	local tachie = GetComponent("tachie");
	if (tachie ~= nil) then
		tachie.X = (GetWidth() - tachie.Width)/2;
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

main:SetBackground("Resources/sampler/resources/images/room01.png");
main:SetTachieBody("Resources/sampler/resources/images/1.png");