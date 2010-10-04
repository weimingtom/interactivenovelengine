SetTitle("테스트입니다 ^^");
SetIcon("Resources/test.ico");
SetSize(800, 600);
SetVolume(50);

-- global data structure for game
GameTable = {}

GameTable["daughtet_name"] = "내딸"

--LoadState("test", "Resources/Sampler/intro.lua");
LoadState("main", "Resources/Sampler/main.lua");

