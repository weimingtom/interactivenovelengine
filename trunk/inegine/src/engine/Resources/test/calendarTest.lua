dofile "../sampler/calendar.lua"
require "luaunit"

TestCalendar = {}

    function TestCalendar:setUp()
		self.cal = Calendar:New();
    end

    function TestCalendar:GetSetYearTest()
		print( "testing getter/setter for year" )
		self.cal:SetYear(1984);
        assertEquals( self.cal:GetYear() , 1984 )
    end

LuaUnit:run() -- run all tests
