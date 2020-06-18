RoleplayLobby = inherit(BaseLobby)

function RoleplayLobby:constructor(designation, type, maxPlayers, dimension, category, entry)
	BaseLobby.constructor(self, designation, type, maxPlayers, dimension, category, entry)
	
	self:setStatus("running")

    self.m_StorageManager = StorageManager:new(self)
end

function RoleplayLobby:onPlayerAdd(player)
    self:loadItems(player)
    -- Hud-specific-entries
    player:spawn(player:getData("RP_CurrentX"), player:getData("RP_CurrentY"), player:getData("RP_CurrentZ"))
    player:setCameraTarget(player)
	player:fadeCamera(true)
	-- We need to check if the player is in another base dimension of another roleplay-instance

	local invalidSpawn = false

	for key, value in ipairs(lobbymanager:getLobbys()[self:getCategory()]) do
		if key ~= self:getEntryId() then
			if value:getDimension() == player:getData("RP_CurrentDim") then
				invalidSpawn = true
			end
		end
	end

	-- //

	if player:getData("RP_CurrentDim") == 65000 or invalidSpawn then
		player:setDimension(self:getDimension())
	else
		player:setDimension(player:getData("RP_CurrentDim"))
	end
    player:setInterior(player:getData("RP_CurrentInt"))
    player:setMoney(player:getData("Money"))
    player:setWantedLevel(player:getData("RP_Wanteds"))
	player:setModel(player:getData("RP_Skin"))
	
    player:sendMessage("Successfuly logged in.")
end

function RoleplayLobby:loadItems(player)
	local lobbyType = self:getType()

	local query = dbQuery(newDBHandler,"SELECT * FROM inventory WHERE owner = ? AND serverId = ?", player:getId(), self:getUniqueId())
	local results = dbPoll(query, -1)

	local tempItemIds = {}
	local fetchString = ""

	-- Generate storage
	player.m_Storages[1] = PlayerStorage:new(1, player) -- Default inventory
	player.m_Storages[2] = PlayerStorage:new(2, player) -- Fast selection
	player.m_Storages[3] = PlayerStorage:new(3, player) -- bank storage
	player.m_Storages[4] = PlayerStorage:new(4, player) -- mail storage

	if #results == 0 then return end
	for k, v in ipairs(results) do
		local inv, itemId = tonumber(v["inventory"]), v["item"]

		tempItemIds[itemId] = {inv, v["slot"]}


		if #tostring(fetchString) == 0 then
			fetchString = itemId
		else
			fetchString = ("%s, %s"):format(fetchString, itemId)
		end
	end

	fetchString = ("(%s)"):format(fetchString)

	query = dbQuery(newDBHandler, "SELECT * FROM item_instance WHERE uid IN ".. fetchString)
	results = dbPoll(query, -1)

	for k, v in ipairs(results) do
		local id = tonumber(v["uid"])
		if tempItemIds[id] then
			player.m_Storages[tempItemIds[id][1]]:initItem(tempItemIds[id][2], v["uid"], v["itemId"], v["owner"], v["creator"],
													v["gift"], v["amount"], v["flags"], v["conditionflags"], v["durability"],
													v["played"], v["specialtext"])
		end
	end
	-- Garbage collector
	tempItemIds = nil
end

function RoleplayLobby:onPlayerRemove(player)
	local x,y,z = getElementPosition(player)
	local int = player:getInterior()
	local dim = player:getDimension()

	player:setData("RP_CurrentInt", int)
	player:setData("RP_CurrentDim", dim)
	player:setData("RP_CurrentX", x)
	player:setData("RP_CurrentY", y)
	player:setData("RP_CurrentZ", z)

    for key, value in pairs(player.m_Storages) do
		value:delete()
	end
end

function RoleplayLobby:destructor()
    BaseLobby.destructor(self)
end