function BeginESS(script)
	Trace(script)
	Trace "trying to load another script..."
	local co = coroutine.create(assert(loadstring(LoadESS(script))))
	Trace "resuming!..."
	CurrentState().state["ess"] = co;
	ResumeEss();
end

function ResumeEss()
	if (CurrentState().state["ess"] ~= nul) then
	coroutine.resume(CurrentState().state["ess"]);
	end
end

function YieldESS()
	coroutine.yield();
end

function LoadCharacter(id, image)
	local status, newCharacter = pcall(SpriteBase, id, image, 0, 0, 1, true);
	if (status) then
		newCharacter.x = (GetWidth() - newCharacter.width)/2;
		newCharacter.y = (GetHeight() - newCharacter.height);
		AddComponent(newCharacter);
		Trace("loading " .. id .. " done");
	else
		Trace("loading " .. id .. " failed");
	end
end

function MoveCharacter(id, x)
	local component = GetComponent(id)
	if (component ~= nil) then
		component.x = x;
	else
		Trace("invalid id: " .. id);
	end
end
 
function ShowCharacter(id, delay)
	local component = GetComponent(id)
	if (component ~= nil) then
		component:LaunchTransition(delay, true) 
	else
		Trace("invalid id: " .. id);
	end
end

function HideCharacter(id, delay)
	local component = GetComponent(id)
	if (component ~= nil) then
		component:LaunchTransition(delay, false)	
	else
		Trace("invalid id: " .. id);
	end
end

function Dissolve(id1, id2)
	ShowCharacter(id2, 0)
	HideCharacter(id1, 500)
end

function MouseDownHandler(state, luaevent, args)
    Trace("mouse down!");
end

function MouseUpHandler(state, luaevent, args)
    Trace("mouse up!");
end

function KeyDownHandler(state, luaevent, args)
    Trace(state.id);
    Trace(args[0]);
end

function cursorHandler(state, luaevent, args)
	animatedsprite.x = args[0] + 1;
	animatedsprite.y = args[1] + 1;
end

function mouseMove(state, luaevent, args)
    if state.state.locked == true then
        --state.x = state.x + args[0] - state.state.prevx;
        --state.y = state.y + args[1] - state.state.prevy;

        state.state.prevx = args[0];
        state.state.prevy = args[1];
    end
end

function mouseDown(state, luaevent, args)
    Trace(state.id .. " mouse down!")
    state.state.locked = true;
    state.state.prevx = args[0];
    state.state.prevy = args[1];
end;

function mouseUp(state, luaevent, args)
    Trace(state.id .. " mouse up!")
    state.state.locked = false; 
end;

function mouseClick(state, luaevent, args)
    Trace(state.id .. " mouse click!")
    Trace("advancing!");
    state:AdvanceText();
    PlaySound("click", false);
    --state:BeginNarrate("Hello world, test\ntest test test3", 100);
end;

function test(state, luaevent, args)
if (state.fading == false) then
    if (state.FadedOut == false) then
        Trace("fading in!");
        state:LaunchTransition(2000, false);
    else
        Trace("fading out!");
        state:LaunchTransition(1000, true);
    end
end
end

function update(state, luaevent, args)
--    Trace("update event!");
end

function test(state, luaevent, args)
	Trace("test!");
end

function textOver(state, luaevent, args)
	Trace("textout over!");
	Trace("attempting to load more ess");
	ResumeEss();
end

function Clear()
	textwindow:Clear();
end

function TextOut(value)
	if(textwindow:Print(value)) then
		YieldESS();
		--coroutine.yield();
	end
end


function animationOver(state, luaevent, args)
    Trace("animation " .. args[0] .. " over");
    --state:BeginAnimation(100, 4, 7, false);
    --startAnimation(state);
    --coroutine.resume(co)
end

function startAnimation(sprite)
    Trace "starting animation!"
    startTime = sprite:BeginAnimation(100, 0, 15, false);
    Trace("animation " .. startTime .. " started");
    YieldEss();
end

function spriteclick(state, luaevent, args)
    --Trace("frame: " .. state.frame);
    ResumeEss();
    --if (state.inAnimation) then
    --    state:StopAnimation();
    --else
    --    state.animationOverHandler = animationOver;
    --    startAnimation(state);
    --end
    --Trace("frame: " .. state.frame);
end

function foo(sprite)
    Trace "first ani"
    startAnimation(sprite);
    YieldEss();
    Trace "second ani"
    startAnimation(sprite);
    YieldEss();
    Trace "third ani"
    startAnimation(sprite);
    YieldEss();
    Trace "last ani"
    startAnimation(sprite);
end

