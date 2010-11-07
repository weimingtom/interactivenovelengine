dofile "../sampler/models/calendar.lua"
require "luaunit"

TestCalendar = {}

    function TestCalendar:setUp()
		self.cal = Calendar:New()
		self.cal:SetYear(1984)
		self.cal:SetMonth(3)
		self.cal:SetDay(19)
    end

    function TestCalendar:GetSetDateTest()
		print("testing getter/setter for year")
		assertEquals(self.cal:GetYear(), 1984)
        assertEquals(self.cal:GetMonth(), 3)
        assertEquals(self.cal:GetDay(), 19)
        assertEquals(self.cal:GetWeek(), 4)
		assertEquals(self.cal:GetDayOfWeek(), "Mon")
    end
    
LuaUnit:run() -- run all tests