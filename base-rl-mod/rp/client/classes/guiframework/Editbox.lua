GUIEditbox = inherit(GUIBlankControl)

GUIEditbox.MARGIN = 4

function GUIEditbox:constructor(posX, posY, width, height, parentElement)
    GUIBlankControl.constructor(self, posX, posY, width, height, parentElement)

    self.m_TextBuffer    = ""
    self.m_Masked        = false
    self.m_Shadowing     = ""
    self.m_MaxLength     = math.huge
    self.m_Focused       = false
    self.m_CaretPosition = 0
end

function GUIEditbox:setVisible(bool)
    GUIBlank.setVisible(self, bool)
    if bool == false then
        GUIEditboxManager:getSingleton():setBox(false)
    end
end

function GUIEditbox:setStatus(bool) self.m_Focused = bool end
function GUIEditbox:isActive() return self.m_Focused end

function GUIEditbox:getText() return self.m_TextBuffer end
function GUIEditbox:setText(text) self.m_TextBuffer = text; self:sthChanged() end

function GUIEditbox:getCaretPosition() return self.m_CaretPosition end
function GUIEditbox:setCaretPosition(pos) self.m_CaretPosition = pos end

function GUIEditbox:setFocused()
    self:onInternLeftUp()
end

function GUIEditbox:onInternLeftUp()
    GUIEditboxManager:getSingleton():setBox(self)
    self:sthChanged()
end

function GUIEditbox:drawThis()
    dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height)

    if self:isActive() then
        dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, tocolor(200, 200, 200, 255))
    end

    dxDrawText( self.m_TextBuffer, self.m_AltX + GUIEditbox.MARGIN, self.m_AltY, self.m_AltX + self.m_Width - GUIEditbox.MARGIN*2, self.m_AltY + self.m_Height, tocolor(0, 0, 0),
    1, "default", "left", "center", true )
end