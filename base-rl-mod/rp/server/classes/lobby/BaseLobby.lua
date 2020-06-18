BaseLobby = inherit(Object)

--[[
    Available Status:
    pending
    hibernating
    running
]]

function BaseLobby:constructor(designation, type, maxPlayers, dimension, category, entry, uniqueId)

    outputChatBox("Constructed a lobby with the designation : ".. designation)

    self.m_Dimension = dimension
    self.m_Type = type
    self.m_Designation = designation
    self.m_MaxPlayers = maxPlayers
    self.m_Category = category
    self.m_EntryId = entry
    self.m_UniqueId = uniqueId
    self.m_Map = "default"
    self.m_Status = "hibernating"

    self.m_GameManager = GameObjectManager:new(self)
    

    self.m_EnterCallbacks = {}
    self.m_LeaveCallbacks = {}

    self.m_Player = {}
    self.m_PlayerCount = 0
end

function BaseLobby:addLobbyEvent(event, ...)
    addEvent(("%s_Category%dLobby%d"):format(event, self:getCategory(), self:getEntryId()), ...)
end

function BaseLobby:addLobbyEventHandler(event, ...)
    addEventHandler(("%s_Category%dLobby%d"):format(event, self:getCategory(), self:getEntryId()), ...)
end

function BaseLobby:triggerEventToLobby(event, ...)
    for key, value in ipairs(self.m_Player) do
        value:triggerEvent(event, ...)
    end
end

function BaseLobby:getEntryId() return self.m_EntryId end

function BaseLobby:getDimension () return self.m_Dimension end

function BaseLobby:getDesignation() return self.m_Designation end

function BaseLobby:getMaxPlayers() return self.m_MaxPlayers end

function BaseLobby:getLobby() return self end

function BaseLobby:getCategory() return self.m_Category end

function BaseLobby:getType() return self.m_Type end

function BaseLobby:getPlayers() return self.m_Player end

function BaseLobby:getMap() return self.m_Map end

function BaseLobby:getStatus() return self.m_Status end

function BaseLobby:getUniqeId() return self.m_UniqueId end

function BaseLobby:setStatus(status) self.m_Status = status end

function BaseLobby:isPlayerInLobby(player)
    for key, value in ipairs(self.m_Player) do
        if value == player then
            return true
        end
    end
    return false
end

function BaseLobby:addEnterCallback(func)
    table.insert(self.m_EnterCallbacks, bind(func, self))
end

function BaseLobby:addLeaveCallback(func)
    table.insert(self.m_LeaveCallbacks, bind(func, self))
end

function BaseLobby:sendLobbyMessage(msg,r,g,b,...)
	for key, value in pairs(self.m_Player) do
		value:sendMessage((msg):format(...), r, g, b)
	end
end

function BaseLobby:removePlayer(player)
    for key, value in ipairs(self.m_Player) do
        if value == player then
            table.remove(self.m_Player, key)
            if self.onPlayerRemove then
                self:onPlayerRemove(player)
            end
            return true            
        end
    end
    return false
end

function BaseLobby:addPlayer(player)
    if table.getn(self.m_Player) + 1 <= self.m_MaxPlayers then
        table.insert(self.m_Player, player)
        if self.onPlayerAdd then
            self:onPlayerAdd(player)
        end
        for key, value in ipairs(self.m_EnterCallbacks) do
            value()
        end
        triggerEvent("onPlayerLobbyJoin", root, player, self)
        return true
    end
    return false
end


function BaseLobby:destructor()

end
