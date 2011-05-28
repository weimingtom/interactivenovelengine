for i in io.popen("dir /b"):lines() do
	if string.find(i,"%Test.lua$") then 
		print("Running " .. i .. "...")
		dofile(i);
	end
end


function Trace(msg)
    print(msg);
end


function Info(msg)
    print(msg);
end


LuaUnit:run() -- run all tests