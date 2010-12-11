LoadCsv("scheduledata", "Resources\\Sampler\\resources\\data\\schedule.cs");

local csv = GetCsv("scheduledata");
Trace(csv:GetString(3, 1));