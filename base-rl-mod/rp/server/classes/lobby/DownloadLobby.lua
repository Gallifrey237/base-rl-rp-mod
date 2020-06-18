DownloadLobby = inherit(Object)

function DownloadLobby:constructor()
    self.onAllPlayerFinishedDownload = false
    self.m_PlayerDownloaded = {}

    self.m_PackageName = false
    self:generatePackageName()
    self.m_DownloadPackage = downloadmanager:prepareDownloadPackage(self.m_PackageName, {})

    self.m_DownloadFinishedCallback = bind(self.downloadSuccessfull, self)

    -- POSSIBLE CALLBACKS
    -- self.onPlayerFinishedDownload
    -- self.checkStartingConditions
    --
end

function DownloadLobby:generatePackageName()
    self.m_PackageName = ("LOBBYDOWNLOAD_CATEGORY%d_LOBBY%d"):format(self.m_Category, self.m_EntryId)
end

function DownloadLobby:addResourceAsDownload(rscname)
    self.m_PlayerDownloaded = {}

    self:triggerEventToLobby("Downloader:wrapperReset")

    -- Reset the old package for the information
    self.m_DownloadPackage:reset()

    local files = {}

    if Resource.getFromName(rscname) then
        local rsc = Resource.getFromName(rscname)
        local rootNode = xmlLoadFile(":"..rscname.."/meta.xml")
        if rootNode then
            -- Find client-side scripts / files and maps
            local i = 0
            for key, value in ipairs(xmlNodeGetChildren(rootNode)) do
                if not ( value:getName() == "script" and value:getAttribute("type") == "server" ) then
                    table.insert(files, ":" ..rscname.. "/" .. value:getAttribute("src"))
                    i = i + 1
                end
            end
            -- outputDebugString("The amount of available files within the meta are " .. #files)
        end
    end

    -- Add new files to the newest package
    self:generatePackageName()
    self.m_Map = rscname
    if #self.m_Player > 0 then
        self.m_Status = "pending"
    else
        self.m_Status = "hibernating"
    end

    downloadmanager:prepareDownloadPackage(self.m_PackageName, files)

end

-- Gets fired when the downloadPackage gets reseted
function DownloadLobby:onPackageReset(name)
end

function DownloadLobby:getDownloads() return self.m_NeededDownloads end

function DownloadLobby:startPlayerDownload(player)
    downloadmanager:downloadPackage(player, self.m_DownloadPackage:getName(), self.m_DownloadFinishedCallback)
end

function DownloadLobby:downloadSuccessfull(player)
    outputChatBox("Player downloaded: " .. player:getName())
    table.insert(self.m_PlayerDownloaded, player)
    if self.onPlayerFinishedDownload then
        self:onPlayerFinishedDownload(player)
    end
end

function DownloadLobby:onPlayerAdd(player)
    if not self.m_DownloadPackage then
        if self.onPlayerFinishedDownload then
            self:onPlayerFinishedDownload(player)
        end
        if self.checkStartingConditions then
            self:checkStartingConditions()
        end
    else
        self:startPlayerDownload(player)
    end
end

function DownloadLobby:onPlayerRemove(player)
    player:triggerEvent("Downloader:wrapperReset")
    -- remove player out of ready-player state
    for key, value in ipairs(self.m_PlayerDownloaded) do
        if value == player then
            table.remove(self.m_PlayerDownloaded, key)
            if self.checkStartingConditions then
                self:checkStartingConditions()
            end
            break
        end
    end
    if #self.m_Player == 0 then
        self.m_Status = "hibernating"
    end
end

function DownloadLobby:destructor()
    BaseLobby.destructor(self)
    downloadmanager:removePackage(self.m_DownloadPackage:getName())
end