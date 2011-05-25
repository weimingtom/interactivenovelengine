--title state
--Import
LoadScript "save\\saveview.lua"
LoadScript "save\\savepresenter.lua"

TitleState = {}

function TitleState:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self

	self.gamestate = CurrentState();

    self:InitComponents()
    self:RegisterEvents()
    
    GetSound("sound1"):Play();
    
	return o
end

--Component initialization
function TitleState:InitComponents()
	local gamestate = self.gamestate;
	
	self:SetBackground("resources/images/title.jpg");
	
	local view = View();
	self.view = view;
	view.name = "view";
	view.x = 0;
	view.y = 0;
	view.Width = GetWidth();
	view.Height = GetHeight();
	AddComponent(view);
	view:Show();
	view.Layer = 10;
	
	local titleText = Label();
	titleText.Name = "title";
	titleText.X = 75;
	titleText.Y = 75;
	titleText.Alignment = 0;
	titleText.VerticalAlignment = 0;
	titleText.Width = 640;
	titleText.Height = 240;
	titleText.Text = titlestate_title;
	titleText.Font = GetFont("verylarge");
	titleText.TextColor = 0xEEEEEE
	titleText.Layer = 3
	titleText.MouseDoubleClick = 
		function (newButton, luaevent, args)
			Trace("double click!");
		end
	titleText.enabled = true;
	view:AddComponent(titleText);	
	
	local newGameButton = self:CreateButton(titlestate_newgame,
		function (button, luaevent, args)
			Trace("new game button clicked!");
			CloseState();
			LoadScript("startgame.lua");
		end);
	newGameButton.X = 550;
	newGameButton.Y = 300;
	view:AddComponent(newGameButton);
	
	local continueButton = self:CreateButton(titlestate_continue,
		function (button, luaevent, args)
			Trace("continue button clicked!");
			self:OpenSystem();
		end);
	continueButton.X = 550;
	continueButton.Y = 350;
	view:AddComponent(continueButton);
	
	local omakeButton = self:CreateButton(titlestate_omake,
		function (button, luaevent, args)
			Trace("omake button clicked!");
		end);
	omakeButton.X = 550;
	omakeButton.Y = 400;
	view:AddComponent(omakeButton);
	
	
	local exitButton = self:CreateButton(titlestate_exit,
		function (button, luaevent, args)
			Trace("exit button clicked!");
		end);
	exitButton.X = 550;
	exitButton.Y = 450;
	view:AddComponent(exitButton);
end

function TitleState:RegisterEvents()
	CurrentState().KeyDown = function(handler, luaevent, args) 
		self:KeyDown(handler, luaevent, args);
	end
end

function TitleState:KeyDown(handler, luaevent, args)
	if (self.keyDownEvent ~= nil) then
		self.keyDownEvent(handler, luaevent, args);
	end
end

function TitleState:SetBackground(filename)
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


function TitleState:CreateButton(buttonText, event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonText;
	newButton.Layer = 3
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Alignment = 0;
	newButton.Width = 250;
	newButton.Height = 80;
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
	newButton.Font = GetFont("bigmenu");
	newButton.TextColor = 0xEEEEEE
	return newButton;
end

function TitleState:OpenSystem()
	self.view:Hide();
	local saveView = SaveView:New("saveView", CurrentState());
	saveView.showSave = false;
	saveView.showTitle = false;
	saveView:Init();
	self.savePresenter = SavePresenter:New();
	self.savePresenter:Init(saveView, saveManager);
	self.savePresenter:SetClosingEvent(
		function()
			Trace("disposing save presenter!");
			self.savePresenter = nil;
			self.view:Show();
		end
	)
end


--entry point
titleState = TitleState:New();
CurrentState().state = titleState;

--extra actions
