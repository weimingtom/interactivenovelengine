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
    self:ResetValues();
    
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
	textWindow.LineSpacing = 30
	textWindow.Visible = true
	textWindow.Enabled = true
	textWindow.Font = GetFont("japanese")
	--textWindow.WindowTexture = "Resources/sampler/resources/window.png"
	--textWindow.RectSize = 40;
	
	self.frame:AddComponent(textWindow)

	local okButton = Button()
	self.okButton = okButton;
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
    self.previousButton = previousButton;
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
		self:KeyDown(handler, luaevent, args)
	end
end

function MakingState:KeyDown(handler, luaevent, args)
	Trace("key down : " .. args[0]);
	local code = args[0];
	if (code == 32) then --space
		self.talkWindow:Advance();
	end
end

function MakingState:HandlePrev()
    if (self.prevEvent ~= nil) then
        self.prevEvent();
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


function MakingState:CreateButton(name, text, x, y, width, height)
	local newButton = Button()
	newButton.Name = name
	newButton.Relative = true;
	newButton.Text = text
	newButton.font = GetFont("japanese");
	newButton.Layer = 6;
	newButton.X = x;
	newButton.Y = y;
	newButton.Width = width;
	newButton.Height = height;
	newButton.State = {}
	newButton.TextColor = 0xFFFFFF;

	return newButton;
end

function MakingState:SetOKEvent(event)
	self.okButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
                event();
            end
		end    
end

function MakingState:SetPrevEvent(event)
	self.previousButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
                event();
            end
		end    
end

function MakingState:ResetValues()
    self.daughterName = nil;
    self.lastName = nil;
    self.month = nil;
    self.day = nil;
    self.bloodType = nil
    self.fatherName = nil;
    self.fatherMonth = nil;
    self.fatherDay = nil;
end

function MakingState:PromptFirstName()
	self.textWindow.Height = 200;
	self.okButton.text = "決定";
	self.previousButton.Y = self.textWindow.Height - self.previousButton.Height * 1.5;
	self.previousButton.text = "前に戻る";
	self.okButton.Y = self.textWindow.Height - self.okButton.Height * 1.5;
	self.previousButton.enabled = false;
	
	self.textWindow:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName("규브");
	self.talkWindow:SetPortraitTexture("Resources/sampler/resources/images/f2.png");
	self.talkWindow:SetDialogueText("あなたの娘がどんな子なのか、教えて頂けますか？@\nまず、名前は？@");
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:AskFirstName();
		end);
end

function MakingState:AskFirstName()
	self.textWindow:Show();
	self.talkWindow:Hide();
	self.textWindow:Clear();
	self.textWindow.text = "娘の名前を教えてください";
	
    self.daughterName = nil;
    
	local textButton = self:CreateButton("text", "__________",
										 0, self.textWindow.Height / 2 - 10,
										 350, 20);
    self.textButton = textButton;
	self.textWindow:AddComponent(textButton);
	self.textButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
            Trace("mouse down!");
            local text = GetInput(false);
            if (text ~= nil) then
                self.textButton.text = text;
                self.daughterName = text;
            end
		end
    
    self:SetOKEvent(
        function()
            if (self.daughterName ~= nil) then 
				Trace("OK!");
				self.textWindow:RemoveComponent("text");  
				self:PromptLastName();
			end
        end
    );
    self:SetPrevEvent(
        function()
			self.textWindow:RemoveComponent("text");  
            Trace("Cancel!");  
        end
    );
end

function MakingState:PromptLastName()
	self.textWindow:Hide();
	self.talkWindow:Show();
	
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName("규브");
	self.talkWindow:SetPortraitTexture("Resources/sampler/resources/images/f2.png");
	self.talkWindow:SetDialogueText("娘の苗字も教えて頂けましょうか？@");
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:AskLastName();
		end);
end

function MakingState:AskLastName()
	self.textWindow:Show();
	self.talkWindow:Hide();
	self.previousButton.enabled = true;
	self.textWindow.text = "娘の苗字を教えてください。";

    self.lastName = nil
    
	local textButton = self:CreateButton("text", "__________",
										 0, self.textWindow.Height / 2 - 10,
										 350, 20);
    self.textButton = textButton;
	self.textButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
            Trace("mouse down!");
            local text = GetInput(false);
            if (text ~= nil) then
                self.textButton.text = text;
                self.lastName = text;
            end
		end
	self.textWindow:AddComponent(textButton);
	
    self:SetOKEvent(
        function()
            if (self.lastName ~= nil) then 
				Trace("OK!"); 
				self.textWindow:RemoveComponent("text");  
				self:PromptBirthday();
			end
        end
    );
    self:SetPrevEvent(
        function()
            Trace("Cancel!");  
			self.textWindow:RemoveComponent("text");  
			self:PromptFirstName();
        end
    );
