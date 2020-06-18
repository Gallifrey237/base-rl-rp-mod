-- Itemclass: Consumable
-- Purpose: Default item which decreases on use


Item.Classes[0] = inherit(Item)

local temp = Item.Classes[0]

function temp:constructor(...)
	Item.constructor(self, ...)
end

function temp:useItem(player)
	if self:checkFlagStatus() then

		local placeId = tonumber(self:getTemplateItem():getSubClass())

		local obj = createObject(placeId, player:getPosition() - Vector3(0,0,0.7), player:getRotation())

		if ItemScripts[self:getTemplateItem():getSpecialScript()] then
			ItemScripts[self:getTemplateItem():getSpecialScript()](player, obj)
		end

		self:getStorage():decrementItemAmount(self:getStorage():getItemSlot(self))
	end
end