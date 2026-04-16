local ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    while true do
        local sleep = 1000 -- Standaard check elke seconde
        local playerPed = PlayerPedId()
        
        -- Check of de speler een wapen in zijn handen heeft
        if IsPedArmed(playerPed, 7) then
            sleep = 250 -- Sneller checken (4x per seconde) als de speler gewapend is
            
            local currentWeapon = GetSelectedPedWeapon(playerPed)
            local playerData = ESX.GetPlayerData()
            local canUseWeapon = false

            -- Check of de speler een toegestane job heeft
            if playerData.job ~= nil then
                for _, jobName in ipairs(Config.WhitelistedJobs) do
                    if playerData.job.name == jobName then
                        canUseWeapon = true
                        break
                    end
                end
            end

            -- Als de speler GEEN agent is, controleer of het wapen verboden is
            if not canUseWeapon then
                for _, weaponName in ipairs(Config.PoliceWeapons) do
                    if currentWeapon == GetHashKey(weaponName) then
                        -- Wapens afpakken en opruimen
                        RemoveWeaponFromPed(playerPed, currentWeapon)
                        SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
                        
                        -- De speler op zijn vingers tikken
                        ESX.ShowNotification(Config.Message)
                        break
                    end
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)