end

function MakingState:PromptBirthday()
	self.textWindow:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName("규브");
	self.talkWindow:SetPortraitTexture("Resources/sampler/resources/images/f2.png");
	self.talkWindow:SetDialogueText("なるほど。\nでは、娘の誕生日は？@");
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:AskBirthday();
		end);
end

function MakingState:AskBirthday()
	self.textWindow:Show();
	self.talkWindow:Hide();
	self.textWindow.text = "娘の誕生日を教えてください。";
	
    self.month = nil;
    self.day = nil
	
	local textButton = self:CreateButton("month", "__",
										 85, self.textWindow.Height / 2 - 10,
										 50, 20);
    self.monthButton = textButton;
	textButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
            Trace("mouse down!");
            local text = GetInput(true);
            if (text ~= nil and self:CheckBirthday(tonumber(text), 1)) then
                self.monthButton.text = text;
                self.dayButton.text = "__";
                self.month = text;
                self.day = nil;
            end
		end
	self.textWindow:AddComponent(textButton);

	local textButton = self:CreateButton("monthLabel", "月",
										 135, self.textWindow.Height / 2 - 10,
										 25, 20);
	self.textWindow:AddComponent(textButton);
										 
	local textButton = self:CreateButton("day", "__",
										 190, self.textWindow.Height / 2 - 10,
										 50, 20);
    self.dayButton = textButton;
	textButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
            Trace("mouse down!");
            if (self.monthButton.text ~= "__") then
				local text = GetInput(true);
				if (text ~= nil and self:CheckBirthday(tonumber(self.monthButton.text), tonumber(text))) then
					self.dayButton.text = text;
					self.day = text;
				end
            end
		end
	self.textWindow:AddComponent(textButton);
	
	local textButton = self:CreateButton("dayLabel", "日",
										 240, self.textWindow.Height / 2 - 10,
										 25, 20);
										 
	self.textWindow:AddComponent(textButton);


    self:SetOKEvent(
        function()
			if (self:CheckBirthday(tonumber(self.month), tonumber(self.day))) then
				Trace("OK!"); 
				self.textWindow:RemoveComponent("month");
				self.textWindow:RemoveComponent("monthLabel");
				self.textWindow:RemoveComponent("day");
				self.textWindow:RemoveComponent("dayLabel");  
				self:PromptBloodType();
	        end
        end
    );
    self:SetPrevEvent(
        function()
            Trace("Cancel!");
        	self.textWindow:RemoveComponent("month");
			self.textWindow:RemoveComponent("monthLabel");
			self.textWindow:RemoveComponent("day");
			self.textWindow:RemoveComponent("dayLabel");  
            self:PromptLastName();  
        end
    );
end

function MakingState:CheckBirthday(month, day)
	return calendar:Validate(0, month, day);
end

function MakingState:PromptBloodType()
	self.textWindow:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName("규브");
	self.talkWindow:SetPortraitTexture("Resources/sampler/resources/images/f2.png");
	self.talkWindow:SetDialogueText("では、血液型は？@");
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:AskBloodType();
		end);
end

