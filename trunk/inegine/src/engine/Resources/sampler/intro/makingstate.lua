--character making state

--Import
LoadScript "Resources\\sampler\\components\\dialoguewindow.lua"

MakingState = {}

function MakingState:New()
    local o = {}
	setmetatable(o, self)
	self.__index = self

	self.gamestate = CurrentState();

    self:InitComponents()
    self:RegisterEvents()
    
	return o
end

--Component initialization
function MakingState:InitComponents()
	local gamestate = self.gamestate;
	
	self:SetBackground("Resources/sampler/resources/images/title.jpg");
	
	
	self.frame = View()
	self.frame.Name = "frame"
	self.frame.Width = GetWidth();
	self.frame.Height = GetHeight();
	self.frame.x = 0;
	self.frame.y = 0;
	self.frame.alpha = 255
	self.frame.layer = 1
	
	self.frame.Visible = true
	self.frame.Enabled = true
	AddComponent(self.frame);
		
	local textWindow = TextWindow()
	self.textWindow = textWindow;
	textWindow.Name = "textWin"
	textWindow.Alpha = 155
	textWindow.Width = 350
	textWindow.Height = 200
	textWindow.X = (self.frame.Width - textWindow.Width) / 2;
	textWindow.Y = (self.frame.Height - textWindow.Height) / 2 - 50;
	textWindow.Margin = 20;
	textWindow.LeftMargin = 20;
	textWindow.Layer = 5
	textWindow.LineSpacing = 20
	textWindow.Visible = true
	textWindow.Enabled = true
	textWindow.Font = GetFont("japanese")
	--textWindow.WindowTexture = "Resources/sampler/resources/window.png"
	--textWindow.RectSize = 40;
	
	self.frame:AddComponent(textWindow)
	
	local okButton = Button()
	okButton.Name = "ok"
	okButton.Relative = true;
	okButton.Text = "決定"
	okButton.font = GetFont("japanese");
	okButton.Layer = 6;
	okButton.Width = 100;
	okButton.Height = 40;
	okButton.X = 60
	okButton.Y = textWindow.Height - okButton.Height * 1.5;
	okButton.State = {}
	okButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
			newButton.Pushed = true
		end
	okButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
			end
		end
	okButton.TextColor = 0xFFFFFF;
	textWindow:AddComponent(okButton);
	
	local previousButton = Button()
	previousButton.Name = "prev"
	previousButton.Relative = true;
	previousButton.Text = "前に戻る"
	previousButton.font = GetFont("japanese");
	previousButton.Layer = 6;
	previousButton.Width = 100;
	previousButton.Height = 40;
	previousButton.X = okButton.X + okButton.Width + 10;
	previousButton.Y = textWindow.Height - previousButton.Height * 1.5;
	previousButton.State = {}
	previousButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
			newButton.Pushed = true
		end
	previousButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
			end
		end
	previousButton.TextColor = 0xFFFFFF;
	textWindow:AddComponent(previousButton);
	
	local talkWindow = DialogueWindow:New("talkWindow", self.frame);
	self.talkWindow = talkWindow;
	talkWindow:Init();
	talkWindow.frame.relative = true;
	talkWindow.frame.x = 0;
	talkWindow.layer = 2;
	talkWindow.frame.y = self.frame.height - talkWindow.frame.height;
	talkWindow:Hide();
	
end

function MakingState:RegisterEvents()
	CurrentState().KeyDown = function(handler, luaevent, args) 
		self:KeyDown(handler, luaevent, args);
	end
end

function MakingState:KeyDown(handler, luaevent, args)
	if (self.keyDownEvent ~= nil) then
		self.keyDownEvent(handler, luaevent, args);
	end
end

function MakingState:SetBackground(filename)
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


function MakingState:CreateButton(buttonText, event)
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

function MakingState:Test()
	self.textWindow:Show();
	self.talkWindow:Show();
	self.textWindow.text = "娘の名前を教えてください";
	self.talkWindow:SetDialogueName("규브");
	self.talkWindow:SetDialogueText("あなたの娘がどんな子なのか、教えて頂けますか");
	self.talkWindow:SetPortraitTexture("Resources/sampler/resources/images/f2.png");
end

--entry point
CurrentState().state = MakingState:New();

--extra actions
CurrentState().state:Test();