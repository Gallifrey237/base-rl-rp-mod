GUIGridList = inherit(GUIBlankControl)

GUIGridList.DescriptionHeight = 16
GUIGridList.EntryHeight = 32

--// SELECTIONMODES:
--// ROW: Whole row
--// COL: column specific entry

function GUIGridList:constructor(posX, posY, width, height, parentElement)
    GUIBlankControl.constructor(self, posX, posY, width, height, parentElement)

    self.m_Columns = {}
    self.m_Entrys  = {}
    self.m_Selected = {}

    self.m_EntryHeight = GUIGridList.EntryHeight 

    self.m_ScrollArea = GUIScrollArea:new(0, GUIGridList.DescriptionHeight, width, height - GUIGridList.DescriptionHeight, width, 3000, self)

    self.m_InteractionMode = "ROW"
end

function GUIGridList:flush()
   local currentVisibleStatus = self.m_Visible
    self:setVisible(false)
    for key, value in ipairs(self.m_Entrys) do
        delete(value)
    end
    self.m_Entrys = {}
    self.m_ScrollArea:flush()
    self:setVisible(currentVisibleStatus)
end

function GUIGridList:setEntryHeight(height)
    self.m_EntryHeight = height
end

function GUIGridList:getScrollArea()
    return self.m_ScrollArea
end

function GUIGridList:getEntryHeight() return self.m_EntryHeight end

function GUIGridList:addRow()
    local row = GUIGridListEntry:new(0, 0 + #self.m_Entrys*self:getEntryHeight(), self.m_ScrollArea.m_Width, self:getEntryHeight(), self.m_ScrollArea)
    table.insert(self.m_Entrys, row)
    return row
end

function GUIGridList:getColumns() return self.m_Columns end

function GUIGridList:drawThis()
    dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, tocolor(0, 0, 0, 125))
    local currentRelative = 0
    for key, value in ipairs(self.m_Columns) do
        dxDrawText(value.Name, self.m_AltX + currentRelative*self.m_Width, self.m_AltY, self.m_AltX + (currentRelative + value.RelativeWidth)*self.m_Width, self.m_AltY + GUIGridList.DescriptionHeight,
                    "0xFFFFFFFF", 1, "default", "left", "center", true)
        currentRelative = currentRelative + value.RelativeWidth
    end
end

function GUIGridList:addColumn(columnName, relativeWidth)
    table.insert(self.m_Columns, {Name = columnName, RelativeWidth = relativeWidth})
end