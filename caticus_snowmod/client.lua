local currentWeather = 'CLEAR'
local isSnowing = false
local playerVehicle = nil

local function isSnowWeather()
    return currentWeather == 'XMAS'
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustReleased(0, 44) then
            print("Current Weather on Key Press: " .. currentWeather)
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                if isSnowWeather() then
                    TriggerServerEvent('snow:collectSnowball')
                else
                    QBCore.Functions.Notify("It's not snowing right now.", "error")
                end
            end
        end
    end
end)

RegisterNetEvent('snow:playPickupAnimation')
AddEventHandler('snow:playPickupAnimation', function()
    print("pewpew")
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "world_human_bum_wash", 0, true)
    Citizen.Wait(10000)
    ClearPedTasks(playerPed)
end)

RegisterNetEvent('updateWeather')
AddEventHandler('updateWeather', function(weather)
    currentWeather = weather
    isSnowing = isSnowWeather()
    print("Current Weather Updated: " .. currentWeather)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Check if the current weather is 'XMAS'
        if isSnowWeather() then
            -- Adjust vehicle handling characteristics for better traction in snow
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            if DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
                -- Tweak vehicle handling attributes as needed
                SetVehicleHandlingFloat(vehicle, "CHASSIS", "fTractionCurveMin", 1.0) -- Adjust minimum traction
                SetVehicleHandlingFloat(vehicle, "CHASSIS", "fTractionCurveMax", 1.0) -- Adjust maximum traction
                SetVehicleHandlingFloat(vehicle, "CHASSIS", "fTractionCurveLateral", 2.0) -- Adjust lateral traction
                SetVehicleHandlingFloat(vehicle, "CHASSIS", "fTractionCurveMin", 1.0) -- Adjust minimum traction
                SetVehicleHandlingFloat(vehicle, "CHASSIS", "fTractionCurveMax", 1.0) -- Adjust maximum traction
                SetVehicleHandlingFloat(vehicle, "CHASSIS", "fTractionCurveLateral", 2.0) -- Adjust lateral traction
                SetVehicleHandlingFloat(vehicle, "CHASSIS", "fLowSpeedTractionLossMult", 0.0) -- Reduce traction loss at low speeds
                SetVehicleHandlingFloat(vehicle, "CHASSIS", "fTractionBiasFront", 0.5) -- Adjust front-wheel traction
            end
        end
    end
end)



