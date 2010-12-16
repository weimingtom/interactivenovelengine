dofile "../sampler/models/calendar.lua"
require('luaunit')

TestCalendar = {}

    function TestCalendar:setUp()
		self.cal = Calendar:New()
        self.cal:SetDate(1984, 3, 1);
    end

    function TestCalendar:testGetSetDate()
		assertEquals(1984, self.cal:GetYear())
        assertEquals(3, self.cal:GetMonth())
        assertEquals(1, self.cal:GetDay())
        assertEquals(1, self.cal:GetWeek())

        
        self.cal:SetWeek(1)
        assertEquals(1, self.cal:GetDay())
        self.cal:SetWeek(2)
        assertEquals(8, self.cal:GetDay())
        self.cal:SetWeek(3)
        assertEquals(15, self.cal:GetDay())
        self.cal:SetWeek(4)
        assertEquals(22, self.cal:GetDay())
        self.cal:SetWeek(5)
        assertEquals(22, self.cal:GetDay())
        assertEquals(4, self.cal:GetWeek())

    end

    function TestCalendar:testAdvanceDate()
        self.cal:SetDate(1984, 3, 1);
        self.cal:SetWeekLength(7)
        self.cal:AdvanceWeek()
		assertEquals(1984, self.cal:GetYear())
        assertEquals(3, self.cal:GetMonth())
        assertEquals(8, self.cal:GetDay())
        assertEquals(2, self.cal:GetWeek())
        assertEquals(7, self.cal:GetWeekLength(2))
    
        self.cal:AdvanceWeek()
        assertEquals(15, self.cal:GetDay())
        assertEquals(3, self.cal:GetWeek())
        assertEquals(7, self.cal:GetWeekLength(3))

        self.cal:AdvanceWeek()
        assertEquals(22, self.cal:GetDay())
        assertEquals(4, self.cal:GetWeek())
        assertEquals(10, self.cal:GetWeekLength(4))

        self.cal:AdvanceWeek()
        assertEquals(4, self.cal:GetMonth())
        assertEquals(1, self.cal:GetDay())
        assertEquals(1, self.cal:GetWeek())
        assertEquals(7, self.cal:GetWeekLength(1))


        self.cal:SetDate(1984, 3, 1);
        self.cal:SetWeekLength(10)
        self.cal:AdvanceWeek()
		assertEquals(1984, self.cal:GetYear())
        assertEquals(3, self.cal:GetMonth())
        assertEquals(11, self.cal:GetDay())
        assertEquals(2, self.cal:GetWeek())
        assertEquals(10, self.cal:GetWeekLength(2))

        self.cal:AdvanceWeek()
        assertEquals(21, self.cal:GetDay())
        assertEquals(3, self.cal:GetWeek())
        assertEquals(10, self.cal:GetWeekLength(3))


        self.cal:SetDate(1984, 2, 1);
        self.cal:SetWeekLength(7)
        self.cal:AdvanceWeek()

		assertEquals(1984, self.cal:GetYear())
        assertEquals(2, self.cal:GetMonth())
        assertEquals(8, self.cal:GetDay())
        assertEquals(2, self.cal:GetWeek())
        assertEquals(7, self.cal:GetWeekLength(2))

        self.cal:AdvanceWeek()
        assertEquals(15, self.cal:GetDay())
        assertEquals(3, self.cal:GetWeek())
        assertEquals(7, self.cal:GetWeekLength(3))

        self.cal:AdvanceWeek()
        assertEquals(2, self.cal:GetMonth())
        assertEquals(22, self.cal:GetDay())
        assertEquals(4, self.cal:GetWeek())
        assertEquals(8, self.cal:GetWeekLength())
        
        self.cal:AdvanceWeek()
        assertEquals(3, self.cal:GetMonth())
        assertEquals(1, self.cal:GetDay())
        assertEquals(1, self.cal:GetWeek())
        assertEquals(7, self.cal:GetWeekLength(1))
    end


    function TestCalendar:testAdvancYear()
        self.cal:SetDate(1984, 12, 1);
        self.cal:SetWeekLength(7)
        assertEquals(1984, self.cal:GetYear())
        assertEquals(12, self.cal:GetMonth())
        assertEquals(1, self.cal:GetDay())
        assertEquals(1, self.cal:GetWeek())
        assertEquals(7, self.cal:GetWeekLength())

        self.cal:AdvanceWeek()
        assertEquals(1984, self.cal:GetYear())
        assertEquals(12, self.cal:GetMonth())
        assertEquals(8, self.cal:GetDay())
        assertEquals(2, self.cal:GetWeek())
        assertEquals(7, self.cal:GetWeekLength())

        self.cal:AdvanceWeek()
        assertEquals(1984, self.cal:GetYear())
        assertEquals(12, self.cal:GetMonth())
        assertEquals(15, self.cal:GetDay())
        assertEquals(3, self.cal:GetWeek())
        assertEquals(7, self.cal:GetWeekLength())

        self.cal:AdvanceWeek()
        assertEquals(1984, self.cal:GetYear())
        assertEquals(12, self.cal:GetMonth())
        assertEquals(22, self.cal:GetDay())
        assertEquals(4, self.cal:GetWeek())
        assertEquals(10, self.cal:GetWeekLength())

        self.cal:AdvanceWeek()
        assertEquals(1985, self.cal:GetYear())
        assertEquals(1, self.cal:GetMonth())
        assertEquals(1, self.cal:GetDay())
        assertEquals(1, self.cal:GetWeek())
        assertEquals(7, self.cal:GetWeekLength())
    end