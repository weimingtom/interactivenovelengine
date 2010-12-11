LoadCsv("scheduledata", "Resources\\Sampler\\resources\\data\\schedule.csv");

local csv = GetCsv("scheduledata");
Trace(csv:GetString(3, 1));