BusinessLobby = inherit(BaseLobby)
inherit(DownloadLobby, BusinessLobby)

function BusinessLobby:constructor(designation, type, maxPlayers, dimension, category, entry)
    BaseLobby.constructor(self, designation, type, maxPlayers, dimension, category, entry)
    DownloadLobby.constructor(self)
    
    self:addResourceAsDownload("business_general")

    self.m_Round = 0
    self.m_CurrentPlayer = false
    self.m_MaxPlayerAmount = 0
    self.m_PlayerRound = {}
    self.m_ReadyState = {}


    self:addLobbyEvent("BusinessPlayerClick", true)
    self:addLobbyEventHandler("BusinessPlayerClick", root, bind(self.Event_PlayerClicked, self))

    addCommandHandler("round", bind(self.Command_NextRound, self))
end

function BusinessLobby:Command_NextRound(player)
    if player:getLobby() == self then
        self:calculateNextRound()
    end
end

function BusinessLobby:Event_PlayerClicked(id)
    if not client then return end
    self:sendLobbyMessage("%s hat auf das Feld %d geklickt.", 255, 255, 255, client:getName(), id)
end

function BusinessLobby:startRound()

    self:sendLobbyMessage("Next round started.")

    self.m_PlayerRound = {}

    self.m_Round = 1
    self.m_MaxPlayerAmount = #self.m_Player
    self.m_CurrentPlayer = 0
    for key, value in ipairs(self.m_Player) do
        table.insert(self.m_PlayerRound, value)
    end

    self:calculateNextRound()
end

function BusinessLobby:calculateNextRound()
    if self.m_CurrentPlayer + 1 > self.m_MaxPlayerAmount then
        self.m_Round = self.m_Round + 1
        self.m_CurrentPlayer = 0
    end
    self.m_CurrentPlayer = self.m_CurrentPlayer + 1
    local playerElement = self.m_PlayerRound[self.m_CurrentPlayer]

    self:sendLobbyMessage("Round: " .. self.m_Round)
    self:sendLobbyMessage("Player: " .. playerElement:getName())
end

function BusinessLobby:onPlayerFinishedDownload(player)

    self:checkStartingConditions()
end

function BusinessLobby:checkStartingConditions()
    if #self.m_PlayerDownloaded == #self.m_Player and ( self:getStatus() == "hibernating" or self:getStatus() == "pending" ) and #self.m_Player >= 2 then
        self:startRound()
        self:setStatus("running")
    elseif self.m_Status == "running" and #self.m_Player == 1 then
        self:setStatus("pending")
    end
end