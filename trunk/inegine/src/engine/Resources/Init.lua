luanet.load_assembly("System.Windows.Forms");
luanet.load_assembly("INovelEngine");
GameState = luanet.import_type("INovelEngine.StateManager.GameState");
TextWindow = luanet.import_type("INovelEngine.Effector.TextWindow");
ImageWindow = luanet.import_type("INovelEngine.Effector.ImageWindow");
SpriteBase = luanet.import_type("INovelEngine.Effector.SpriteBase");
AnimatedSprite = luanet.import_type("INovelEngine.Effector.AnimatedSprite")
ScriptEvents = luanet.import_type("INovelEngine.Script.ScriptEvents");

function InitState(id)
    state = GameState();
    state.id = id;
    AddState(state);
end;

function AddComponent(component)
    state:AddComponent(component);
end;

function GetComponent(id)
    return state.guiComponents[id];
end


