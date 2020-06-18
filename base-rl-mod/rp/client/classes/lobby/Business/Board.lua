Board = inherit(Object)

Board.TileID = 6959
Board.WIDTH = 40

Board.Tiles = {
    [1] = Vector3( 0, 5, 60 ),
    [2] = Vector3( 0, 5  + (40/4) * 1, 60 ),
    [3] = Vector3( 0, 5  + (40/4) * 2, 60 ),
    [4] = Vector3( 0, 5  + (40/4) * 3, 60 ),
    [5] = Vector3( 0, 5  + (40/4) * 4, 60 ),
    [6] = Vector3( 0, 5  + (40/4) * 5, 60 ),
    [7] = Vector3( 0, 5  + (40/4) * 6, 60 ),
    [8] = Vector3( 0, 5  + (40/4) * 7, 60 ),
    [9] = Vector3( 0, 5  + (40/4) * 8, 60 ),
    [10] = Vector3( (41.3/4) * 1, 5 + (40/4) * 8, 60 ),
    [11] = Vector3( (41.3/4) * 2, 5 + (40/4) * 8, 60 ),
    [12] = Vector3( (41.3/4) * 3, 5 + (40/4) * 8, 60 ),
    [13] = Vector3( (41.3/4) * 4, 5 + (40/4) * 8, 60 ),
    [14] = Vector3( (41.3/4) * 5, 5 + (40/4) * 8, 60 ),
    [15] = Vector3( (41.3/4) * 6, 5 + (40/4) * 8, 60 ),
    [16] = Vector3( (41.3/4) * 7, 5 + (40/4) * 8, 60 ),
    [17] = Vector3( (41.3/4) * 8, 5 + (40/4) * 8, 60 ),
    [18] = Vector3( (41.3/4) * 8, 5  + (40/4) * 7, 60 ),
    [19] = Vector3( (41.3/4) * 8, 5  + (40/4) * 6, 60 ),
    [20] = Vector3( (41.3/4) * 8, 5  + (40/4) * 5, 60 ),
    [21] = Vector3( (41.3/4) * 8, 5  + (40/4) * 4, 60 ),
    [22] = Vector3( (41.3/4) * 8, 5  + (40/4) * 3, 60 ),
    [23] = Vector3( (41.3/4) * 8, 5  + (40/4) * 3, 60 ),
    [24] = Vector3( (41.3/4) * 8, 5  + (40/4) * 2, 60 ),
    [25] = Vector3( (41.3/4) * 8, 5  + (40/4) * 1, 60 ),
    [26] = Vector3( (41.3/4) * 8, 5, 60 ),
    [27] = Vector3( (41.3/4) * 7, 5, 60 ),
    [28] = Vector3( (41.3/4) * 6, 5, 60 ),
    [29] = Vector3( (41.3/4) * 5, 5, 60 ),
    [30] = Vector3( (41.3/4) * 4, 5, 60 ),
    [31] = Vector3( (41.3/4) * 3, 5, 60 ),
    [32] = Vector3( (41.3/4) * 2, 5, 60 ),
    [33] = Vector3( (41.3/4) * 1, 5, 60 ),
}

Board.ShiftVector = Vector3((41.3/4)*1.5, (40/4)*1.5, 0)

Board.StartPosition = Vector3(0, 5, 60)

function Board:constructor()
    self.m_Bind_Event_OnClientRender = bind(self.Event_OnClientRender, self)
    self.m_Bind_Event_OnClientClick  = bind(self.Event_OnClientClick, self)
end

function Board:load()

    local s = 0

    -- Create those for interaction purpose
    for i = 0, 2, 1 do
        for j = 0, 2, 1 do
            local obj = createObject(6959, Vector3 ( 0 + i * 41.3, 0 + j * 40, 0) + Board.StartPosition )
            obj:setDimension(localPlayer:getLobby():getDimension())
            localPlayer:getLobby():setLobbyElement(obj)
            setElementStreamable(obj, true)   
            setElementAlpha(obj, 0)
            s = s + 1
            obj.Id = s
        end
    end


    self.m_BoardElements = {}

    for key, value in ipairs(Board.Tiles) do
        local obj = createObject(6959, value - Board.ShiftVector)
        obj:setDimension(localPlayer:getLobby():getDimension())
        localPlayer:getLobby():setLobbyElement(obj)
        setElementStreamable(obj, false)
        setElementCollisionsEnabled(obj, false)
        setObjectScale(obj, .25)

        obj.Id = key

        table.insert(self.m_BoardElements, obj)
    end

    addEventHandler("onClientRender", root, self.m_Bind_Event_OnClientRender)
    addEventHandler("onClientClick",  root, self.m_Bind_Event_OnClientClick)
end

function Board:Event_OnClientClick(button, state, absX, absY, worldX, worldY, worldZ, element)
    if button == "left" and state == "up" then
        if element and isElement(element) and element.Id then
            for key, value in ipairs(self.m_BoardElements) do
                local x,y = getElementPosition(value)
                x = x - Board.ShiftVector.x/3
                y = y - Board.ShiftVector.y/3
                local w,h = (41.3/4), (40/4)
                if worldX >= x and worldX <= x + w and worldY >= y and worldY <= y + h then 
                    localPlayer:triggerLobbyEvent("BusinessPlayerClick", resourceRoot, value.Id)
                end
            end
        end
    end
end

function Board:Event_OnClientRender()
    for key, value in ipairs(self.m_BoardElements) do
        local x,y = getElementPosition(value)
        x = x - Board.ShiftVector.x/3
        y = y - Board.ShiftVector.y/3
        local w,h = (41.3/4), (40/4) 
        local renderHigh = Board.StartPosition.z + 0.0         
        dxDrawLine3D(x+w, y, renderHigh, x+w,y+h,  renderHigh, tocolor(255,255,255), 6)
        dxDrawLine3D(x, y, renderHigh, x+w,y, renderHigh, tocolor(255,255,255), 6)
        dxDrawLine3D(x, y, renderHigh, x,y+h, renderHigh, tocolor(255,255,255), 6)
        dxDrawLine3D(x, y+h, renderHigh, x+w,y+h, renderHigh, tocolor(255,255,255), 6)
    end
end

function Board:unload()
    removeEventHandler("onClientRender", root, self.m_Bind_Event_OnClientRender)
    removeEventHandler("onClientClick",  root, self.m_Bind_Event_OnClientClick)
end

function Board:destructor()

end