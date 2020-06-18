StorageManager = inherit(Object)
inherit(LobbyChild, StorageManager)

addEvent("Storage:getStorageItems", true)
addEvent("Storage:swapItems", true)
addEvent("Storage:selectItem", true)
addEvent("Storage:switchItem", true)
addEvent("Storage:useItem", true)
addEvent("RP:Server:StorageManager:fastSwitch", true)

StorageManager.VALID_REQUESTS = {
	["OwnStorage"] = true,
	["FactionStorage"] = true,
}

function StorageManager:constructor(lobby)
	LobbyChild.constructor(self, lobby)

	addEventHandler("Storage:getStorageItems", resourceRoot, bind(self.Event_GetStorageItems, self))
	addEventHandler("Storage:swapItems",  resourceRoot, bind(self.Event_SwapItems, self))
	addEventHandler("Storage:selectItem", resourceRoot, bind(self.Event_SelectItem, self))
	addEventHandler("Storage:switchItem", resourceRoot, bind(self.Event_SwitchItem, self))
	addEventHandler("Storage:useItem",    resourceRoot, bind(self.Event_UseItem, self))
	addEventHandler("RP:Server:StorageManager:fastSwitch", resourceRoot, bind(self.Event_FastSwitch, self))

	self.m_StorageSettings = {}

	self:loadSettings()
end

function StorageManager:loadSettings()
	local rootNode = xmlLoadFile("shared/StorageInfos.xml")

	local optionsNode = xmlFindChild(rootNode, "options", 0)

	local i = 0

	while xmlFindChild(optionsNode, "storage", i) do

		local child = xmlFindChild(optionsNode, "storage", i)

		local type = tonumber(xmlNodeGetAttribute(child,"type"))
		local size = xmlNodeGetAttribute(child,"size")
		size = size == "unlimited" and math.huge or tonumber(size)
		local usage = xmlNodeGetAttribute(child,"useage") == "true"
		local name = xmlNodeGetAttribute(child,"name")

		self.m_StorageSettings[type] = StorageSettings:new(type, name, size, usage)

		i = i + 1
	end

	xmlUnloadFile(rootNode)
end

function StorageManager:getStorageSettings(type)
	if not type then type = 5000 end
	return self.m_StorageSettings[type]
end

function StorageManager:Event_GetStorageItems(general, specific)
	if not client then return end
	if not self:getLobby():isPlayerInLobby(client) then return end
	self:sendRequestedItems(client, general, specific)
end

function StorageManager:Event_UseItem(general, specific, uniqueIdentifier)
	if not client then return end
	if not self:getLobby():isPlayerInLobby(client) then return end
	local storage = self:getStorageBySpecification(client, general, specific)
	if storage then
		local usable = storagesettings:getStorageSettings(storage:getType()):getUsage()
		local item, slot = storage:getItemByUId(uniqueIdentifier)
		if item then
			client:useSpecificItem(item)
		end
	end
end

function StorageManager:Event_FastSwitch(amount, scroll)
	if not client then return end
	if not self:getLobby():isPlayerInLobby(client) then return end
	takeAllWeapons(client)
	local general = "OwnStorage"
	local specific = 2
	local storage = self:getStorageBySpecification(client, general, specific)
	local items = storage:getItems()
	local currentItem = client.m_SelectedItem
	local sizeOfInventory = storagesettings:getStorageSettings(2):getSize()
	local next = client.m_SelectedIter + amount
	if next < 1 then next = sizeOfInventory end
	if next > sizeOfInventory then next = 1 end
	client.m_SelectedIter = next
	if items[next] then
		client:selectItem(client.m_SelectedIter)
	end
end

function StorageManager:Event_SelectItem(general, specific, uniqueIdentifier)
	if not client then return end
	if not self:getLobby():isPlayerInLobby(client) then return end
	if general == "OwnStorage" and specific == 2 then
		takeAllWeapons(client)
		local storage = self:getStorageBySpecification(client, general, specific) -- get the fast selection storage
		local item, slot = storage:getItemByUId(uniqueIdentifier)
		-- call player switch method
		client:selectItem(slot)
	end
end

-- USED FOR NON SWAPPING HANDLINGS WITHIN THE INVENTORIES

