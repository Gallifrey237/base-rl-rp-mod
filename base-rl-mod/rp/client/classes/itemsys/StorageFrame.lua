StorageFrame = inherit(Object)

function StorageFrame:constructor(general, specific, storageType)
	self.m_Items = {}
	self.m_ItemFrames = {}
	self.m_General = general
	self.m_Specific = specific
	self.m_StorageType = storageType
	self.m_Settings = storagesettings:getStorageSettings(storageType)

	self.m_Window = GUIWindow:new(200+tonumber(self.m_Specific)*250, 400, 200, 200, self.m_Settings:getName() or "Unknown", true)

	self.m_WindowScrollPane = GUIScrollArea:new(0, GUIWindow.TitleThickness, 200, 200, 200, 200, self.m_Window)

	self.m_WindowScrollPane.onLeftUp = bind(self.Action_WindowClick, self)
	self.m_Window.m_CloseButton.onLeftUp = bind(self.Action_OnCloseButton, self)
end

function StorageFrame:getType() return self.m_StorageType end
function StorageFrame:getGeneral() return self.m_General end
function StorageFrame:getSpecific() return self.m_Specific end

function StorageFrame:Action_OnCloseButton()
	ItemManager:getSingleton():closeStorage(self.m_General, self.m_Specific)
end

function StorageFrame:Action_WindowClick()
	-- swap the item into this storage
	local destinationGeneral, destinationSpecific = self.m_General, self.m_Specific


	local dropItemFrame = ItemDragAndDrop:getSingleton():getItemFrame()

	if dropItemFrame then
		local originStorage = dropItemFrame.m_ParentStorage
		if not originStorage then return end
		local originGeneral, originSpecific = originStorage:getGeneral(), originStorage:getSpecific()
		local originUniqueIdentifier = dropItemFrame.m_UniqueIdentifier

		if originGeneral == destinationGeneral and originSpecific == destinationSpecific then
			localPlayer:sendMessage("Destinationstorage shouldnt be the same as the originStorage.", 255, 0, 0)
			return
		end

		triggerServerEvent("Storage:switchItem", resourceRoot, originGeneral, originSpecific, originUniqueIdentifier, destinationGeneral, destinationSpecific)
	end
end

function StorageFrame:loadItems(items)
	for key, value in pairs(self.m_ItemFrames) do
		delete(value)
	end
	self.m_Items = items
	self.m_ItemFrames = {}
	for key, value in pairs(items) do
		local frame = ItemFrame:new((key - 1)*50, 0, 48, 48, self.m_WindowScrollPane)
		frame:setItem(value)
		frame.m_ParentStorage = self
		frame.m_ParentStorageSlot = key
		frame.m_UniqueIdentifier = value.UniqueIdentifier
		table.insert(self.m_ItemFrames, frame)
	end
end

function StorageFrame:setVisible(bool)
	self.m_Window:setVisible(bool)
end	

function StorageFrame:destructor()
	local dad = ItemDragAndDrop:getSingleton()
	if dad:getItemFrame() and dad:getItemFrame().m_ParentStorage and dad:getItemFrame().m_ParentStorage == self then
		dad:setItemFrame(false)
	end
	if dropdownmenu:getControlElement() and dropdownmenu:getControlElement().ItemFrameMenu == self then
		dropdownmenu:destroy()
	end
	delete(self.m_Window)
end