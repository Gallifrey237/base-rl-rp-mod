GameObjectManager = inherit(Object)

GameObjectManager.TYPE_DEFINITIONS =
{
    [1] = Marker,
    [2] = Vehicle,
    [3] = Object,
    [4] = Ped,
    [5] = Blip,
    [6] = RadarArea,
}

function GameObjectManager:constructor(lobby)
    --// We need the lobby to get the dimension etc.
    self.m_Lobby = lobby

    self.m_LobbyElement = createElement("LOBBY_ROOT")
end

function GameObjectManager:addObject(obj)
    obj:setParent(self.m_LobbyElement)
    return obj
end

function GameObjectManager:destructor()
    destroyElement(self.m_LobbyElement)
end
