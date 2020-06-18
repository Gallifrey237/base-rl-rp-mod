-- Itemclass: Permanent
-- Purpose: Item which should be used.


Item.Classes[3] = inherit(Item)

local temp = Item.Classes[0]

function temp:constructor(...)
	Item.constructor(self, ...)
end

function temp:useItem(player)
    if self:checkFlagStatus() then
        outputChatBox("Dieses Item dient nicht der Verwendung.")
	end
end