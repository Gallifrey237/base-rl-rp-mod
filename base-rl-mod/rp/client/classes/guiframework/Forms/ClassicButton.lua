GUIClassicButton = inherit(GUIBlankControl)
inherit(GUIColourable, GUIClassicButton)

function GUIClassicButton:constructor(text, posX, posY, width, height, parentElement)
	GUIBlankControl.constructor(self, posX, posY, width, height, parentElement)
	self.m_Rectangle = GUIRectangle:new(0, 0, width, height, self)
	self.m_Rectangle:setColor(100, 100, 100)
	self.m_Text = GUILabel:new(text, 0, 0, width, height, self.m_Rectangle)

	self.m_Text:setAlignX("center"):setAlignY("center")


	self.m_Text.onInternLeftUp = self.onInternalLabelLeftUp
	self.m_Text.onInternLeftDown = self.onInternalLabelLeftDown

	self.m_Rectangle.onInternLeftUp = self.onInternalRectangleLeftUp
	self.m_Rectangle.onInternLeftDown = self.onInternalRectangleLeftDown

	--[[self.m_Rectangle.onInternRightUp = self.onInternalRightClickUp
	self.m_Text.onInternRightUp = self.onInternalRightClickUp

	self.m_Rectangle.onInternRightDown = self.onInternalRightClickDown
	self.m_Text.onInternRightDown = self.onInternalRightClickDown]]
end

function GUIClassicButton:drawThis()

end

function GUIClassicButton:onInternalLabelLeftUp()
	if self.m_ParentElement.m_ParentElement.onLeftUp then
		self.m_ParentElement.m_ParentElement:onLeftUp()
	end
end

function GUIClassicButton:onInternalLabelLeftDown()
	if self.m_ParentElement.m_ParentElement.onLeftDown then
		self.m_ParentElement.m_ParentElement:onLeftDown()
	end
end

function GUIClassicButton:onInternalRectangleLeftUp()
	if self.m_ParentElement.onLeftUp then
		self.m_ParentElement:onLeftUp()
	end
end

function GUIClassicButton:onInternalRectangleLeftDown()
	if self.m_ParentElement.onLeftDown then
		self.m_ParentElement:onLeftDown()
	end
end