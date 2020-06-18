BusinessLobby = inherit(BaseLobby)

function BusinessLobby:constructor()
    BaseLobby.constructor(self)
    self.m_Board = Board:new()
end

function BusinessLobby:onInternSelect(lobbyData)
    self.m_Board:load()
end

function BusinessLobby:onInternDeselect()
    self.m_Board:unload()
end