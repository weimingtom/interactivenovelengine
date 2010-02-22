luanet.load_assembly("System.Windows.Forms");
luanet.load_assembly("INovelEngine");
GameState = luanet.import_type("INovelEngine.StateManager.GameState");
TextWindow = luanet.import_type("INovelEngine.Effector.TextWindow");
ImageWindow = luanet.import_type("INovelEngine.Effector.ImageWindow");
SpriteBase = luanet.import_type("INovelEngine.Effector.SpriteBase");
AnimatedSprite = luanet.import_type("INovelEngine.Effector.AnimatedSprite")
ScriptEvents = luanet.import_type("INovelEngine.Script.ScriptEvents");
ScriptManager = luanet.import_type("INovelEngine.Script.ScriptManager");

function InitState(id)
    state = GameState();
    state.id = id;
    AddState(state);
end;

function AddComponent(component)
    state:AddComponent(component);
end;

function GetComponent(id)
    return state:GetComponent(id)
    --return state.guiComponents[id];
end

function BeginESS(script)
	Trace(script)
	Trace "trying to load another script..."
	co = coroutine.create(assert(loadstring(LoadESS(script))))
	Trace "resuming!..."
	coroutine.resume(co);
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