function MakingState:AskBloodType()
	self.textWindow:Show();
	self.talkWindow:Hide();
	self.textWindow.text = "娘の血液型は？";

    self.bloodType = nil;

	local oButton = self:CreateButton("O", "O",
										 75, self.textWindow.Height / 2 - 10,
										 25, 20);
    self.oButton = oButton;
	self.textWindow:AddComponent(oButton);
	oButton.TextColor = 0xFF0000;
	self.bloodType = "O";
	
	local aButton = self:CreateButton("A", "A",
										 125, self.textWindow.Height / 2 - 10,
										 25, 20);
    self.aButton = aButton;
	self.textWindow:AddComponent(aButton);

	local bButton = self:CreateButton("B", "B",
										 175, self.textWindow.Height / 2 - 10,
										 25, 20);
    self.bButton = bButton;
	self.textWindow:AddComponent(bButton);

	local abButton = self:CreateButton("AB", "AB",
										 225, self.textWindow.Height / 2 - 10,
										 40, 20);
    self.abButton = abButton;
	self.textWindow:AddComponent(abButton);


	self.aButton.MouseDown = 
		function (newButton, luaevent, args)
            oButton.TextColor = 0xFFFFFF;
            aButton.TextColor = 0xFF0000;
            bButton.TextColor = 0xFFFFFF;
            abButton.TextColor = 0xFFFFFF;
			self.bloodType = "A";
		end
	self.bButton.MouseDown = 
		function (newButton, luaevent, args)
            oButton.TextColor = 0xFFFFFF;
            aButton.TextColor = 0xFFFFFF;
            bButton.TextColor = 0xFF0000;
            abButton.TextColor = 0xFFFFFF;
			self.bloodType = "B";
		end
	self.abButton.MouseDown = 
		function (newButton, luaevent, args)
            oButton.TextColor = 0xFFFFFF;
            aButton.TextColor = 0xFFFFFF;
            bButton.TextColor = 0xFFFFFF;
            abButton.TextColor = 0xFF0000;
			self.bloodType = "AB";
		end
	self.oButton.MouseDown = 
		function (newButton, luaevent, args)
            oButton.TextColor = 0xFF0000;
            aButton.TextColor = 0xFFFFFF;
            bButton.TextColor = 0xFFFFFF;
            abButton.TextColor = 0xFFFFFF;
			self.bloodType = "O";
		end
	
    self:SetOKEvent(
        function()
            if (self.bloodType ~= nil) then
				Trace("OK!"); 
				self.textWindow:RemoveComponent("A");
				self.textWindow:RemoveComponent("B");
				self.textWindow:RemoveComponent("AB");
				self.textWindow:RemoveComponent("O");
				self:PromptFatherName();
			end
        end
    );
    self:SetPrevEvent(
        function()
            Trace("Cancel!");
			self.textWindow:RemoveComponent("A");
			self.textWindow:RemoveComponent("B");
			self.textWindow:RemoveComponent("AB");
			self.textWindow:RemoveComponent("O");
            self:PromptBirthday();
        end
    );
end

function MakingState:PromptFatherName()
	self.textWindow:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName("규브");
	self.talkWindow:SetPortraitTexture("Resources/sampler/resources/images/f2.png");
	self.talkWindow:SetDialogueText("あなたの名前を教えてくれませんか？@");
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:AskFatherName();
		end);
end

function MakingState:AskFatherName()
	self.textWindow:Show();
	self.talkWindow:Hide();
	self.textWindow.text = "あなたの名前は？";

    self.fatherName = nil;
    
	local textButton = self:CreateButton("text", "__________",
										 0, self.textWindow.Height / 2 - 10,
										 350, 20);
    self.textButton = textButton;
	self.textButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
            Trace("mouse down!");
            local text = GetInput(false);
            if (text ~= nil) then
                self.textButton.text = text;
                self.fatherName = text;
            end
		end
	self.textWindow:AddComponent(textButton);
	
    self:SetOKEvent(
        function()
            if (self.fatherName ~= nil) then 
				Trace("OK!"); 
				self.textWindow:RemoveComponent("text");  
				self:PromptFatherBirthday();
			end
        end
    );
    self:SetPrevEvent(
        function()
            Trace("Cancel!"); 
			self.textWindow:RemoveComponent("text");  
            self:PromptBloodType();
        end
    );
end

function MakingState:PromptFatherBirthday()
	self.textWindow:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName("규브");
	self.talkWindow:SetPortraitTexture("Resources/sampler/resources/images/f2.png");
	self.talkWindow:SetDialogueText("あなたの誕生日は？@");
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:AskFatherBirthday();
		end);
end

