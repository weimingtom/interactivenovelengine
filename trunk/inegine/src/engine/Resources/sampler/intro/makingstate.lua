--character making state

--Import
LoadScript "components\\dialoguewindow.lua"

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
	
	self:SetBackground("resources/images/title.jpg");
	
	
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
		
	local windowSprite = SpriteBase();
	self.windowSprite = windowSprite;
	windowSprite.Texture = "resources/ui/character_make_window.png"
	windowSprite.Visible = true;
	windowSprite.Layer = 3;
	windowSprite.X = 244;
	windowSprite.Y = 144;
	windowSprite.Width = 321;
	windowSprite.Height = 257;
	self.frame:AddComponent(windowSprite)
		
	local textWindow = TextWindow()
	self.textWindow = textWindow;
	textWindow.Name = "textWin"
	textWindow.Width = 321
	textWindow.Height = 245
	textWindow.Alpha = 0
	textWindow.X = 0
	textWindow.Y = 0
	textWindow.Margin = 70;
	textWindow.LeftMargin = 70;
	textWindow.Layer = 5
	textWindow.LineSpacing = 30
	textWindow.Visible = true
	textWindow.Enabled = true
	textWindow.TextColor = 0x000000
	textWindow.Font = GetFont("default")
	
	self.windowSprite:AddComponent(textWindow)

	local okButton = Button()
	self.okButton = okButton;
    okButton.Name = "ok"
	okButton.Relative = true;
	okButton.Text = makingstate_next_button
	okButton.font = GetFont("default");
	okButton.Layer = 6;
	okButton.Width = 100;
	okButton.Height = 40;
	okButton.VerticalAlignment = 0;
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
	okButton.TextColor = 0x000000;
	textWindow:AddComponent(okButton);
	
	local previousButton = Button()
    self.previousButton = previousButton;
	previousButton.Name = "prev"
	previousButton.Relative = true;
	previousButton.Text = makingstate_previous_button
	previousButton.font = GetFont("default");
	previousButton.Layer = 6;
	previousButton.Width = 100;
	previousButton.Height = 40;
	previousButton.X = okButton.X + okButton.Width + 10;
	previousButton.Y = textWindow.Height - previousButton.Height * 1.5;
	previousButton.VerticalAlignment = 0;
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
	previousButton.TextColor = 0x000000;
	textWindow:AddComponent(previousButton);
	
	local talkWindow = DialogueWindow:New("talkWindow", self.frame);
	self.talkWindow = talkWindow;
	talkWindow:Init();
	talkWindow.frame.relative = true;
	talkWindow.frame.x = 0;
	talkWindow.layer = 2;
	talkWindow.frame.y = self.frame.height - talkWindow.frame.height;
	talkWindow:Hide();
	
	self.confirmWindow = UIFactory.CreateConfirmWindow(
		system_confirm_title,
		function() saveManager:Title(); end,
		function() self.confirmWindow:Hide() end);
	self.confirmWindow:Hide();
	self.confirmWindow.layer = 10;
	self.frame:AddComponent(self.confirmWindow);
	
	self.backButton = UIFactory.CreateBackButton(
		function (button, luaevent, args)
			self.confirmWindow:Show();
		end
	)
	self.backButton.X = 712
	self.backButton.Y = 455
	self.backButton.Layer = 10
	self.backButton:Hide();
	self.frame:AddComponent(self.backButton);
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
	newButton.font = GetFont("default");
	newButton.Layer = 6;
	newButton.X = x;
	newButton.Y = y;
	newButton.Width = width;
	newButton.Height = height;
	newButton.State = {}
	newButton.TextColor = 0x000000;

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
	self.backButton:Hide();
	
	self.okButton.text = makingstate_next_button
	self.previousButton.Y = self.textWindow.Height - self.previousButton.Height * 1.5;
	self.previousButton.text = makingstate_previous_button;
	self.okButton.Y = self.textWindow.Height - self.okButton.Height * 1.5;
	self.previousButton.enabled = false;
	
	self.windowSprite:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName(makingstate_dialogue_name);
	self.talkWindow:SetPortraitTexture("resources/images/f2.png");
	self.talkWindow:SetDialogueText(makingstate_dialogue_firstname1);
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:AskFirstName();
		end);
		
end

function MakingState:AskFirstName()
	self.backButton:Show();
	
	self.windowSprite:Show();
	self.talkWindow:Hide();
	self.textWindow:Clear();
	self.textWindow.text = makingstate_dialogue_firstname2;
	
    self.daughterName = nil;
    
	local textButton = self:CreateButton("text", "___",
										 0, self.textWindow.Height / 2 + 10,
										 self.textWindow.width, 20);
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
	self.backButton:Hide(); 
	
	self.windowSprite:Hide();
	self.talkWindow:Show();
	
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName(makingstate_dialogue_name);
	self.talkWindow:SetPortraitTexture("resources/images/f2.png");
	self.talkWindow:SetDialogueText(makingstate_dialogue_lastname1);
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:AskLastName();
		end);
