local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('snow:collectSnowball')
AddEventHandler('snow:collectSnowball', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        Player.Functions.AddItem("snowball", 1)
        TriggerClientEvent('QBCore:Notify', src, "You collected a snowball!", "success")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["snowball"], "add")

        -- Trigger a client event to play the pickup animation with the source
        TriggerClientEvent('snow:playPickupAnimation', src)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Delay for 1 second after resource start to ensure QBCore is fully loaded

    local currentWeather = 'XMAS' -- Replace this with your actual method of obtaining the current weather



    -- Broadcast the current weather to all clients
    TriggerClientEvent('updateWeather', -1, currentWeather)
end)
