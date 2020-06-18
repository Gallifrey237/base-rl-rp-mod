ItemManager = inherit(Singleton)

addEvent("ItemManager:requestAllExitingItems", true)

function ItemManager:constructor()
	self.m_Items = {}
	self.m_SendItems = {}

	self:load()

	addCommandHandler("reloaditems", bind(self.Command_ReloadItems, self))

	addEventHandler("ItemManager:requestAllExitingItems", resourceRoot, bind(self.Event_RequestAllExitingItems, self))
end

function ItemManager:Event_RequestAllExitingItems()

end

function ItemManager:Command_ReloadItems(player)
	if DEBUG or player:getData("Adminlevel") > 3 then
		outputChatBox("[WARNING] Item-Database is getting reloaded...", root, 255, 0, 0)
		self:load()
	end
end

function ItemManager:load()
	self:deleteOldItems()

	local query = dbQuery(newDBHandler, "SELECT * FROM item_template")
	local results = dbPoll(query, - 1)

	local tempSendData = {}

	if results == 0 then return end
	for k, v in ipairs(results) do
		self.m_Items[v["itementry"]] = ItemTemplate:new(v["itementry"], v["class"], v["subclass"], v["nameDE"], v["nameEN"],
										v["displayPicture"], v["quality"], v["flags"], v["conditionFlags"], v["allowedFactions"],
										v["stackable"], v["maxdurability"], v["duration"], v["specialscript"],
										v["descriptionDE"], v["descriptionEN"])

		tempSendData[v["itementry"]] = v
	end

	local f;

	if not fileExists("generated/ItemTemplate.json") then
		f = fileCreate("generated/ItemTemplate.json")
	else
		f = fileOpen("generated/ItemTemplate.json")
	end

	fileWrite(f, toJSON(tempSendData))

	fileClose(f)
end

function ItemManager:add(itemId, owner, creator, gift, amount, flags, conditionFlags, durability, played, specialtext, storage)
	local query = dbQuery(newDBHandler, "INSERT INTO item_instance (itemId, owner, creator, gift, amount, flags, conditionFlags, durability, played, specialtext) VALUES (?,?,?,?,?,?,?,?,?,?)"
										, itemId, owner, creator, gift, amount, flags, conditionFlags, durability, played, specialtext)
	local result, num_affected_rows, last_insert_id = dbPoll(query, -1)

	local itemClass = itemmanager:getItem(itemId):getClass()
	itemClass = Item.Classes[itemClass]

	return itemClass:new(last_insert_id, itemId, owner, creator, gift, amount, flags, conditionFlags, durability, played, specialtext, storage)
end

function ItemManager:getTemplate(itemid)
	return self.m_Items[itemid]
end

function ItemManager:deleteOldItems()
	for key, value in ipairs(self.m_Items) do
		delete(value)
	end
	self.m_Items = {}
	self.m_SendItems = {}
end

function ItemManager:getItem(uid)
	return self.m_Items[uid]
end