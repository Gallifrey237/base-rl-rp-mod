StorageSetting = inherit(Object)

function StorageSetting:constructor(type, name, size, usage)
	self.m_Type = type
	self.m_Name = name
	self.m_Size = size
	self.m_Usage = usage
end

function StorageSetting:getType() return self.m_Type end
function StorageSetting:getName() return self.m_Name end
function StorageSetting:getSize() return self.m_Size end
function StorageSetting:getUsage() return self.m_Usage end