-- Itemclass: Placeable
-- Purpose: Default item which inherits from the consumable but uses place mechanism

Item.Classes[2] = inherit(Item)
inherit(Item.Classes[0], Item.Classes[2])

local temp = Item.Classes[2]

function temp:constructor(...)
	Item.constructor(self, ...)
end

function temp:useItem(player)
	if self:checkFlagStatus() then

		local placeId = tonumber(self:getTemplateItem():getSubClass())

		local obj = createObject(placeId, player:getPosition() - Vector3(0,0,0.7), player:getRotation())


		obj:setDimension(player:getLobby():getDimension());
		
		if ItemScripts[self:getTemplateItem():getSpecialScript()] then
			ItemScripts[self:getTemplateItem():getSpecialScript()](player, obj)
		end
		
		self:getStorage():decrementItemAmount(self:getStorage():getItemSlot(self))
		
	end
end