--start initiation
InitState("test2");
state = CurrentState();
state.mouseMoveEventHandler = cursorHandler;
state.state = {"Hello", " ", "World"};

sprite = SpriteBase("sprite1", "Resources/daughterroom.png", 0, 0, 0, false);
sprite.mouseDownEventHandler = mouseDown;
sprite.mouseUpEventHandler = mouseUp;
sprite.mouseMoveEventHandler = mouseMove
sprite.mouseClickEventHandler = test;
sprite.state = {}
sprite.state.locked = false;
sprite.state.prevx = 0;
sprite.state.prevy = 0;
AddComponent(sprite);


--LoadCharacter("daughtersprite", "Resources/testsprite.png");
--ShowCharacter("daughtersprite", 500);
--daughter = SpriteBase("daughtersprite", "Resources/testsprite.png", (800-512)/2, (600-512), 1, true);
--AddComponent(daughter);
--daughter:LaunchTransition(500, true);

--imagewindow = ImageWindow("win2", 0x78FF0000, 155, 150, 120, 
--                         200, 50, 1, "테스트입니다...", 10);
--imagewindow.mouseDownEventHandler = mouseDown;
--imagewindow.mouseUpEventHandler = mouseUp;
--imagewindow.mouseMoveEventHandler = mouseMove;
--imagewindow.mouseClickEventHandler = mouseClick;
--imagewindow.state = {}
--imagewindow.state.locked = false;
--imagewindow.state.prevx = 0;
--imagewindow.state.prevy = 0;
--AddComponent(imagewindow);


--textwindow = TextWindow("win1", 0x780000FF, 155, 20, 370, 
--                        760, 210, 2, "", 10);
                        
textwindow = TextWindow("win2", 0x000000, 55, 20, 370, 
                          760, 210, 2, "", 25, true, 10);
textwindow.mouseDownEventHandler = mouseDown;
textwindow.mouseUpEventHandler = mouseUp;
textwindow.mouseMoveEventHandler = mouseMove;
textwindow.mouseClickEventHandler = mouseClick;
textwindow.printOverHandler = textOver;
textwindow.state = {}
textwindow.state.locked = false;
textwindow.state.prevx = 0;
textwindow.state.prevy = 0;
AddComponent(textwindow);


function selectResult(caller, luaevent, args)
	--testwindow.enabled = false;
	result = caller.state.number;
	Trace("Selected: " .. result)
end

result = -1;

testwindow = TextWindow("testwin", 0x000000, 15, 20, 20, 
                          200, 200, 2, "", 25, false, 10);
testwindow.isStatic = true;
testwindow.lineSpacing = 10;
AddComponent(testwindow);

childwindow = ImageWindow("testwin2", 0xFF0000, 25, 45, 45, 
                          150, 75, 3, "선택지1", 18, false, 15);
childwindow.isStatic = true;
childwindow.lineSpacing = 10;
childwindow.centerText = true;
childwindow.state = {}
childwindow.state.number = 1;
childwindow.mouseClickEventHandler = selectResult;
--testwindow:AddComponent(childwindow);
AddComponent(childwindow);
childwindow = ImageWindow("testwin3", 0xFF0000, 25, 45, 130, 
                          150, 75, 3, "선택지2", 18, false, 15);
childwindow.isStatic = true;
childwindow.lineSpacing = 10;
childwindow.centerText = true;
childwindow.state = {}
childwindow.state.number = 2;
childwindow.mouseClickEventHandler = selectResult;
--testwindow:AddComponent(childwindow);
AddComponent(childwindow);



--co = coroutine.create(assert(loadstring(LoadESS("Resources/test.ess"))))
--coroutine.resume(co);

animatedsprite = AnimatedSprite("sprite2", "Resources/sprite.png", 0, 0, 4, 
                            4, 4, 32, 48, false);
--animatedsprite.mouseClickEventHandler = spriteclick;
--animatedsprite.mouseDownEventHandler = mouseDown;
--animatedsprite.mouseUpEventHandler = mouseUp;
--animatedsprite.mouseMoveEventHandler = mouseMove;
animatedsprite.animationOverHandler = animationOver;
animatedsprite.state = {}
animatedsprite.state.locked = false;
animatedsprite.state.prevx = 0;
animatedsprite.state.prevy = 0;
AddComponent(animatedsprite);

--LoadSound("sound1", "Resources/MusicMono.wav");
--LoadSound("sound1", "Resources/Track02.mp3");

--LoadSound("click", "Resources/click.wav");
--PlaySound("sound1", true);
--PlaySound("click", true);

counter = 0;


--LoadCharacter("musume1", "Resources/before.pn");
--ShowCharacter("musume", 100);


BeginESS("Resources/test.ess");