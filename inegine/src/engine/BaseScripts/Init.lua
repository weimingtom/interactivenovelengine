luanet.load_assembly("System.Windows.Forms");
luanet.load_assembly("INovelEngine");

GameState = luanet.import_type("INovelEngine.StateManager.GameState");
TextWindow = luanet.import_type("INovelEngine.Effector.TextWindow");
ImageWindow = luanet.import_type("INovelEngine.Effector.ImageWindow");
WindowBase = luanet.import_type("INovelEngine.Effector.WindowBase");
SpriteBase = luanet.import_type("INovelEngine.Effector.SpriteBase");
AnimatedSprite = luanet.import_type("INovelEngine.Effector.AnimatedSprite")
Button = luanet.import_type("INovelEngine.Effector.Button")
Label = luanet.import_type("INovelEngine.Effector.Label")
View = luanet.import_type("INovelEngine.Effector.View")

ScriptEvents = luanet.import_type("INovelEngine.Script.ScriptEvents");
ScriptManager = luanet.import_type("INovelEngine.Script.ScriptManager");

Texture = luanet.import_type("INovelEngine.ResourceManager.INETexture");
Font = luanet.import_type("INovelEngine.ResourceManager.INEFont");
Sound = luanet.import_type("INovelEngine.ResourceManager.INESound");

Supervisor = Supervisor()

function dofile (filename)
	local f = assert(loadfile(filename))
	return f()
end

function InitResource(resource)
	if (resource.name == nil) then
		Trace "Resource name undefined!"
		return
	end	
    CurrentState():AddResource(resource);
end;

function RemoveResource(id)
    return CurrentState():RemoveResource(id);
end

function GetResource(id)
    return CurrentState():GetResource(id);
end

function InitComponent(component)
    AddComponent(component);
end

function AddComponent(component)
	if (component.name == nil) then
		Trace "Component name undefined!"
		return
	end	
    CurrentState():AddComponent(component);
end;

function RemoveComponent(id)
    return CurrentState():RemoveComponent(id);
end

function GetComponent(id)
    return CurrentState():GetComponent(id);
end

require "BaseScripts\\ESS"
require "BaseScripts\\Selector"
require "BaseScripts\\font"