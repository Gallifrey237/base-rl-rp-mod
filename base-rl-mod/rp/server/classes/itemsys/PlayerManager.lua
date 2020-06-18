PlayerManager = inherit(Singleton)

function PlayerManager:constructor()
	addEventHandler("onPlayerJoin", root, bind(self.onPlayerJoin, self))
	addEventHandler("onResourceStart", resourceRoot, bind(self.onResourceStart, self))
	addEventHandler("onResourceStop", resourceRoot, bind(self.onResourceStop, self))

	addCommandHandler("select", bind(self.selectPlayerInventory, self))
	addCommandHandler("use", bind(self.usePlayerInventory, self))
	addCommandHandler("inv", bind(self.showPlayerInventory, self))
	addCommandHandler("del", bind(self.deletePlayerInventory, self))
	addCommandHandler("add", bind(self.addPlayerInventory, self))

	addCommandHandler("money", bind(self.Command_SetMoney, self))

	addEventHandler("onPlayerWeaponFire", root, bind(self.Event_OnPlayerWeaponFire, self))
end

function PlayerManager:Command_SetMoney(player, _, money)
	if tonumber(money) then
		if player:inGame() then
			player:setData("Money", tonumber(money))
			player:sendMessage("Your money has been set to $ ".. money)
		end
	end
end

function PlayerManager:Event_OnPlayerWeaponFire(weapon, endX, endY, endZ, hitElement, startX, startY, startZ)
	if source:getSelectedItem() and source:getSelectedItem():getTemplateItem():getClass() == 1 then
		source:getSelectedItem():useItem(source)
	end
end

function PlayerManager:selectPlayerInventory(player, _, slot)
	player:selectItem(tonumber(slot))
end

function PlayerManager:usePlayerInventory(player, _, slot)
	player:useItem(tonumber(slot))
end

function PlayerManager:addPlayerInventory(player)
	player:addInventory()
end

function PlayerManager:showPlayerInventory(player)
	player:showInventory()
end

function PlayerManager:deletePlayerInventory(player, ...)
	player:deleteInventarItem(...)
end

function PlayerManager:onPlayerJoin()
	source:init()
end

function PlayerManager:onResourceStop()
	for key, value in ipairs(getElementsByType("player")) do
		Player.destructor(value)
	end
end

function PlayerManager:onResourceStart()
	for _, player in ipairs(getElementsByType("player")) do
		player:init()
	end
end
