LobbyChild = inherit(Object)

function LobbyChild:constructor(lobby)
    self.m_Lobby = lobby
end

function LobbyChild:getLobby() return self.m_Lobby end