end

function MakingState:AskLastName()
	self.backButton:Show(); 
	
	self.windowSprite:Show();
	self.talkWindow:Hide();
	self.previousButton.enabled = true;
	self.textWindow.text = makingstate_dialogue_lastname2;

    self.lastName = nil
    
	local textButton = self:CreateButton("text", "___",
										 0, self.textWindow.Height / 2 + 10,
										 self.textWindow.width, 20);
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
	self.backButton:Hide(); 
	
	self.windowSprite:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName(makingstate_dialogue_name);
	self.talkWindow:SetPortraitTexture("resources/images/f2.png");
	self.talkWindow:SetDialogueText(makingstate_dialogue_birthday1);
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:AskBirthday();
		end);
end

function MakingState:AskBirthday()
	self.backButton:Show(); 
	
	self.windowSprite:Show();
	self.talkWindow:Hide();
	self.textWindow.text = makingstate_dialogue_birthday2;
	
    self.month = nil;
    self.day = nil
	
	local textButton = self:CreateButton("month", "_",
										 85, self.textWindow.Height / 2 + 10,
										 50, 20);
    self.monthButton = textButton;
	textButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
            Trace("mouse down!");
            local text = GetInput(true);
            if (text ~= nil and self:CheckBirthday(tonumber(text), 1)) then
                self.monthButton.text = text;
                self.dayButton.text = "_";
                self.month = text;
                self.day = nil;
            end
		end
	self.textWindow:AddComponent(textButton);

	local textButton = self:CreateButton("monthLabel", makingstate_month_label,
										 135, self.textWindow.Height / 2 + 10,
										 25, 20);
	self.textWindow:AddComponent(textButton);
										 
	local textButton = self:CreateButton("day", "_",
										 190, self.textWindow.Height / 2 + 10,
										 50, 20);
    self.dayButton = textButton;
	textButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
            Trace("mouse down!");
            if (self.monthButton.text ~= "_") then
				local text = GetInput(true);
				if (text ~= nil and self:CheckBirthday(tonumber(self.monthButton.text), tonumber(text))) then
					self.dayButton.text = text;
					self.day = text;
				end
            end
		end
	self.textWindow:AddComponent(textButton);
	
	local textButton = self:CreateButton("dayLabel", makingstate_day_label,
										 240, self.textWindow.Height / 2 + 10,
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
	self.backButton:Hide(); 
	
	self.windowSprite:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName(makingstate_dialogue_name);
	self.talkWindow:SetPortraitTexture("resources/images/f2.png");
	self.talkWindow:SetDialogueText(makingstate_dialogue_bloodtype1);
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:AskBloodType();
		end);
end

function MakingState:AskBloodType()
	self.backButton:Show(); 
	
	self.windowSprite:Show();
	self.talkWindow:Hide();
	self.textWindow.text = makingstate_dialogue_bloodtype2;

    self.bloodType = nil;

	local oButton = self:CreateButton("O", "O",
										 75, self.textWindow.Height / 2 + 10,
										 25, 20);
    self.oButton = oButton;
	self.textWindow:AddComponent(oButton);
	oButton.TextColor = 0xFF0000;
	self.bloodType = "O";
	
	local aButton = self:CreateButton("A", "A",
										 125, self.textWindow.Height / 2 + 10,
										 25, 20);
    self.aButton = aButton;
	self.textWindow:AddComponent(aButton);

	local bButton = self:CreateButton("B", "B",
										 175, self.textWindow.Height / 2 + 10,
										 25, 20);
    self.bButton = bButton;
	self.textWindow:AddComponent(bButton);

	local abButton = self:CreateButton("AB", "AB",
										 225, self.textWindow.Height / 2 + 5,
										 40, 20);
    self.abButton = abButton;
	self.textWindow:AddComponent(abButton);


	self.aButton.MouseDown = 
		function (newButton, luaevent, args)
            oButton.TextColor = 0x000000;
            aButton.TextColor = 0xFF0000;
            bButton.TextColor = 0x000000;
            abButton.TextColor = 0x000000;
			self.bloodType = "A";
		end
	self.bButton.MouseDown = 
		function (newButton, luaevent, args)
            oButton.TextColor = 0x000000;
            aButton.TextColor = 0x000000;
            bButton.TextColor = 0xFF0000;
            abButton.TextColor = 0x000000;
			self.bloodType = "B";
		end
	self.abButton.MouseDown = 
		function (newButton, luaevent, args)
            oButton.TextColor = 0x000000;
            aButton.TextColor = 0x000000;
            bButton.TextColor = 0x000000;
            abButton.TextColor = 0xFF0000;
			self.bloodType = "AB";
		end
	self.oButton.MouseDown = 
		function (newButton, luaevent, args)
            oButton.TextColor = 0xFF0000;
            aButton.TextColor = 0x000000;
            bButton.TextColor = 0x000000;
            abButton.TextColor = 0x000000;
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
	self.backButton:Hide(); 
	
	self.windowSprite:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName(makingstate_dialogue_name);
	self.talkWindow:SetPortraitTexture("resources/images/f2.png");
	self.talkWindow:SetDialogueText(makingstate_dialogue_fathername1);
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:AskFatherName();
		end);
