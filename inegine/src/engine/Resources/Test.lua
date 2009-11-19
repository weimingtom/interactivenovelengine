state = GameState();
AddState(state);

state.id = "test";

window = TextWindow(0x780000FF, 255, 100, 100, 200, 50, 0, "test", 10);
state:AddComponent(window);


function Test()
    TestTest("test.lua");
end;
