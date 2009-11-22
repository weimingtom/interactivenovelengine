function EventHandler(target, luaevent, args)
    state = target;
    if luaevent == ScriptEvents.KeyPress 
        then 
            --TestTest(state.id);
            --TestTest(args);
            --TestTest(state.guiComponents["win1"].id)
            --state.guiComponents["win1"]
            --SwitchState("test2");
    end
end

InitState("test");

AddComponent(TextWindow("win1", 0x780000FF, 255, 100, 100, 
                        200, 50, 0, "test", 10));
AddComponent(ImageWindow("win2", 0x7800FF44, 155, 250, 120, 
                         400, 400, 0, "테스트입니다...", 10));
