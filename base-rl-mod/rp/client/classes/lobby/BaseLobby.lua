BaseLobby = inherit(Object)

function BaseLobby:constructor()
    self.m_LobbyData = {}

    self.m_Objects = {}

    self.m_ItemManager = false
    self.m_Elements = {}
end

function BaseLobby:onSelect(lobbyData)
    self.m_LobbyData = lobbyData
    self.m_GenerateElement = createElement("GENERATION_ELEMENT")
    
    if self.onInternSelect then
        self:onInternSelect(lobbyData)
    end
end

function BaseLobby:getDimension() return self.m_LobbyData.Dimension end

function BaseLobby:setLobbyElement(element)
    table.insert(self.m_Elements, element)
end

function BaseLobby:useMapFile(xmlNode)
    if xmlNode:getName() == "object" then
        local model = xmlNode:getAttribute("model")
        local x,y,z = xmlNode:getAttribute("posX"), xmlNode:getAttribute("posY"), xmlNode:getAttribute("posZ")
        local rotX, rotY, rotZ = xmlNode:getAttribute("rotX"), xmlNode:getAttribute("rotY"), xmlNode:getAttribute("rotZ")
        local int, alpha = xmlNode:getAttribute("interior"), xmlNode:getAttribute("alpha")
        local obj = createObject(tonumber(model), tonumber(x), tonumber(y), tonumber(z), tonumber(rotX), tonumber(rotY), tonumber(rotZ))
        local collision = xmlNode:getAttribute("collisions")
        local doubleside = xmlNode:getAttribute("doublesided")
        local scale = xmlNode:getAttribute("scale")
        obj:setAlpha(tonumber(alpha))
        obj:setInterior(tonumber(int))
        obj:setScale(tonumber(scale))
        obj:setCollisionsEnabled(collision == "true")
        obj:setDimension(self:getDimension())
        -- outputChatBox(self:getDimension())
        obj:setParent(self.m_GenerateElement)
    end
end

function BaseLobby:getLobbyElements() return self.m_Elements end

function BaseLobby:onDeselect()

    for key, value in ipairs(self.m_Elements) do
        destroyElement(value)
    end

    destroyElement(self.m_GenerateElement)

    self.m_Elements = {}

    if self.onInternDeselect then
        self:onInternDeselect()
    end
end