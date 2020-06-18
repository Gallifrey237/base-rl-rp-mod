RegisterLogin = inherit(Singleton)

addEvent("RP:Server:automaticLogin", true)

function RegisterLogin:constructor()
    addCommandHandler("xregister", bind(self.Command_Register, self))
    addCommandHandler("xlogin", bind(self.Command_Login, self))

    addEventHandler("RP:Server:automaticLogin", root, bind(self.Event_AutomaticLogin, self))
end

function RegisterLogin:Event_AutomaticLogin(accountname, accountpassword)
    if not client then return end

    self:Command_Login(client, nil, accountname, accountpassword)
end

function RegisterLogin:Command_Register(player, cmd, accountname, password, passwordconf)
    local query = db:query("SELECT * FROM userdata_general WHERE Name = ?", accountname)
    local result = db:poll(query, -1)

    if #result > 0 then
        player:sendMessage("A account with this name is already known.")
    else
        if accountname and password and passwordconf then
            if password:len() >= 6 then
                if password == passwordconf then
                    local salt = md5(getTickCount())
                    local query = db:query("INSERT INTO userdata_general (Name,DisplayName,Password,Salt,Serial,LastLogin,RegisterDate) VALUES(?,?,?,?,?,?,?)",
                        accountname, -- 1
                        player:getName(), -- 2
                        sha256(password .. salt), -- 3
                        salt, -- 4
                        player:getSerial(), -- 5
                        getRealTime().timestamp, -- 6
                        getRealTime().timestamp -- 7   
                    )

                    local res, affected, lastId = db:poll(query, -1)
                    
                    db:exec("INSERT INTO userdata_rp (RP_Id) VALUES(?)", lastId)

                    player:sendMessage("Account successfuly created.")
                    player:pastLogin(lastId)
                else
                    player:sendMessage("Password and the password-confirmation doesn't equal.")
                end
            else
                player:sendMessage("Your passwords needs a min. of 6 characters.")
            end
        else
            player:sendMessage("Syntax: /xregister <accoutname> <password> <password-confirmation>")
        end
    end

end

function RegisterLogin:Command_Login(player, _, accountname, password)
    if not accountname then
        player:sendMessage("Please enter a accountname.")
    else
        if player:inGame() then
            player:sendMessage("You are already logged in.")
            return
        end

        if accountname and password then
            local dataOfAccount = db:poll(db:query("SELECT * FROM userdata_general WHERE Name = ?", accountname), -1)
            if #dataOfAccount > 0 then
                if sha256(password .. dataOfAccount[1]["Salt"]) == dataOfAccount[1]["Password"] then
                    player:pastLogin(dataOfAccount[1]["Id"]);
                else
                    player:sendMessage("Your password is incorrect. Please retry or contact the support.")
                end
            end
        else
            player:sendMessage("Syntax: /xlogin <accountname> <password>")
        end
    end
end