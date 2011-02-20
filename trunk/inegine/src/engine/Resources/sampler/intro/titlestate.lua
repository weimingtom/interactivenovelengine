--title state
--Import

TitleState = {}

function TitleState:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self

	self.gamestate = CurrentState();

    self:InitComponents()
    self:RegisterEvents()
    
	return o
end

--Component initialization
function TitleState:InitComponents()
	local gamestate = self.gamestate;
	
	self:SetBackground("Resources/sampler/resources/images/title.jpg");
	
	local titleText = Label();
	titleText.Name = "title";
	titleText.X = 75;
	titleText.Y = 75;
	titleText.Alignment = 0;
	titleText.VerticalAlignment = 0;
	titleText.Width = 640;
	titleText.Height = 240;
	titleText.Text = "体験版";
	titleText.Font = GetFont("verylarge");
	titleText.TextColor = 0xEEEEEE
	titleText.Layer = 3
	AddComponent(titleText);	
	
	local newGameButton = self:CreateButton("New Game",
		function (button, luaevent, args)
			Trace("new game button clicked!");
			CloseState();
			OpenState("making", "Resources/Sampler/intro/makingstate.lua");
		end);
	newGameButton.X = 550;
	newGameButton.Y = 300;
	AddComponent(newGameButton);
	
	local continueButton = self:CreateButton("Continue Game",
		function (button, luaevent, args)
			Trace("continue button clicked!");
		end);
	continueButton.X = 550;
	continueButton.Y = 350;
	AddComponent(continueButton);
	
	local omakeButton = self:CreateButton("Omake",
		function (button, luaevent, args)
			Trace("omake button clicked!");
		end);
	omakeButton.X = 550;
	omakeButton.Y = 400;
	AddComponent(omakeButton);
	
	
	local exitButton = self:CreateButton("Exit",
		function (button, luaevent, args)
			Trace("exit button clicked!");
		end);
	exitButton.X = 550;
	exitButton.Y = 450;
	AddComponent(exitButton);
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


--entry point
titleState = TitleState:New();
CurrentState().state = titleState;

--extra actions