end

function MakingState:AskFatherName()
	self.backButton:Show(); 
	
	self.windowSprite:Show();
	self.talkWindow:Hide();
	self.textWindow.text = makingstate_dialogue_fathername2;

    self.fatherName = nil;
    
	local textButton = self:CreateButton("text", "___",
										 0, self.textWindow.Height / 2 + 10,
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
	self.backButton:Hide(); 
	
	self.windowSprite:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName(makingstate_dialogue_name);
	self.talkWindow:SetPortraitTexture("resources/images/f2.png");
	self.talkWindow:SetDialogueText(makingstate_dialogue_fatherbirthday1);
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:AskFatherBirthday();
		end);
end

function MakingState:AskFatherBirthday()
	self.backButton:Show(); 
	
	self.windowSprite:Show();
	self.talkWindow:Hide();
	self.textWindow.text = makingstate_dialogue_fatherbirthday2;

    self.fatherMonth = nil;
    self.fatherDay = nil;

	local textButton = self:CreateButton("month", "_",
										 85, self.textWindow.Height / 2 + 10,
										 50, 20);
    self.monthButton = textButton;
	textButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
            Trace("mouse down!");
            local text = GetInput(true);
            if (text ~= nil and self:CheckBirthday(tonumber(text), 1)) then
                self.monthButton.text = text;
                self.dayButton.text = "_";
                self.fatherMonth = text;
                self.fatherDay = nil;
            end
		end
	self.textWindow:AddComponent(textButton);

	local textButton = self:CreateButton("monthLabel", makingstate_month_label,
										 135, self.textWindow.Height / 2 + 10,
										 25, 20);
	self.textWindow:AddComponent(textButton);
										 
	local textButton = self:CreateButton("day", "_",
										 190, self.textWindow.Height / 2 + 10,
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
	
	local textButton = self:CreateButton("dayLabel", makingstate_day_label,
										 240, self.textWindow.Height / 2 + 10,
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
	self.backButton:Hide(); 
	
	self.windowSprite:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName(makingstate_dialogue_name);
	self.talkWindow:SetPortraitTexture("resources/images/f2.png");
	self.talkWindow:SetDialogueText(makingstate_dialogue_summary1);
	self.talkWindow:SetDialogueOverEvent(
		function()
			self:Summary();
		end);
end

function MakingState:Summary()
	self.backButton:Show(); 
	
	self.okButton.text = makingstate_dialogue_summary_ok;
	self.okButton.Y = 175
	self.previousButton.text = makingstate_dialogue_summary_decline;
	self.previousButton.Y = 175
	self.windowSprite:Show();
	self.talkWindow:Hide();
	self.textWindow.font = GetFont("verysmall");
	self.textWindow.text = makingstate_dialogue_summary_daughter_name .. self.daughterName .. "\n" ..
	makingstate_dialogue_summary_last_name .. self.lastName .. "\n" ..
	makingstate_dialogue_summary_birthday .. self.month .. makingstate_month_label ..  self.day .. makingstate_day_label .. "\n" ..
	makingstate_dialogue_summary_bloodtype .. self.bloodType .. "\n" ..
	makingstate_dialogue_summary_fathername .. self.fatherName .. "\n" ..
	makingstate_dialogue_summary_fatherbirthday .. self.fatherMonth .. makingstate_month_label ..  self.fatherDay .. makingstate_day_label .. "\n" ..
	makingstate_dialogue_summary_confirm;
	
    self:SetOKEvent(
        function()
            Trace("OK!");
			self.textWindow.font = GetFont("default");  
            self:PromptFinish();
        end
    );
    self:SetPrevEvent(
        function()
            Trace("Cancel!");
			self.textWindow.font = GetFont("default");
            self:PromptReset();
        end
    );
end

function MakingState:PromptFinish()
	self.backButton:Hide(); 
	
	self.windowSprite:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName(makingstate_dialogue_name);
	self.talkWindow:SetPortraitTexture("resources/images/f2.png");
	self.talkWindow:SetDialogueText(makingstate_dialogue_finish);
	self.talkWindow:SetDialogueOverEvent(
		function()
			Trace("finished!");
			self:ApplyConfiguration();
			
		    FadeOut(500)
			Delay(500,
			function()
				CloseState();
				OpenState("main", "main/main.lua");
				FadeIn(500)
			end);
		end);
end

function MakingState:PromptReset()
	self.backButton:Hide(); 
	
	self.windowSprite:Hide();
	self.talkWindow:Show();
    self.talkWindow:ClearDialogueText();
	self.talkWindow:SetDialogueName(makingstate_dialogue_name);
	self.talkWindow:SetPortraitTexture("resources/images/f2.png");
	self.talkWindow:SetDialogueText(makingstate_dialogue_reset);
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