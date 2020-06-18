PlayerStorage = inherit(Storage)

function PlayerStorage:constructor(storageType, player)
	self.m_Player = player
	
	Storage.constructor(self, storageType)
end

function PlayerStorage:getPlayer()
	return self.m_Player
end

-- // see Storage.lua
function PlayerStorage:destroyItem(slot)
	local bool = Storage.destroyItem(self, slot)
	if bool then
		dbExec(newDBHandler, "DELETE FROM inventory WHERE owner = ? AND inventory = ? AND slot = ?", 
							self.m_Player:getId(), self.m_StorageType, slot)
	end
	return bool
end

-- // see Storage.lua
function PlayerStorage:removeItem(slot)
	local bool = Storage.removeItem(self, slot)
	if bool then
		dbExec(newDBHandler, "DELETE FROM inventory WHERE owner = ? AND inventory = ? AND slot = ?", 
							self.m_Player:getId(), self.m_StorageType, slot)
	end	
	return bool
end

function PlayerStorage:addItem(item)
	local slot = Storage.addItem(self, item)
	if slot then
		dbExec(newDBHandler, "INSERT INTO inventory (owner, inventory, slot, item, serverId) VALUES (?,?,?,?,?)",
								self.m_Player:getId(), self.m_StorageType, slot, item:getUniqueIdentifier(), self:getPlayer():getLobby():getType())
	end
	return slot
end

function PlayerStorage:changeItemSlot(currentSlot, newSlot)
	if Storage.changeItemSlot(self, currentSlot, newSlot) then
		dbExec(newDBHandler, "UPDATE inventory SET slot = ? WHERE owner = ? AND inventory = ? AND slot = ?",
								newSlot, self.m_Player:getId(), self.m_StorageType, currentSlot)
	end
end

-- Todo: make that function useful or better
function PlayerStorage:changeItemOwner(slot, storage, item)
	if Storage.changeItemOwner(self, slot, storage, item) then
		dbExec(newDBHandler, "DELETE FROM inventory WHERE owner = ? AND inventory = ? AND slot = ?", 
							self.m_Player:getId(), self.m_StorageType, slot)
	end
end