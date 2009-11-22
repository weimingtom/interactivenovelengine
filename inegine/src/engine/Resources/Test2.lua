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

function mouseMove(state, luaevent, args)
    if state.state.locked == true then
        state.x = state.x + args[0] - state.state.prevx;
        state.y = state.y + args[1] - state.state.prevy;

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
    state:BeginNarrate([[Hello world, test
test test test3]], 100);
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

--start initiation
InitState("test2");

state.eventHandler = test;--EventHandler;
state.mouseDownEventHandler = MouseDownHandler;
state.mouseUpEventHandler = MouseUpHandler;
state.mouseMoveEventHandler = mouseMove;
state.keyDownHandler = KeyDownHandler;
state.state = {"Hello", " ", "World"};

sprite = SpriteBase("sprite1", "Resources/bg.png", 0, 0, 0, 0, 0, 800, 600,
                    false);
sprite.mouseDownEventHandler = mouseDown;
sprite.mouseUpEventHandler = mouseUp;
sprite.mouseMoveEventHandler = mouseMove
sprite.mouseClickEventHandler = test;
sprite.state = {}
sprite.state.locked = false;
sprite.state.prevx = 0;
sprite.state.prevy = 0;
AddComponent(sprite);

imagewindow = ImageWindow("win2", 0x78FF0000, 155, 150, 120, 
                         200, 50, 1, "테스트입니다...", 10)
imagewindow.mouseDownEventHandler = mouseDown;
imagewindow.mouseUpEventHandler = mouseUp;
imagewindow.mouseMoveEventHandler = mouseMove;
imagewindow.mouseClickEventHandler = mouseClick;
imagewindow.state = {}
imagewindow.state.locked = false;
imagewindow.state.prevx = 0;
imagewindow.state.prevy = 0;
AddComponent(imagewindow);

textwindow = TextWindow("win1", 0x780000FF, 155, 200, 200, 
                        300, 250, 2, "", 10);
textwindow.mouseDownEventHandler = mouseDown;
textwindow.mouseUpEventHandler = mouseUp;
textwindow.mouseMoveEventHandler = mouseMove;
textwindow.mouseClickEventHandler = mouseClick;
textwindow.state = {}
textwindow.state.locked = false;
textwindow.state.prevx = 0;
textwindow.state.prevy = 0;
AddComponent(textwindow);
