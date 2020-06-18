Group = inherit(Object)

Group.MaxMember = 30

function Group:constructor(groupId, name, type, groupleader, iconStyle, iconColor, info, messageoftheday, storedMoney)
    self.m_GroupId         = groupId
    self.m_Name            = name
    self.m_Type            = type
    self.m_GroupLeader     = groupleader
    self.m_IconStyle       = iconStyle
    self.m_IconColor       = iconColor
    self.m_Info            = info
    self.m_MessageOfTheDay = messageoftheday
    self.m_StoredMoney     = storedMoney

    -- // Members = every member; Players = real players who are online

    self.m_Members = {}
    self.m_Players = {}
    self.m_Permissions = {}
end

function Group:getGroupId() return self.m_GroupId end
function Group:getName() return self.m_Name end
function Group:getType() return self.m_Type end
function Group:getLeader() return self.m_GroupLeader end
function Group:getIconStyle() return self.m_IconStyle end
function Group:getIconColor() return self.m_IconColor end
function Group:getInfO()    return self.m_Info end
function Group:getMotd() return self.m_MessageOfTheDay end
function Group:getStoredMoney() return self.m_StoredMoney end
function Group:getMembers() return self.m_Members end

function Group:setName(name) self.m_Name = name end
function Group:setType(type) self.m_Type = type end
function Group:setLeader(leader) self.m_GroupLeader = leader:getId() end
function Group:setIconStyle(iconstyle) self.m_IconStyle = iconstyle end
function Group:setIconColor(iconcolor) self.m_IconColor = iconcolor end
function Group:setInfo(info) self.m_Info = info end
function Group:setMotd(motd) self.m_MessageOfTheDay = motd end
function Group:setStoredMoney(money) self.m_StoredMoney = money end

function Group:addPlayer(player)
    table.insert(self.m_Players, player)
    player:addGroup(self)
end

function Group:removePlayer(player)
    for key, value in ipairs(self.m_Players) do
        if v == player then
            table.remove(self.m_Players, key)
            return
        end
    end
end

function Group:isMemberOnline(id)
    for key, value in ipairs(self.m_Players) do
        if value:getId() == id then
            return player, key
        end
    end
    return false
end

function Group:removeMember(id)
    if id ~= self.m_GroupLeader then
        local player, key = self:isMemberOnline(id)
        player:removeGroup(self)
        table.remove(self.m_Players, key)
        for key, value in ipairs(self.m_Members) do
            if value.Id == id then
                table.remove(self.m_Members, key)
                db:exec("DELETE FROM ??.group_member WHERE Id = ? AND GroupId = ?", id, self:getGroupId(), db:getPrefix())
                return
            end
        end
    else
        return false
    end
end

function Group:addMember(playerId, playerAccountName, playerDisplayName)
    if #self.m_Members + 1 <= self.MaxMember then
        table.insert(self.m_Members, {Id = playerId, AccountName = playerAccountName, DisplayName = playerDisplayName})
        return true
    end
    return false
end

function Group:hasPermission(permission) return self.m_Permissions[permission] end

function Group:addPermission(permission)
    self.m_Permissions[permission] = true
end