Player = inherit(DatabasePlayer)

registerElementClass("player", Player)

function Player:constructor()
	DatabasePlayer.constructor(self)

	self.m_CurrentLobby = false
	self.m_SelectedIter = 0
	self.m_SelectedItem = false
	self.m_LoggedIn = false
	self.m_Storages = {}
	self.m_Groups   = {}
	self.m_CurrentDownloads = {}
	self.m_LastVisits = {}
end

function Player:addGroup(group) self.m_Groups[group] = true end
function Player:removeGroup(group) self.m_Groups[group] = false end
function Player:getGroups() return self.m_Groups end
function Player:getLastVisits() return self.m_LastVisits end
function Player:getLobby() return self.m_CurrentLobby end

function Player:setLobby(lobby, entry) 
	self.m_CurrentLobby = lobby 
	if lobby ~= nil or lobby ~= false then
		self:setData("Lobby_Category", nil)
		self:setData("Lobby_Entry", nil)
	else
		self:setData("Lobby_Category", lobby:getCategory())
		self:setData("Lobby_Entry", entry)
	end
end

function Player:pastLogin(loginId)
	self:setId(loginId) -- Set databaseentry for database-handling etc
	self.m_LoggedIn = true
	self:loadData()
	self:triggerEvent("RP:Client:OnPastLogin")

	-- Get every player faction

	local query = db:query("SELECT GroupId FROM ??.group_member WHERE Id = ?", db:getPrefix(), self:getId() )
	local results = db:poll(query, -1)

	for key, group in ipairs(results) do
		groupmanager:getGroups()[tonumber(group.GroupId)]:addPlayer(self)
	end

	-- Add last server_visit

	local query = db:query("SELECT * FROM ??.server_last_visit WHERE user_Id = ?", db:getPrefix(), self:getId())
	local results = db:poll(query, -1)

	for key, group in pairs(results) do
		self.m_LastVisits[group.ServerType] = group.ServerId
	end

	-- Lead player to lobby selection ( TODO )

	for key, gamemodes in ipairs(lobbymanager:getLobbys()) do
		for key, lobby in ipairs(gamemodes) do
			self:sendMessage("Lobby: %s, Category: %d, Id: %d - Map: %s - Status: %s", 255, 255, 255, lobby:getDesignation(), lobby:getCategory(), key, lobby:getMap(), lobby:getStatus())
		end
	end
	
end

function Player:inGame()
	return self.m_LoggedIn
end

function Player:setData(key, value, noSync)
	self.m_Data[key] = value
	if not noSync then
		setElementData(self, key, value)
	end
end

function Player:getData(key)
	return self.m_Data[key]
end

function Player:triggerEvent(event, ...)
	triggerClientEvent(self, event, self, ...)
end

function Player:getLocalization()
	return Localization:getSingleton():getLocalizationPackage(self:getData("Localization"), self)
end

function Player:selectItem(slot)
	if self:getStorages()[2]:getItems()[slot] and self:getStorages()[2]:getItems()[slot]:select(self) then
		self.m_SelectedItem = self:getStorages()[2]:getItems()[slot]
		self.m_SelectedIter = slot
		self:sendMessage("Item - %s", 255, 255, 255, self.m_SelectedItem:getTemplateItem():getName())
	end
end

function Player:useSpecificItem(item)
	item:useItem(self)

	if item:getAmount() == 0 or item:getDurability() == 0 then
		item = nil
	end
end

function Player:useItem()
	if self.m_SelectedItem then
		self.m_SelectedItem:useItem(self)

		if self.m_SelectedItem:getAmount() == 0 or self.m_SelectedItem:getDurability() == 0 then
			self.m_SelectedItem = nil
		end
	else
		self:sendMessage("Du hast derzeit kein Item selektiert.")
	end
end

function Player:sendMessage(msg, r, g, b, ...)
	outputChatBox((msg):format(...), self, r,g,b)
end

function Player:getSelectedItem()
	return self.m_SelectedItem
end

function Player:deselectItem()
	if self:getSelectedItem() then
		self:sendMessage("Your selected item has been deselected due to storage-interaction.", 200, 200, 200)
		self:getSelectedItem():deselect(self)
		self.m_SelectedItem = nil
	end
end

function Player:showInventory(player)
	for key, value in ipairs(self.m_Storages) do
		outputChatBox("Storage: ".. value.m_StorageType, player)
		for itemKey, item in pairs(value:getItems()) do
			local msg = ("%sItem (%s)(Slot:%d) with amount (%s)"):format(("\t"):rep(10),item:getTemplateItem():getName(), itemKey, item:getAmount())
		end
	end
end

function Player:deleteInventarItem(cmd, storageSlot, slot)
	local storage = self.m_Storages[tonumber(storageSlot)]
	storage:destroyItem(tonumber(slot))
end

function Player:addInventory()
	local item = itemmanager:add(1, self:getId(), self:getId(), self:getId(), 30, 0, 0, 100, 0, math.random(99999), self.m_Storages[1])
	self.m_Storages[1]:addItem(item)
end

function Player:addItem(inventory, item, amount)

end

function Player:getStorages() return self.m_Storages end

-- A lobby is required to get the right inventory

function Player:loadItems(lobby)

end

function Player:init()
end

function Player:sendMessage(message, r,g,b, ... )
	r,g,b = r or 255, g or 255, b or 255
	outputChatBox((message):format(...), self, r or 255,g or 255,b or 255, true)
end

Player.Get = DatabasePlayer.Get

function Player:destructor()

	for group in pairs(self.m_Groups) do
		group:removePlayer(self)
	end

	DatabasePlayer.destructor(self)
	if self:getLobby() then
		self:getLobby():removePlayer(self)
	end
end