dofile "../sampler/models/calendar.lua"
require('luaunit')

TestCalendar = {}

    function TestCalendar:setUp()
		self.cal = Calendar:New()
		self.cal:SetYear(1984)
		self.cal:SetMonth(3)
		self.cal:SetDay(19)
    end

    function TestCalendar:testGetSetDate()
		assertEquals(self.cal:GetYear(), 1984)
        assertEquals(self.cal:GetMonth(), 3)
        assertEquals(self.cal:GetDay(), 19)
    end