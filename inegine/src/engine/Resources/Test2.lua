function EventHandler(target, luaevent, args)
    state = target;
    if luaevent == ScriptEvents.KeyPress 
        then 
            TestTest(state.id);
            TestTest(args);
            SwitchState("test");
    end
end

InitState("test2");

AddComponent(SpriteBase("Resources/bg.png", 0, 0, 0, 0, 0, 800, 600,
                        false));
AddComponent(TextWindow(0x780000FF, 255, 100, 100, 
                        200, 50, 0, "test", 10));
AddComponent(ImageWindow(0x78FF0000, 155, 150, 120, 
                         200, 50, 0, "테스트입니다...", 10));
