GUIRectangle = inherit(GUIBlankControl)
inherit(GUIColourable, GUIRectangle)

function GUIRectangle:constructor(posX, posY, width, height, parent)
	GUIColourable.constructor(self)
	GUIBlankControl.constructor(self, posX, posY, width, height, parent)
end

function GUIRectangle:drawThis()
	dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, self.m_Color)
end