ItemConditions = {}

ItemConditions.StateFactions = {
	[1] = true,
	[2] = true,
	[7] = true,
}

-- Is player on ground ItemCondition
-- Id: 00000001

ItemConditions[00000001] = {
	Condition = {
		["DE"] = "Auf dem Boden.",
		["EN"] = "Be at groundlevel.",
	},
	Func = function (player, item)
		return isPedOnGround(player)
	end,
	Negative = {
		["DE"] = "Sie stehen nicht auf dem Boden.",
		["EN"] = "You are not on the ground.",
	},
}

-- is in state faction
-- Id: 00000002

ItemConditions[00000002] = {
	Condition = {
		["DE"] = "Staatsfraktionist.",
		["EN"] = "state faction member.",
	},
	Func = function (player, item)
		for group in pairs(player:getGroups()) do
			if ItemConditions.StateFactions[group:getGroupId()] then
				return true
			end
		end
		return false
	end,
	Negative = {
		["DE"] = "Sie sind in keiner Staatsfraktion.",
		["EN"] = "You are not a member of a state faction.",
	},
}