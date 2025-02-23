GUIColourable = inherit(Object)

function GUIColourable:constructor(r,g,b,a)
	self.m_Color = tocolor(r,g,b,a)
end

function GUIColourable:setColor(r,g,b,a)
	if r and not b then
		self.m_Color = r
		return
	end
	self.m_Color = tocolor(r,g,b, a or 255)
	self:sthChanged()
end

GUIColourable.setColour = GUIColourable.setColor