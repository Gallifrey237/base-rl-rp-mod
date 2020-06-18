RegisterLogin = inherit(Singleton)

function RegisterLogin:constructor()
    self:tryLogin()
    addCommandHandler("xsave", bind(self.Command_SaveLogin, self))
end

function RegisterLogin:tryLogin()
    local accountname = config:get("accountname")
    local accountpassword = config:get("accountpassword")

    if accountname and accountpassword then
        localPlayer:sendMessage("We are trying to log you in automatically.")
        triggerServerEvent("RP:Server:automaticLogin", resourceRoot, accountname, accountpassword)
    end
end

function RegisterLogin:Command_SaveLogin(_, accountname, password)
    config:set("accountname", accountname)
    config:set("accountpassword", password)

    localPlayer:sendMessage("Your accountdata has been saved.")
    localPlayer:sendMessage("If the entered data was correct, you are getting logged in automatically next time.")

    self:tryLogin()
end