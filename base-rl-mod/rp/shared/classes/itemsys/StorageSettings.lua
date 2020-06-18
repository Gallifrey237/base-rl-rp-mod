StorageSettings = inherit(Object)

function StorageSettings:constructor()

    self.m_StorageSettings = {}

	local rootNode = xmlLoadFile("shared/StorageInfos.xml")

	local optionsNode = xmlFindChild(rootNode, "options", 0)

	local i = 0

	while xmlFindChild(optionsNode, "storage", i) do

		local child = xmlFindChild(optionsNode, "storage", i)

		local type = tonumber(xmlNodeGetAttribute(child,"type"))
		local size = xmlNodeGetAttribute(child,"size")
		size = size == "unlimited" and math.huge or tonumber(size)
		local usage = xmlNodeGetAttribute(child,"usage") == "true"
		local name = xmlNodeGetAttribute(child,"name")
		local aka = xmlNodeGetAttribute(child,"aka")

		self.m_StorageSettings[type] = StorageSetting:new(type, name, size, usage)

		i = i + 1
	end

	xmlUnloadFile(rootNode)
end

function StorageSettings:getStorageSettings(type)
	if not type then type = 5000 end
	return storagesettings.m_StorageSettings[type]
end