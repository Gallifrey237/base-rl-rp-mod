DatabasePlayer = inherit(Object)

DatabasePlayer.DataStates = {

    ["userdata_general"] = {
        {Database = "Name", Element = "Name"},
        {Database = "Adminlevel", Element = "Adminlevel"},
        {Database = "Money", Element = "Money"},
        {Database = "Playtime", Element = "Playtime"},
        {Database = "Bonus", Element = "Bonus"}, 
        {Database = "Language", Element = "Language"}, 
        {Database = "SubAdminlevel", Element = "SubAdminlevel"}, 
    },

    ["userdata_rp"] = {
        {Database = "RP_Level", Element = "RP_Level"}, 
        {Database = "RP_CurrentX", Element = "RP_CurrentX"}, 
        {Database = "RP_CurrentY", Element = "RP_CurrentY"}, 
        {Database = "RP_CurrentZ", Element = "RP_CurrentZ"}, 
        {Database = "RP_CurrentInt", Element = "RP_CurrentInt"}, 
        {Database = "RP_CurrentDim", Element = "RP_CurrentDim"}, 
        {Database = "RP_SpawnX", Element = "RP_SpawnX"}, 
        {Database = "RP_SpawnY", Element = "RP_SpawnY"}, 
        {Database = "RP_SpawnZ", Element = "RP_SpawnZ"},     
        {Database = "RP_SpawnInt", Element = "RP_SpawnInt"}, 
        {Database = "RP_SpawnDim", Element = "RP_SpawnDim"},    
        {Database = "RP_Wanteds", Element = "RP_Wanteds"},
        {Database = "RP_Skin", Element = "RP_Skin"},
        {Database = "RP_Job", Element = "RP_Job"},     
        {Database = "RP_STVO", Element = "RP_STVO"},      
    },

}

function DatabasePlayer:constructor(databaseId)
    self.m_LogId = false or databaseId
    self.m_Data = {}
end

function DatabasePlayer:destructor()

    local setstring, completeUpdateString, valueToSave, allDataTables = ""

    local totalTables = 0

    for tableName, tableValues in pairs(DatabasePlayer.DataStates) do
        totalTables = totalTables + 1

        if totalTables == 1 then
            allDataTables = tableName
            -- outputChatBox(tableValues[1].Database)
            -- outputChatBox(self.m_Data[tableValues[1].Element])
            setString = ("%s.%s = \'%s\'"):format( tableName, tableValues[1].Database, self.m_Data[tableValues[1].Element] )
        else
            allDataTables = ("%s, %s"):format(allDataTables, tableName)
        end

        for key, value in ipairs(tableValues) do

            if key > 1 then
                -- outputChatBox(value.Database)
                -- outputChatBox(self.m_Data[value.Element])
                local valueToSave = self.m_Data[value.Element]
                setString = ("%s, %s.%s = \'%s\'"):format(setString, tableName, value.Database, valueToSave)
            end

        end
    end   

    local completeUpdateString = ("UPDATE %s SET %s WHERE userdata_general.Id = %d AND userdata_rp.RP_Id = %d"):format( allDataTables, setString, self:getId(), self:getId())

    db:exec(completeUpdateString)

    DatabasePlayer.Existing[self:getId()] = nil
end

function DatabasePlayer:loadData()
    local id = self:getId()
    local data = self.m_Data

    DatabasePlayer.Existing[id] = self

    local allDataTables, totalTables = "", 0

    for tableName, tableValues in pairs(DatabasePlayer.DataStates) do
        totalTables = totalTables + 1

        if totalTables == 1 then
            allDataTables = tableName
        else
            allDataTables = ("%s, %s"):format(allDataTables, tableName)
        end        
    end

    local query = db:query("SELECT * FROM ?? WHERE userdata_general.Id = ? AND userdata_rp.RP_Id = ?", allDataTables, id, id)
    local result = db:poll(query, -1)

    if result then
        for tableName, tableValues in pairs(DatabasePlayer.DataStates) do
            local rData = result[1]
            for key, value in pairs(tableValues) do
                local databaseKey = value.Database

                if tonumber(rData[value.Database]) then
                    self.m_Data[value.Element] = tonumber(rData[databaseKey])
                else
                    self.m_Data[value.Element] = rData[databaseKey]
                end
                if isElement(self) then
                    setElementData(self, value.Element, rData[databaseKey])
                end
            end
        end
    end


end

function DatabasePlayer:getData(value)
    return self.m_Data[value]
end

function DatabasePlayer:getId()
    return self.m_LogId
end

function DatabasePlayer:setId(id)
    self.m_LogId = id
end

DatabasePlayer.Existing = {}

function DatabasePlayer.Get(stuff)
    if type(stuff) == "number" then
        if DatabasePlayer.Existing[stuff] then
            return DatabasePlayer.Existing[stuff]
        else
            DatabasePlayer.Existing[stuff] = DatabasePlayer:new(stuff)
            DatabasePlayer.Existing[stuff]:loadData()
            return DatabasePlayer.Existing[stuff]
        end
    elseif type(stuff) == "string" then
        if getPlayerFromName(stuff) then
            return getPlayerFromName(stuff)
        end
    elseif type(stuff) == "userdata" then
        return stuff
    else
        outputDebugString("Invalid type @ DatabasePlayer.Get")
    end
end