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
	coroutine.resume(co);
end

function Clear()
	textwindow:Clear();
end

function TextOut(value)
	Trace(value);
	if(textwindow:Print(value)) then
		Trace("yielding!");
		coroutine.yield();
	end
	Trace("yielding over!");
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
    coroutine.yield()
end

function spriteclick(state, luaevent, args)
    --Trace("frame: " .. state.frame);
    coroutine.resume(co)
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
    coroutine.yield()
    Trace "second ani"
    startAnimation(sprite);
    coroutine.yield()
    Trace "third ani"
    startAnimation(sprite);
    coroutine.yield()
    Trace "last ani"
    startAnimation(sprite);
end

--start initiation
InitState("test2");
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
                        
textwindow = TextWindow("win2", 0x00000000, 55, 20, 370, 
                          760, 210, 2, "", 10);
textwindow.mouseDownEventHandler = mouseDown;
textwindow.mouseUpEventHandler = mouseUp;
textwindow.mouseMoveEventHandler = mouseMove;
textwindow.mouseClickEventHandler = mouseClick;
textwindow.printOverHandler = textOver;
textwindow.state = {}
textwindow.state.locked = false;
textwindow.state.prevx = 0;
textwindow.state.prevy = 0;
textwindow:TurnOnNarration();
AddComponent(textwindow);


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
LoadSound("sound1", "Resources/Track02.mp3");

LoadSound("click", "Resources/click.wav");
PlaySound("sound1", true);
--PlaySound("click", true);

BeginESS("Resources/test.ess");