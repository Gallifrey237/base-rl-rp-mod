LocalPlayer = inherit(Object)

registerElementClass("player", LocalPlayer)

addEvent("RP:Client:OnPastLogin", true)

function LocalPlayer:constructor()
	toggleControl("next_weapon", false)
	toggleControl("previous_weapon", false)

	self.m_Lobby = false

--	addEventHandler("RP:Client:OnRpLoading", root, bind(self.Event_OnRpLoading, self))
	addEventHandler("RP:Client:OnPastLogin", root, bind(self.Event_OnPastLogin, self))
end

function LocalPlayer:triggerLobbyEvent(event, ...)
	if self:getLobby() then
		self:sendMessage("Das Event '%s' wurde getriggered.", 255, 255, 255, ("%s_Category%sLobby%s"):format(event, lobbymanager:getCategory(), lobbymanager:getLobbyId()))
		triggerServerEvent(("%s_Category%sLobby%s"):format(event, lobbymanager:getCategory(), lobbymanager:getLobbyId()), ...)
	end
end

function LocalPlayer:Event_OnPastLogin()
	-- Load core scripts first

	core:pastLogin()

	-- Than the localPlayer stuff

	bindKey("next_weapon", "down", bind(self.Action_FastSelection, self, -1))
	bindKey("previous_weapon", "down", bind(self.Action_FastSelection, self, 1))
	
	self:Action_FastSelection(1)
end

function LocalPlayer:setLobby(lobby) self.m_Lobby = lobby end
function LocalPlayer:getLobby() return self.m_Lobby end

function LocalPlayer:Action_FastSelection(amount)
	triggerServerEvent("RP:Server:StorageManager:fastSwitch", resourceRoot, amount, true)
end

function LocalPlayer:sendMessage(msg, r, g, b, ...)
	if not r then
		r, g, b = 255, 255, 255
	end
	outputChatBox((msg):format(...), r,g,b)
end

function LocalPlayer:getData(value)
	return getElementData(self, value)
end

function LocalPlayer:destructor()

end