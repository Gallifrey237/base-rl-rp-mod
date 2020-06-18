GroupManager = inherit(Singleton)

local DEBUG = true

function GroupManager:constructor(lobby)
    self.m_Groups = {}

    self:generateGroups()
    self:loadPermissions()
    self:addFactionMembers()

    addCommandHandler("showmember", bind(self.Command_ShowMemberList, self))
end

function GroupManager:getGroups() return self.m_Groups end

function GroupManager:Command_ShowMemberList(player,cmd)
    for group in pairs(player:getGroups()) do
        player:sendMessage("Faction: %s", 255, 255, 255, group:getName())
        for key, value in ipairs(group:getMembers()) do
            player:sendMessage("       %d. %s (%s)", 255, 255, 255, key, value.DisplayName, value.AccountName)
        end
    end
end

function GroupManager:generateGroups()
    local query = db:query("SELECT * FROM ??.group", db:getPrefix())
    local results = db:poll(query, -1)

   for key, v in ipairs(results) do
        self.m_Groups[v.GroupId] = Group:new(
                v.GroupId,
                v.Name,
                v.Type,
                v.GroupLeader,
                v.IconStyle,
                v.IconColor,
                v.Info,
                v.Messageotd,
                tonumber(v.StoredMoney)
            )

        if DEBUG then
            outputDebugString(("Group \'%s\' added."):format(v.Name))
        end
    end
end

function GroupManager:loadPermissions()
    local query = db:query("SELECT * FROM ??.group_permission", db:getPrefix())
    local results = db:poll(query, -1)
    local group;

    for key, v in ipairs(results) do
        if self.m_Groups[tonumber(v.GroupId)] then
            group = self.m_Groups[tonumber(v.GroupId)]
            group:addPermission(v.PermissionId)
        end
    end
end

---//*****************************************************************
---//* Purpose: Adds the member with general information like the name
---//*****************************************************************

function GroupManager:addFactionMembers()
    local query = db:query("SELECT group_member.GroupId AS GroupId,group_member.Id AS Id,userdata_general.Name AS AccountName,userdata_general.DisplayName AS DisplayName FROM group_member LEFT JOIN userdata_general ON group_member.Id = userdata_general.Id")
    local results = db:poll(query, -1)
    local group;
    for key, v in ipairs(results) do
        if self.m_Groups[tonumber(v.GroupId)] then
            group = self.m_Groups[tonumber(v.GroupId)]
            group:addMember(v.Id, v.AccountName, v.DisplayName)
            if DEBUG then
                outputDebugString(("The member '%s' has been added to the group '%s'"):format(v.DisplayName, group:getName()))
            end
        end
    end
end