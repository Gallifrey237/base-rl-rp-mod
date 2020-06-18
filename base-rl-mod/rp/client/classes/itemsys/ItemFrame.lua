ItemFrame = inherit(GUIBlankControl)
inherit(GUIColourable, ItemFrame)

function ItemFrame:constructor(posX, posY, width, height, parent)
	GUIBlankControl.constructor(self, posX, posY, width, height, parent)
	GUIColourable.constructor(self)

	self.m_Item = "asdfasdf"
	self.m_TemplateItem = "asd"

	self.m_Bind_SelectItem = bind(self.Action_SelectItem, self)
	self.m_Bind_UseItem    = bind(self.Action_UseItem, self)	

	self.m_DefaultTable = {
		{text="Use Item", func= self.m_Bind_UseItem},
		{text="Split Item"}
	}



	self.m_FastSelection = {
		{text="Use Item", func= self.m_Bind_UseItem},
		{text="Select Item", func= self.m_Bind_SelectItem},
	}


	self.m_Entered = false
end

function ItemFrame:setItem(item)
	self.m_Item = item
	self.m_TemplateItem = ItemManager:getSingleton():getItemTemplate(item.ItemId) 
end

function ItemFrame:getTemplateItem()	return self.m_TemplateItem end
function ItemFrame:getItem() 			return self.m_Item end

function ItemFrame:Action_SelectItem()
	triggerServerEvent("Storage:selectItem", root, self.m_ParentStorage:getGeneral(), self.m_ParentStorage:getSpecific(), self.m_UniqueIdentifier)
end

function ItemFrame:Action_UseItem()
	triggerServerEvent("Storage:useItem", root, self.m_ParentStorage:getGeneral(), self.m_ParentStorage:getSpecific(), self.m_UniqueIdentifier)
end

function ItemFrame:onInternHoverStart()
	local string = ("Name: %s  \nAnzahl: %d\nBesitzer: %s"):format(self.m_TemplateItem:getName(), self.m_Item.Amount,
	 self.m_Item.Owner, self.m_Item.Owner)

	Tooltip:getSingleton():show(string)	
end

function ItemFrame:onInternHoverStop()
	Tooltip:getSingleton():hide()
end


function ItemFrame:onInternLeftDown()
	self.m_Entered = true
	self:setColor(255,0,0)

	local string = ("Name: %s  \nAnzahl: %d\nBesitzer: %s"):format(self.m_TemplateItem:getName(), self.m_Item.Amount,
	 self.m_Item.Owner, self.m_Item.Owner)

	Tooltip:getSingleton():show(string)

	local dropItemFrame = ItemDragAndDrop:getSingleton():getItemFrame()

	-- Storage controller
	if not dropItemFrame then
		ItemDragAndDrop:getSingleton():setItemFrame(self)
	elseif dropItemFrame == self then -- handle drag and drop between different itemframes
		ItemDragAndDrop:getSingleton():setItemFrame(false)
	elseif dropItemFrame then
		-- Todo: at serverside handling between frames or storages
		if dropItemFrame.m_ParentStorage and self.m_ParentStorage then
			local dropStorage = dropItemFrame.m_ParentStorage
			local selfStorage = self.m_ParentStorage
			triggerServerEvent("Storage:swapItems", root, 
				dropStorage:getGeneral(), dropStorage:getSpecific(), dropItemFrame.m_UniqueIdentifier,
				selfStorage:getGeneral(), selfStorage:getSpecific(), self.m_UniqueIdentifier
			)
			Tooltip:getSingleton():hide()
			ItemDragAndDrop:getSingleton():setItemFrame(false)
		end
	end
end

function ItemFrame:onInternRightUp()
	if not self.m_ParentStorage then return end

	local useTable = self.m_DefaultTable

	if self.m_ParentStorage:getType() == 2 then
		useTable = self.m_FastSelection
	end

	dropdownmenu:setup(useTable, self.m_PosX+self.m_Width, self.m_PosY)
	if dropdownmenu:getControlElement() then
		dropdownmenu:getControlElement().ItemFrameMenu = self.m_ParentStorage
	end
end

function ItemFrame:onInternLeftUp()
	self.m_Entered = false
	self:setColor(0,0,0)
	Tooltip:getSingleton():hide()
end

function ItemFrame:drawThis()
	if not self.m_TemplateItem:getDisplayPicture() then
		dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, self.m_Color)
	else
		dxDrawImage(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, "files/".. self.m_TemplateItem:getDisplayPicture())
	end
end