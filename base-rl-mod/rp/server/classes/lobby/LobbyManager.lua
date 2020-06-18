LobbyManager = inherit(Object)

addEvent("RP:Server:OnRequestLobbys", true)

function LobbyManager:constructor()

    self.m_LobbyTypes = {
        [1] = RoleplayLobby,
        [2] = TacticsLobby,
        [3] = BusinessLobby,
    }

    self.m_Lobbys = {}
    self.m_Categories = {}

    query = db:query("SELECT * FROM ??.servers LEFT JOIN ??.server_category ON server_category.Id = servers.Category", db:getPrefix(), db:getPrefix())

    result = db:poll(query, -1)
    
    for key, value in ipairs(result) do
        if not self.m_Lobbys[value.Category] then
            self.m_Lobbys[value.Category] = {}
        end
        if not self.m_Categories[value.Category] then
            self.m_Categories[value.Category] = value.CategoryName
        end
        table.insert(self.m_Lobbys[value.Category], self.m_LobbyTypes[value.Type]:new(value.Designation, tonumber(value.Type), tonumber(value.MaxPlayers), tonumber(value.Dimension), tonumber(value.Category), #self.m_Lobbys[value.Category]+1, value.Id))
    end


    self.m_Bind_Command_JoinLobby = bind(self.Command_JoinLobby, self)

    addCommandHandler("lobby", self.m_Bind_Command_JoinLobby)
    addEventHandler("RP:Server:OnRequestLobbys", root, bind(self.Event_OnRequestLobbys, self))
end

function LobbyManager:destructor()
    for gKey, gamemode in pairs(self.m_Lobbys) do
        for lKey, lobby in ipairs(gamemode) do
            delete(lobby)
        end
    end
end

function LobbyManager:getCategoryName(id)
    return self.m_Categories[id]
end

function LobbyManager:Event_OnRequestLobbys()
    if not client then return end
    local lobbys = {}
    for gKey, gamemode in pairs(self.m_Lobbys) do
        if not lobbys[gKey] then
            lobbys[gKey] = {}
        end
        for lKey, lobby in ipairs(gamemode) do
            lobbys[gKey][lKey] = {
                Designation         = lobby:getDesignation(),
                Type                = lobby:getType(),
                CurrentPlayerAmount = #lobby:getPlayers(),
                MaxPlayers          = lobby:getMaxPlayers(),
                Dimension           = lobby:getDimension(),
                Category            = lobby:getCategory(),
            }
        end
    end
    client:triggerEvent("RP:Client:ReceiveLobbyData", lobbys)
end

function LobbyManager:getLobbys() return self.m_Lobbys end

function LobbyManager:Command_JoinLobby(player, _, category, entry)
    if not player:getLobby() then
        category, entry = tonumber(category), tonumber(entry)
        if category and entry then
            if self.m_Lobbys[category] and self.m_Lobbys[category][entry] then
                self:joinLobby(player, self.m_Lobbys[category][entry], category, entry)
            else
                player:sendMessage("The combination of the this category and entry ain't exist here.")
            end
        else
            player:sendMessage("Please enter a valid category and entry-id for the lobby.")
        end
    else
        self:removePlayerFromLobby(player)
    end
end

function LobbyManager:removePlayerFromLobby(player)
    if player:getLobby() then
        if player:getLobby():removePlayer(player) then
            player:triggerEvent("RP:Client:DeselectGamemodeLobby")
            player:sendMessage("You were removed succesfully.", 0, 255, 0)
            player:setLobby(nil)
            player:setDimension(65000)
        end
    end
end

function LobbyManager:joinLobby(player, lobby, category, entry)
    if lobby:addPlayer(player) then
        player:triggerEvent("RP:Client:SelectGamemodeLobby", category, entry)
        player:sendMessage("You joined the lobby \"%s\" successfully.", 0, 255, 0, lobby:getDesignation())
        player:setLobby(lobby, entry)
        -- Add database
        db:exec("INSERT INTO server_last_visit (user_Id, ServerType, ServerId) VALUES (?,?,?) ON DUPLICATE KEY UPDATE ServerType = ?, ServerId = ?",
        player:getId(), category, entry, category, entry)
    else
        player:sendMessage("A error occured while entering the lobby. Reason: Lobby is full.", 255, 0, 0)
    end
end