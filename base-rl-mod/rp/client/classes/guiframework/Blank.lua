GUIBlank = inherit(Object)

function GUIBlank:constructor(posX, posY, width, height, parentElement)
	self.m_PosX = math.floor(posX)
	self.m_PosY = math.floor(posY)
	self.m_AltX = 0
	self.m_AltY = 0
	self.m_Width = width
	self.m_Height = height
	self.m_ParentElement = parentElement
	self.m_HighestParentElement = false
	self.m_Visible = false
	self.m_VisibleForced = false -- defines if window ignores positive visibility changes
	self.m_Children = {}
	self.m_ScrollAreaParent = false


	-- We need the highest parentElement, so we can control if one of the children is out of bounds 
	-- e.g. at scrollpanes or scrollareas
	-- Todo: use the RenderArea to get the highest parentElement -> Because it's saved there
	local highestElement = false
	if parentElement then
		highestElement = self.m_ParentElement
		while highestElement.m_ParentElement do
			highestElement = highestElement.m_ParentElement
		end
	end

	self.m_HighestParentElement = highestElement

	-- create the real position
	if parentElement then
		table.insert(parentElement.m_Children, self)
		self.m_AltX = math.floor(parentElement.m_AltX + self.m_PosX)
		self.m_AltY = math.floor(parentElement.m_AltY + self.m_PosY)
		self.m_PosX = math.floor(self.m_PosX + parentElement.m_PosX)
		self.m_PosY = math.floor(self.m_PosY + parentElement.m_PosY)
	end
	-- get rendertarget or create one
	if parentElement and parentElement.m_RenderArea then
		self.m_RenderArea = parentElement.m_RenderArea
	else
		self.m_RenderArea = RenderArea:new(self)
	end
end

function GUIBlank:setPosition(posX, posY)
	self.m_PosX = posX
	self.m_PosY = posY
	if self.m_ParentElement then
		local parentElement = self.m_ParentElement
		self.m_AltX = math.floor(parentElement.m_AltX + self.m_PosX)
		self.m_AltY = math.floor(parentElement.m_AltY + self.m_PosY)
		self.m_PosX = math.floor(self.m_PosX + parentElement.m_PosX)
		self.m_PosY = math.floor(self.m_PosY + parentElement.m_PosY)
	end 
	for key, value in ipairs(self.m_Children) do
		value:setPosition(0,0)
		--[[value.m_AltX = self.m_AltX + value.m_PosX
		value.m_AltY = self.m_AltY + value.m_PosY
		value.m_PosX = value.m_PosX + self.m_PosX
		value.m_POsY = value.m_PosY + self.m_PosY]]
	end	
	self:sthChanged()
end

function GUIBlank:getPosition()
	return self.m_PosX, self.m_PosY, self.m_AltX, self.m_AltY
end

function GUIBlank:sthChanged()
	if self.m_RenderArea and not self.m_ParentElement then
		self.m_RenderArea:update()
	end

	if self.m_ParentElement then
		--local highestElement = self.m_ParentElement
		--while highestElement.m_ParentElement do
		--	highestElement = highestElement.m_ParentElement
		--end
		self.m_RenderArea:update()
	end
end

function GUIBlank:setVisible(bool)
	self.m_Visible = bool
	for key, value in ipairs(self.m_Children) do
		value:setVisibleRecursive(bool)
	end
	self:sthChanged()
end

function GUIBlank:setStaticVisible(bool)
	self.m_VisibleForced = bool
end

function GUIBlank:setVisibleRecursive(bool)
	self.m_Visible = not self.m_VisibleForced and bool or false
	for key, value in ipairs(self.m_Children) do
		value:setVisibleRecursive(bool)
	end	
end

function GUIBlank:deleteChildren()

end

function GUIBlank:destructor()
	if self.m_RenderArea and not self.m_ParentElement then
		delete(self.m_RenderArea)
	elseif self.m_ParentElement then
		for key, value in ipairs(self.m_ParentElement.m_Children) do
			if value == self then
				table.remove(self.m_ParentElement.m_Children, key)
				break
			end
		end
	end
end