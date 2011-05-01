SetTitle("테스트입니다 ^^");
SetIcon("Resources/test.ico");
SetSize(800, 600);
SetVolume(50);

SetPackage("Resources/Sampler", "", false);
--SetPackage("Resources/sampler.zip", "test", true);
LoadScript("resources/i18n/locale_kr.lua");
--LoadScript("resources/i18n/locale_jp.lua");
LoadScript("init.lua");