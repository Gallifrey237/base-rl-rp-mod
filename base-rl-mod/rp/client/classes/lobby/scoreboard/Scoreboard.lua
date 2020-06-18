Scoreboard = inherit(Object)

Scoreboard.Width  = 350
Scoreboard.Height = 125

function Scoreboard:constructor()

    self.m_TabList = GUIGridList:new(screenWidth/2 - Scoreboard.Width/2, screenHeight/2 - Scoreboard.Height/2, Scoreboard.Width, Scoreboard.Height)

    self.m_SavedFuncs = {}
    self.m_TableRequests = {}

    self.m_Bind_Key_Mouse_Wheel_Down = bind(self.Key_Mouse_Wheel_Down, self)
    self.m_Bind_Key_Mouse_Wheel_Up = bind(self.Key_Mouse_Wheel_Up, self)

    self.m_Bind_Key_Mouse_Two = bind(self.Key_Mouse_Two, self)

    -- self.m_Bind_Key_Tabulator = bind(self.Key_Tabulator, self)

end

function Scoreboard:Key_Mouse_Wheel_Down()
    self.m_TabList:getScrollArea():onInternWheelDown()
end

function Scoreboard:Key_Mouse_Wheel_Up()
    self.m_TabList:getScrollArea():onInternWheelUp()
end

function Scoreboard:Key_Mouse_Two(key, state)
    showCursor(state == "down" and true or false)
end

function Scoreboard:unbindKeysFrom(category)
    for key, func in ipairs(self.m_SavedFuncs[category]) do
        if func ~= self.m_Bind_Key_Mouse_Wheel_Down and func ~= self.m_Bind_Key_Mouse_Wheel_Up then
            unbindKey(category, "down", func)
        end
    end
end

function Scoreboard:bindKeysFrom(category)
    for key, func in ipairs(self.m_SavedFuncs[category]) do
        if func ~= self.m_Bind_Key_Mouse_Wheel_Down and func ~= self.m_Bind_Key_Mouse_Wheel_Up then
            bindKey(category, "down", func)
        end
    end
end

-- add requests in following format : {Name = "DISPLAYNAMEWITHINLIST", Value = "ELEMENTDATAKEY", Width = "RELATIVEWIDTHWITHINGRID"}

function Scoreboard:getGridList()
    return self.m_TabList
end

function Scoreboard:Key_Tabulator (key, state)
    if state == "down" then
        bindKey("next_weapon", "down", self.m_Bind_Key_Mouse_Wheel_Down)
        bindKey("previous_weapon", "down", self.m_Bind_Key_Mouse_Wheel_Up)
        bindKey("mouse2", "both", self.m_Bind_Key_Mouse_Two)
    else
        unbindKey("next_weapon", "down", self.m_Bind_Key_Mouse_Wheel_Down)
        unbindKey("previous_weapon", "down", self.m_Bind_Key_Mouse_Wheel_Up) 
        unbindKey("mouse2", "both", self.m_Bind_Key_Mouse_Two)
        showCursor(false)
    end
end

function Scoreboard:destructor()
    if self.m_Visible then
        unbindKey("next_weapon", "down", self.m_Bind_Key_Mouse_Wheel_Down)
        unbindKey("previous_weapon", "down", self.m_Bind_Key_Mouse_Wheel_Up)
        unbindKey("mouse2", "both", self.m_Bind_Key_Mouse_Two)
    end
    delete(self.m_TabList)
end