local currentWeather = 'CLEAR' -- Default weather
local isSnowing = false -- Track whether it's snowing
local playerVehicle = nil

-- Function to check for snow weather
local function isSnowWeather()
    return currentWeather == 'XMAS' -- Ensure this matches the server's string exactly
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Check for key press every frame (0 is more efficient)

        if IsControlJustReleased(0, 44) then -- 44 is the key code for 'Q'
            print("Current Weather on Key Press: " .. currentWeather) -- Debug print
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                if isSnowWeather() then
                    -- Trigger server event to add snowball to inventory
                    TriggerServerEvent('snow:collectSnowball')
                else
                    -- Notify the player that it's not snowing
                    QBCore.Functions.Notify("It's not snowing right now.", "error")
                end
            end
        end
    end
end)

-- Play pickup animation
RegisterNetEvent('snow:playPickupAnimation')
AddEventHandler('snow:playPickupAnimation', function()
    print("pewpew")
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "world_human_bum_wash", 0, true) -- Change the animation scenario
    Citizen.Wait(10000) -- Duration of the animation (adjust as needed)
    ClearPedTasks(playerPed)
end)

-- Update weather based on server event
RegisterNetEvent('updateWeather')
AddEventHandler('updateWeather', function(weather)
    currentWeather = weather
    isSnowing = isSnowWeather() -- Update the isSnowing variable
    print("Current Weather Updated: " .. currentWeather) -- Debug print
end)



-- Reset vehicle handling when the player exits the vehicle
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle ~= playerVehicle then
                playerVehicle = vehicle
            end
        else
            playerVehicle = nil
        end

        Citizen.Wait(1000) -- Check less frequently for performance reasons
    end
end)
