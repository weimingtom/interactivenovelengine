-- UI factory for commonly used components
UIFactory = {}

function UIFactory.CreateBackButton(event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Texture = "resources/ui/back_button.png"
	newButton.State = {}
	newButton.X = 723;
	newButton.Y = 469
	
	newButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
			newButton.Pushed = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
                if (event~=nil) then 
					event(button, luaevent, args);
				end
			end
		end
	return newButton;
end