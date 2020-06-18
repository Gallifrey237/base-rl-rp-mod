Storage = inherit(Object)

Storage.BLACKLISTED = "SERVERSTORAGE_"
	
--[[
	virtual class
]]
function Storage:constructor(storageType)
	-- outputChatBox("New Storage Generated with type " .. storageType)

	self.m_Items = {}

	self.m_StorageType = storageType
	self.m_MaxSize = self:getMaxSize()

end

function Storage:getMaxSize()
	return storagesettings:getStorageSettings(self.m_StorageType):getSize() or 0
	-- return Storage.SIZES[self.m_StorageType] or 0
end

function Storage:getType() return self.m_StorageType end

function Storage:initItem(slot, uid, itemId, owner, creator, gift, amount, flags, conditionFlags, durability, played, specialtext)
	outputChatBox(("Storage (%s) has received a new item (%s)"):format(self.m_StorageType,itemmanager:getItem(itemId):getName()))

	local itemClass = itemmanager:getItem(itemId):getClass()
	itemClass = Item.Classes[itemClass]
	if itemClass then
		self.m_Items[slot] = itemClass:new(uid, itemId, owner, creator, gift, amount, flags, conditionFlags, durability, played, specialtext, self)
	end
end

--[[
	returns: slot if it worked; false if failed
]]

function Storage:addItem(item)
	if self:hasPlace() then
		local slot = self:getFreeSlot()
		if slot then
			item:setStorage(self)
			self.m_Items[slot] = item
			return slot
		end
	end
	return false
end

function Storage:getFreeSlot()
	for i = 1, self:getMaxSize(), 1 do
		if not self.m_Items[i] then
			return  i
		end
	end
	-- no free slot
	return false
end

function Storage:changeItemSlot(currentSlot, wantedSlot)
	if wantedSlot <= self:getMaxSize() then
		if not self.m_Items[wantedSlot] and self.m_Items[currentSlot] then
			self.m_Items[wantedSlot] = self.m_Items[currentSlot]
			self.m_Items[currentSlot] = nil
		end
	end
end

function Storage:hasPlace()
	return (self:getOccupiedSlots() + 1 <= self:getMaxSize())
end

function Storage:getOccupiedSlots()
	local i = 0
	for key, value in pairs(self.m_Items) do
		i = i + 1
	end
	return i
end

function Storage:decrementItemAmount(slot)
	local item = self:getItems()[slot]
	item:setAmount(item:getAmount()-1)
	if item:getAmount() == 0 then
		-- Too use other storage types; eventually
		if item.destroyItem then
			item:destroyItem(slot)
		end
	end
end

function Storage:takeItemAmount(item, lossAmount)
	local itemType, amount, items, lossAmount = item:getItemId(), 2, {}, lossAmount
	for key, value in pairs(self:getItems()) do
		if value:getItemId() == itemType then
			amount = amount + value:getAmount()
			table.insert(items, {item = value, slot = key})
		end
	end
	if amount >= lossAmount then
		for key, entry in ipairs(items) do
			local value = entry.item
			local itemAmount = value:getAmount()
			if itemAmount - lossAmount >= 0 then
				value:setAmount(itemAmount-lossAmount)
				lossAmount = 0
				break
			else
				self:destroyItem(entry.slot)
				lossAmount = lossAmount - itemAmount
			end
		end
		return true
	end
	return false
end

-- // completly removes the item from the database and the server
function Storage:destroyItem(slot)
	if self.m_Items[slot] then
		dbExec(newDBHandler, "DELETE FROM item_instance WHERE uid = ?", 
							self.m_Items[slot]:getUniqueIdentifier())
		delete(self.m_Items[slot])
		self.m_Items[slot] = nil
		return true
	end
	return false
end

-- // removes the item from the storage
function Storage:removeItem(slot)
	if self.m_Items[slot] then
		self.m_Items[slot] = nil
		return true
	end
	return false
end

function Storage:changeItemStorage(slot, storage)
	if storage:addItem(self.m_Items[slot]) then
		self.m_Items[slot] = nil
		return true
	end
	return false
end

function Storage:getItemSlot(item)
	for key, value in pairs(self.m_Items) do
		if value == item then
			return key
		end
	end
	-- return false, if the item is not in this storage
	return false
end

-- // returns item and slot

function Storage:getItemByUId(uid)
	for key, value in pairs(self.m_Items) do
		if value:getUniqueIdentifier() == uid then
			return value, key
		end
	end
	return false
end

function Storage:changeItemOwner(slot, storage, item)
	if self:changeItemStorage(slot, storage) then
		return true
	end
	return false
end

function Storage:getItems()
	return self.m_Items
end

-- Purpose: Delete all items

function Storage:destructor()
	local string = ""

	for key, value in pairs(self.m_Items) do
			string = ("UPDATE item_instance SET amount = %d, flags = \"%s\", durability= %d, played = %d, specialtext = \"%s\" WHERE uid = %d"):format(
					 value:getAmount(), value:getFlags(), value:getDurability(), value:getPlayed(), value:getSpecialText(), value:getUniqueIdentifier())

			dbExec(newDBHandler, string)
	end
end