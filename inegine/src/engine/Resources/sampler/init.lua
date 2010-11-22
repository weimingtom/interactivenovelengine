dofile("Resources/Sampler/init_testdata.lua")

	LoadFont("default", "Resources\\sampler\\fonts\\NanumGothicBold.ttf", 17);

	LoadFont("menu", "Resources\\sampler\\fonts\\NanumGothicBold.ttf", 18);
	GetFont("menu").TextEffect = 1
	
	LoadFont("date", "Resources\\sampler\\fonts\\NanumMyeongjoBold.ttf", 13);
	GetFont("date").LineSpacing = 13
	GetFont("date").TextEffect = 1

	LoadFont("state", "Resources\\sampler\\fonts\\NanumGothicBold.ttf", 12);
	GetFont("state").LineSpacing = 5
	
	LoadFont("dialogue", "Resources\\sampler\\fonts\\NanumGothicBold.ttf", 17);
	--LoadFont("default", "c:\\windows\\fonts\\gulim.ttc", 12, "c:\\windows\\fonts\\gulim.ttc", 10) --ruby font
	GetFont("dialogue").LineSpacing = 10;
	GetFont("dialogue").TextEffect = 1;

LoadState("main", "Resources/Sampler/main.lua");
--LoadState("main", "Resources/Sampler/intro.lua");