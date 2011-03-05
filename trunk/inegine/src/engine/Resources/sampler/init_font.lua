LoadFont("default", "Resources\\sampler\\resources\\fonts\\NanumGothicBold.ttf", 17);
LoadFont("japanese", "Resources\\sampler\\resources\\fonts\\\meiryo.ttc", 17);
GetFont("japanese").LineSpacing = 10;

LoadFont("menu", "Resources\\sampler\\resources\\fonts\\NanumGothicBold.ttf", 13);
GetFont("menu").TextEffect = 1

LoadFont("bigmenu", "Resources\\sampler\\resources\\fonts\\NanumGothicBold.ttf", 23);
GetFont("bigmenu").TextEffect = 1


LoadFont("smalldefault", "Resources\\sampler\\resources\\fonts\\NanumGothicBold.ttf", 12);

LoadFont("date", "Resources\\sampler\\resources\\fonts\\NanumMyeongjoBold.ttf", 13);
GetFont("date").LineSpacing = 13
GetFont("date").TextEffect = 1

LoadFont("state", "Resources\\sampler\\resources\\fonts\\NanumGothicBold.ttf", 12);
GetFont("state").LineSpacing = 5

LoadFont("calstate", "Resources\\sampler\\resources\\fonts\\NanumGothicBold.ttf", 11);
GetFont("calstate").LineSpacing = 7

--LoadFont("dialogue", "Resources\\sampler\\resources\\fonts\\meiryo.ttc", 17);
LoadFont("dialogue", "Resources\\sampler\\resources\\fonts\\NanumGothicBold.ttf", 17, "Resources\\sampler\\resources\\fonts\\NanumGothicBold.ttf", 10);
GetFont("dialogue").LineSpacing = 10;
GetFont("dialogue").TextEffect = 1;
GetFont("dialogue").RubyColor = 0xFFFFFF;

LoadFont("small", "Resources\\sampler\\resources\\fonts\\NanumMyeongjoBold.ttf", 15);
GetFont("small").LineSpacing = 10;
GetFont("small").TextEffect = 0;

LoadFont("verysmall", "Resources\\sampler\\resources\\fonts\\NanumGothicBold.ttf", 8);
GetFont("verysmall").LineSpacing = 5

LoadFont("verylarge", "c:\\windows\\fonts\\meiryo.ttc", 78);
--LoadFont("verylarge", "Resources\\sampler\\resources\\fonts\\NanumMyeongjoBold.ttf", 48);
GetFont("verylarge").LineSpacing = 30;