function StorageManager:Event_SwitchItem(originGeneral, originSpecifc, originUniqueIdentifier, destinationGeneral, destinationSpecific)
	if not self:getLobby():isPlayerInLobby(client) then return end
	local originStorage = self:getStorageBySpecification(client, originGeneral, originSpecifc)
	local destinationStorage = self:getStorageBySpecification(client, destinationGeneral, destinationSpecific)

	assert(originStorage and destinationStorage, "invalid storages given")

	local originItem, originSlot = originStorage:getItemByUId(originUniqueIdentifier)

	assert(originItem, "Cant find item within storage @ someone may cheat")
	if originItem then
		if destinationStorage:addItem(originItem) then
			originStorage:removeItem(originSlot)
			-- resend storage information
			self:sendRequestedItems(client, originGeneral, originSpecifc)
			self:sendRequestedItems(client, destinationGeneral, destinationSpecific)

			-- ANTI-ABUSE
			if originItem == client:getSelectedItem() then
				client:deselectItem()
			end

		end
	end
end

--// drag:

function StorageManager:Event_SwapItems(dragGeneral, dragSpecific, dragUniqueIdentifier, hoverGeneral, hoverSpecific, hoverUniqueIdentifier)
	if not self:getLobby():isPlayerInLobby(client) then return end
	local dragStore 	= self:getStorageBySpecification(client, dragGeneral, dragSpecific)
	local hoverStore 	= self:getStorageBySpecification(client, hoverGeneral, hoverSpecific)
	local dragItem, dragSlot	= dragStore:getItemByUId(dragUniqueIdentifier)
	local hoverItem, hoverSlot 	= hoverStore:getItemByUId(hoverUniqueIdentifier)
	assert(dragItem and hoverItem, "StorageManager:Event_SwapItems cant find item within storages @ someone may cheat")
	if dragItem and hoverItem then
		dragStore:removeItem(dragSlot)
		hoverStore:removeItem(hoverSlot)
		local addedDragSlot, addedHoverSlot
		if dragSlot < hoverSlot then
			addedDragSlot = dragStore:addItem(hoverItem)
			addedHoverSlot = hoverStore:addItem(dragItem)
		else
			addedHoverSlot = hoverStore:addItem(dragItem)	
			addedDragSlot = dragStore:addItem(hoverItem)
		end
		dragStore:changeItemSlot(addedDragSlot, dragSlot)
		hoverStore:changeItemSlot(addedHoverSlot, hoverSlot)
		-- resend storage information
		self:sendRequestedItems(client, dragGeneral, dragSpecific)
		self:sendRequestedItems(client, hoverGeneral, hoverSpecific)

		-- ANTI-ABUSE
		if dragItem == client:getSelectedItem() or hoverItem == client:getSelectedItem() then
			client:deselectItem()
		end

		-- outputChatBox("Swapped Item")
	end
end

function StorageManager:getStorageBySpecification(player, general, specific)
	local storage, items = false, false
	if general == "OwnStorage" then
		if player.m_Storages[tonumber(specific)] then
			storage = player.m_Storages[specific]
			items = storage:getItems()
		end
	end
	return storage, items
end

function StorageManager:sendRequestedItems(player, general, specific)
	if not StorageManager.VALID_REQUESTS[general] then return end
	local storage, items = false, false
	local specificInformation = {}
	local generalInformation = {}	
	
	storage, items = self:getStorageBySpecification(player, general, specific)

	if not (storage or items) then return end

	for key, value in pairs(items) do
		--[[local tvalue = value:getTemplateItem()
		generalInformation[tvalue:getItemId()] = {
			ItemId = tvalue:getItemId(),
			Class = tvalue:getClass(),
			SubClass = tvalue:getSubClass(),
			Name = {tvalue:getName()},
			DisplayPicture = tvalue:getDisplayPicture(),
			Quality = tvalue:getQuality(),
			Flags = tvalue:getFlags(),
			ConditionFlags = tvalue:getConditionFlags(),
			AllowedFactions = tvalue:getAllowedFactions(),
			Stackable = tvalue:isStackable(),
			MaxDurability = tvalue:getMaxDurability(),
			Duration = tvalue:getDuration(),
			SpecialScript = tvalue:getSpecialScript(),
			Description = tvalue:getDescription(), 
		}]] 
		specificInformation[key] = {
			UniqueIdentifier = value:getUniqueIdentifier(),
			ItemId = value:getItemId(),
			Owner = value:getOwner(),
			Creator = value:getCreator(),
			Gift = value:getGift(),
			Amount = value:getAmount(),
			Flags = value:getFlags(),
			ConditionFlags = value:getConditionFlags(),
			Durability = value:getDurability(),
			Played = value:getPlayed(),
			SpecialText = value:getSpecialText(),
			Storage = value:getStorage(),
		}      
	end
	--// Kinda huge data, transmit it with a balanced brandwith
	triggerLatentClientEvent(player, "Storage:receiveStorage", 50000, false, player, specificInformation, general, specific, storage:getType());
end

function StorageManager:send(itemTable)

end

function StorageManager:destructor()

end