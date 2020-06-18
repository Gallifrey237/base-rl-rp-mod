ItemManager = inherit(Singleton)

addEvent("Storage:receiveStorage"	, true)
addEvent("Storage:receiveItems"		, true)

function ItemManager:constructor()
	self.m_Items = {}
	self.m_Storages = {}
	self.m_GeneralInformation = {}
	self.m_SpecificInformation = {}
	self.m_StorageSettings = {}

	self:loadTemplateItems()
	self:loadItems()

	self.m_Bind_Command_GetInventory = bind(self.Command_GetInventory, self)
	self.m_Bind_Event_ReceiveStorage = bind(self.Event_ReceiveStorage, self)


end

function ItemManager:activate()
	addCommandHandler("getinv", self.m_Bind_Command_GetInventory)
	addEventHandler("Storage:receiveStorage", root, self.m_Bind_Event_ReceiveStorage)
end

function ItemManager:deactivate()
	for general, specifics in pairs(self.m_Storages) do
		for specific, storageHimSelf in pairs(specifics) do
			self:closeStorage(general, specific)
		end
	end

	removeCommandHandler("getinv", self.m_Bind_Command_GetInventory)
	removeEventHandler("Storage:receiveStorage", root, self.m_Bind_Event_ReceiveStorage)
end

function ItemManager:Command_GetInventory()
	self:refreshStorage("OwnStorage", 1)
	self:refreshStorage("OwnStorage", 2)
end

function ItemManager:loadSettings()

end

function ItemManager:getStorageSettings(type)
	if not type then type = 5000 end
	return storagesettings.m_StorageSettings[type]
end

function ItemManager:refreshStorage(general, specific)
	triggerServerEvent("Storage:getStorageItems", resourceRoot, general, specific)
end

function ItemManager:closeStorage(general, specific)
	local storage = self.m_Storages[general][specific]--self:getStorage(general, specific)
	-- delete storage from the index
	self.m_Storages[general][specific] = nil
	delete(storage)
end
function ItemManager:getStorage(general, specific, storageType)
	assert(type(general) == "string" and type(general) == "string", "Bad Argument at ItemManager:getStorage")
	if not self.m_Storages[general] then
		self.m_Storages[general] = {}
	end
	if self.m_Storages[general][specific] then
		self:closeStorage(general, specific)
	end

	self.m_Storages[general][specific] = StorageFrame:new(general, specific, storageType)
	return self.m_Storages[general][specific]
end

function ItemManager:getItemTemplate(itemId)
	return self.m_Items[itemId]
end

function ItemManager:Event_ReceiveStorage(specificInformation, general, specific, storageType)
	if not self.m_SpecificInformation[general] then
		self.m_SpecificInformation[general] = {}
	end
	self.m_SpecificInformation[general][specific] = specificInformation

	local k = self:getStorage(general, specific, storageType)
	k:loadItems(specificInformation)
	k.m_Window:setVisible(true)
end


function ItemManager:loadItems()
	triggerServerEvent("ItemManager:requestAllExitingItems", resourceRoot)
end

function ItemManager:loadStorage()

end

function ItemManager:loadTemplateItems()
	local file = fileOpen("generated/ItemTemplate.json")
	local results = fromJSON(fileRead(file, fileGetSize(file)))
	fileClose(file)

	for k, v in pairs(results) do
		self.m_Items[k] = ItemTemplate:new(v["itementry"], v["class"], v["subclass"], v["nameDE"], v["nameEN"],
										v["displayPicture"], v["quality"], v["flags"], v["conditionFlags"], v["allowedFactions"],
										v["stackable"], v["maxdurability"], v["duration"], v["specialscript"],
										v["descriptionDE"], v["descriptionEN"])
	end
end

function ItemManager:loadItem()

end

function ItemManager:getItemData(uid)

end

function ItemManager:destructor()

end