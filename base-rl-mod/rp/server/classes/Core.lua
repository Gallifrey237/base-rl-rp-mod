Core = inherit(Object)

-- TODO: deactivate when real server is online
DEBUG = true

function Core:constructor()
	outputDebugString("Loading serverside-core...")

	startResource(getResourceFromName("rp_wrapper"))

	core = self

	db = Database:new()
	RegisterLogin:new()
	Localization:new()

	-- Unspecific manager
	groupmanager = GroupManager:new()
	itemmanager = ItemManager:new()
	storagesettings = StorageSettings:new()

	-- lobby-bounded managers / ignore them

	--storagemanager = StorageManager:new()
	--factionmanager = FactionManager:new()
	
	-- other non-lobby-bounded mangers

	PlayerManager:new()

	JunkStorage = Storage:new(1000)	

	-- Load this as last classes
	-- otherwise bugs can appear during runtime
	downloadmanager = DownloadManager:new()		
	lobbymanager = LobbyManager:new()	

	outputDebugString("Serverside-Core has been loaded.")
end

function Core:destructor()
	delete(lobbymanager)

	stopResource(getResourceFromName("rp_wrapper"))
end