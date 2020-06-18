RoleplayLobby = inherit(BaseLobby)

RoleplayLobby.ScoreboardRequests = {
    {Name = "Spieler", Value = "Name", Width = 0.4},
    {Name = "Adminlevel", Value = "Adminlevel", Width = 0.2},
    {Name = "Wanteds", Value = "Wanteds", Width = 0.2},
    {Name = "Spielzeit", Value = "Playtime", Width = 0.2},
}

function RoleplayLobby:constructor()
    BaseLobby.constructor(self)
    self.m_Bind_KeyBind_ShowInventory = bind(self.KeyBind_ShowInventory, self)

end

function RoleplayLobby:KeyBind_ShowInventory()
    ItemManager:getSingleton():Command_GetInventory()
end

function RoleplayLobby:onInternSelect(lobbyData)
    ItemManager:getSingleton():activate()
    bindKey("i", "up", self.m_Bind_KeyBind_ShowInventory)

    self.m_Scoreboard = RoleplayScoreboard:new()

    -- self:test()
end

function RoleplayLobby:test()
    local editbox = GUIEditbox:new(200, 200, 100, 25)


    editbox:setVisible(true)
end

function RoleplayLobby:onInternDeselect()
    ItemManager:getSingleton():deactivate()
    
    delete(self.m_Scoreboard)

    unbindKey("i", "up", self.m_Bind_KeyBind_ShowInventory)
end
