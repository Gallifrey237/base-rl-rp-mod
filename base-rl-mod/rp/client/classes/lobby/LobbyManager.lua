LobbyManager = inherit(Object)

addEvent("RP:Client:ReceiveLobbyData", true)
addEvent("RP:Client:SelectGamemodeLobby",  true)
addEvent("RP:Client:DeselectGamemodeLobby",  true)

function LobbyManager:constructor()
    -- The order should be the same as the servers. refer -> server/classes/lobby/LobbyManager.lua -> VARIABLE: self.m_Lobbys
    self.m_Lobbys = {
        [1] = RoleplayLobby:new(),
        [2] = TacticsLobby:new(),
        [3] = BusinessLobby:new()
    }

    self.m_LobbyData = {}
    self.m_LobbyId = false
    self.m_CategoryId = false
    
    addEventHandler("RP:Client:ReceiveLobbyData", root, bind(self.Event_OnReceiveLobbyData, self))
    addEventHandler("RP:Client:SelectGamemodeLobby",  root, bind(self.Event_SelectGamemodeLobby, self))
    addEventHandler("RP:Client:DeselectGamemodeLobby",  root, bind(self.Event_DeselectGamemodeLobby, self))

    self:done()
end

function LobbyManager:done()
    triggerServerEvent("RP:Server:OnRequestLobbys", resourceRoot)
end

function LobbyManager:Event_SelectGamemodeLobby(categoryId, lobbyId)
    localPlayer:setLobby(self.m_Lobbys[categoryId])
    self.m_Lobbys[categoryId]:onSelect(self.m_LobbyData[categoryId][lobbyId]);
    self.m_LobbyId = lobbyId
    self.m_CategoryId = categoryId

    lobbyselection:hide()
end

function LobbyManager:Event_DeselectGamemodeLobby(gamemodeId)
    localPlayer:getLobby():onDeselect()
    localPlayer:setLobby(false)
    self.m_LobbyId = false
    self.m_CategoryId = false

    lobbyselection:show()
end

function LobbyManager:getLobbyData() return self.m_LobbyData end
function LobbyManager:getCategory() return self.m_CategoryId end
function LobbyManager:getLobbyId() return self.m_LobbyId end

function LobbyManager:Event_OnReceiveLobbyData(lobbyData)
    self.m_LobbyData = lobbyData

    lobbyselection:show()
end