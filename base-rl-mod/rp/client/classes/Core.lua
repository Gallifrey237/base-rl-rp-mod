Core = inherit(Object)

function Core:constructor()
	outputDebugString("Clientside-Loading core...")

	core = self
	
	-- // init localplayer instance
	enew(localPlayer, LocalPlayer)

	config = Config:new()
	Renderer:new()
	tooltip = Tooltip:new()
	Localization:new()

	-- general settings
	local language = config:get("Language")
	if not language then
		config:set("Language", "English")
		--// this variable gets modified again after the login
	end
	--

	--// load downloader as last instance to prevent loading issues
	Downloader:new()

	bindKey("m", "up",
		function()
			showCursor(not isCursorShowing())
		end
	)

	outputDebugString("Clientside-Core has been loaded.")
end

function Core:afterDownload()
	outputDebugString("Client] afterDownload-classes are loading...")

	RegisterLogin:new()
	dropdownmenu = DropDownMenu:new()
	GUIEditboxManager:new()	

	outputDebugString("Client] afterDownload-classes finished loading...")
end

function Core:pastLogin()
	outputDebugString("Client] pastLogin-classes are loading...")	

	load_after_login_constants()
	
	config:set("Language", localPlayer:getData("Language"))

	ItemManager:new()
	storagesettings = StorageSettings:new()
	lobbyselection = LobbySelection:new()
	lobbymanager = LobbyManager:new()

	outputDebugString("Client] pastLogin-classes finished loading...")	
end

function Core:destructor()
	delete(config)
end

function getAbsoluteCursorPosition()
	local cx, cy = getCursorPosition()
	if not cx then return end
	return cx*screenWidth, cy*screenHeight
end

function table.clone(org)
  return {unpack(org)}
end