function MakingState:AskFatherBirthday()
	self.textWindow:Show();
	self.talkWindow:Show();
	self.textWindow.text = "あなたの誕生日を教えてください";

    self.fatherMonth = nil;
    self.fatherDay = nil;

	local textButton = self:CreateButton("month", "__",
										 85, self.textWindow.Height / 2 - 10,
										 50, 20);
    self.monthButton = textButton;
	textButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
            Trace("mouse down!");
            local text = GetInput(true);
            if (text ~= nil and self:CheckBirthday(tonumber(text), 1)) then
                self.monthButton.text = text;
                self.dayButton.text = "__";
                self.fatherMonth = text;
                self.fatherDay = nil;
            end
		end
	self.textWindow:AddComponent(textButton);

	local textButton = self:CreateButton("monthLabel", "月",
										 135, self.textWindow.Height / 2 - 10,
										 25, 20);
	self.textWindow:AddComponent(textButton);
										 
	local textButton = self:CreateButton("day", "__",
										 190, self.textWindow.Height / 2 - 10,
										 50, 20);
    self.dayButton = textButton;
	textButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
            Trace("mouse down!");
            local text = GetInput(true);
			if (text ~= nil and self:CheckBirthday(tonumber(self.fatherMonth), tonumber(text))) then
				self.dayButton.text = text;
				self.fatherDay = text;
			end
		end
	self.textWindow:AddComponent(textButton);
	
	local textButton = self:CreateButton("dayLabel", "日",
										 240, self.textWindow.Height / 2 - 10,
										 25, 20);
										 
	self.textWindow:AddComponent(textButton);


    self:SetOKEvent(
        function()
            if (self:CheckBirthday(tonumber(self.fatherMonth), tonumber(self.fatherDay))) then	
				Trace("OK!"); 
				self.textWindow:RemoveComponent("month");
				self.textWindow:RemoveComponent("monthLabel");
				self.textWindow:RemoveComponent("day");
				self.textWindow:RemoveComponent("dayLabel");  
				self:PromptSummary();
			end
        end
    );
    self:SetPrevEvent(
        function()
            Trace("Cancel!");  
			self.textWindow:RemoveComponent("month");
			self.textWindow:RemoveComponent("monthLabel");
			self.textWindow:RemoveComponent("day");
			self.textWindow:RemoveComponent("dayLabel"); 
            self:PromptFatherName();
        end
    );
end

function MakingState:PromptSummary()
	self.textWindow:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName("규브");
	self.talkWindow:SetPortraitTexture("Resources/sampler/resources/images/f2.png");
	self.talkWindow:SetDialogueText("これで間違いありませんか？@");
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:Summary();
		end);
end

function MakingState:Summary()
	self.textWindow.Height = 300;
	self.okButton.text = "はい";
	self.okButton.Y = self.textWindow.Height - self.okButton.Height * 1.5;
	self.previousButton.text = "いいえ";
	self.previousButton.Y = self.textWindow.Height - self.previousButton.Height * 1.5;
	self.textWindow:Show();
	self.talkWindow:Hide();
	self.textWindow.text = "娘の名前 : " .. self.daughterName .. "\n" ..
	"苗字 : " .. self.lastName .. "\n" ..
	"誕生日 : " .. self.month .. "月" ..  self.day .. "日\n" ..
	"血液型 : " .. self.bloodType .. "\n" ..
	"あなたの名前 : " .. self.fatherName .. "\n" ..
	"あなたの誕生日 :" .. self.fatherMonth .. "月" ..  self.fatherDay .. "日\n" ..
	"\n以上で宜しいですか？";
	
    self:SetOKEvent(
        function()
            Trace("OK!");  
            self:PromptFinish();
        end
    );
    self:SetPrevEvent(
        function()
            Trace("Cancel!");
            self:PromptReset();
        end
    );
end

function MakingState:PromptFinish()
	self.textWindow:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName("규브");
	self.talkWindow:SetPortraitTexture("Resources/sampler/resources/images/f2.png");
	self.talkWindow:SetDialogueText("分かりました\nでは、あなたの娘の物語を始めましょう。@");
	self.talkWindow:SetDialogueOverEvent(
		function()
			Trace("finished!");
			self:ApplyConfiguration();
			CloseState();
			OpenState("main", "Resources/Sampler/main/main.lua");
		end);
end

function MakingState:PromptReset()
	self.textWindow:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName("규브");
	self.talkWindow:SetPortraitTexture("Resources/sampler/resources/images/f2.png");
	self.talkWindow:SetDialogueText("間違ったところを指摘してくれれば、やり直せます。@");
	self.talkWindow:SetDialogueOverEvent(
		function()
		    self:ResetValues();
			self:PromptFirstName();
		end);
end


function MakingState:ApplyConfiguration()
	character:SetFirstName(self.daughterName);
	character:SetLastName(self.lastName);
	character:SetBirthday(self.month, self.day);
	character:SetBloodtype(self.bloodType);
	character:SetFatherName(self.fatherName);
	character:SetFatherBirthday(self.fatherMonth, self.fatherDay);
end

--entry point

makingState = MakingState:New();
CurrentState().state = makingState;

--extra actions
makingState:PromptFirstName();