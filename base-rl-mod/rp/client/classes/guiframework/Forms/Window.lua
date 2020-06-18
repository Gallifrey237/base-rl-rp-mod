GUIWindow = inherit(GUIBlankControl)

GUIWindow.TitleThickness = 24

function GUIWindow:constructor(posX, posY, width, height, title, close, parentElement)
	GUIBlankControl.constructor(self, posX, posY, width, height, parentElement)

	self.m_TitleBackground = GUIRectangle:new(0, 0, width, GUIWindow.TitleThickness, self)
	self.m_TitleBackground:setColor(100,100,100)

	if close then
		-- Todo: at real button with effect
		self.m_CloseButton = GUILabel:new("[X]", width-GUIWindow.TitleThickness, 0, GUIWindow.TitleThickness, GUIWindow.TitleThickness, self.m_TitleBackground)
		self.m_CloseButton:setAlignX("center"):setAlignY("center")
	end

	self.m_CloseButton.onInternHoverStart = function ()
		Tooltip:getSingleton():show(_"CLOSE_WINDOW")
	end

	self.m_CloseButton.onInternHoverStop = function ()
		Tooltip:getSingleton():hide()
	end

	self.m_CloseButton.onInternLeftUp = function ()
		Tooltip:getSingleton():hide()
	end

	if title then
		self.m_TitleLabel = GUILabel:new(title, 0, 0, width, 24, self.m_TitleBackground)
		self.m_TitleLabel:setAlignX("center"):setAlignY("center")
	end

end

function GUIWindow:drawThis()
	dxDrawRectangle(self.m_AltX, self.m_AltY + 24, self.m_Width, self.m_Height - 24)
end