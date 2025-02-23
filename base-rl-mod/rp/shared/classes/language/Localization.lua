Localization = inherit(Singleton)

function Localization:constructor()
	self.m_IsServer = type(triggerClientEvent) == "function"

	self.m_Language = {}
	self.m_LanguagePack = {}

	self:loadLanguagePackages()
end

function Localization:loadLanguagePackages()
	self:addLanguagePack("German", Localization.German)
	self:addLanguagePack("English", Localization.English)
end

function Localization:isClientSide()
	return not self.m_IsServer
end

function Localization:addLanguagePack(name, strings)
	self.m_LanguagePack[name] = strings
end

function Localization:getLanguage(string, player)
	local language
	if self:isClientSide() then
		language = getElementData(localPlayer,"Language") or config:get("Language")
	else
		language = getElementData(player, "Language")
	end
	if self.m_LanguagePack[language] and self.m_LanguagePack[language][string] then
		return self.m_LanguagePack[language][string]
	elseif  self.m_LanguagePack["English"] and self.m_LanguagePack["English"][string] then
		return self.m_LanguagePack["English"][string]
	else
		return string 
	end
	
end

function _(string, player)
	return Localization:getSingleton():getLanguage(string, player)
end

function Localization:destructor()

end