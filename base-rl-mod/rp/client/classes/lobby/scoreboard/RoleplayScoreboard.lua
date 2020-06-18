RoleplayScoreboard = inherit(Scoreboard)

function RoleplayScoreboard:constructor()
    Scoreboard.constructor(self)
 
    self.m_TabList:addColumn("Spieler", 0.3)
    self.m_TabList:addColumn("Sprache", 0.2)
    self.m_TabList:addColumn("Adminlevel", 0.2)
    self.m_TabList:addColumn("Spielzeit", 0.2) 
    self.m_TabList:addColumn("Ping", 0.1)
       

    self.m_Bind_Key_Tabulator = bind(self.Key_Tabulator, self)

    bindKey("tab", "both", self.m_Bind_Key_Tabulator)
end

function RoleplayScoreboard:Key_Tabulator(key, state)
    Scoreboard.Key_Tabulator(self, key, state)
    if state == "down" then

        self.m_SavedFuncs["next_weapon"] = getFunctionsBoundToKey("next_weapon", "down")
        self.m_SavedFuncs["previous_weapon"] = getFunctionsBoundToKey("previous_weapon", "down")

        for key, value in pairs(self.m_SavedFuncs) do
            self:unbindKeysFrom(key)
        end

        self.m_TabList:flush()
        for key, value in ipairs(getElementsByType("player")) do
            local row = self.m_TabList:addRow()
            row:setValue("Spieler", getElementData(value, "Name"))
            row:setValue("Sprache", getElementData(value, "Language"))
            row:setValue("Adminlevel", TEAM_RANKS[getElementData(value, "Adminlevel")][getElementData(value,"SubAdminlevel")])
            row:setValue("Spielzeit", ("%02d:%02d h"):format(math.floor(getElementData(value,"Playtime")/60), getElementData(value,"Playtime")%60))
            row:setValue("Ping", getPlayerPing(value))
        end               

        self.m_TabList:setVisible(true)
    else

        for key, value in pairs(self.m_SavedFuncs) do
            self:bindKeysFrom(key)
        end

        self.m_SavedFuncs = {}

        self.m_TabList:setVisible(false)
    end 
end

function RoleplayScoreboard:destructor()
    unbindKey("tab", "both", self.m_Bind_Key_Tabulator)

    Scoreboard.destructor(self)
end

