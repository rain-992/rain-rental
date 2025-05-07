local ESX = nil
local QBCore = nil
local rentedVehicle = nil
local rentalTimer = 0
local isRenting = false
local rentalPeds = {}


CreateThread(function()
    if Config.Framework == 'ESX' then
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Wait(0)
        end
    else
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)


CreateThread(function()
    for k, v in pairs(Config.RentalLocations) do
        
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(blip, v.blipSprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, v.blipScale)
        SetBlipColour(blip, v.blipColor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.label)
        EndTextCommandSetBlipName(blip)

        
        local model = GetHashKey(v.pedModel)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
        
        local ped = CreatePed(4, model, v.coords.x, v.coords.y, v.coords.z - 1.0, v.coords.w, false, true)
        SetEntityHeading(ped, v.coords.w)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        
        
        if Config.Framework == 'ESX' then
            exports.ox_target:addLocalEntity(ped, {
                {
                    name = 'rental_vehicle',
                    icon = 'fas fa-car',
                    label = '租赁车辆',
                    onSelect = function()
                        OpenRentalMenu()
                    end
                }
            })
        else
            exports['qb-target']:AddTargetEntity(ped, {
                options = {
                    {
                        type = "client",
                        event = "qb-rental:client:openMenu",
                        icon = "fas fa-car",
                        label = "租赁车辆",
                    }
                },
                distance = 2.0
            })
        end
        
        table.insert(rentalPeds, ped)
    end
end)


function OpenRentalMenu()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openRental",
        vehicles = Config.RentableVehicles
    })
end


RegisterNUICallback('rentVehicle', function(data, cb)
    local vehicleModel = data.model
    local rentalTime = data.time
    
    local player = PlayerPedId()
    local playerCoords = GetEntityCoords(player)
    
   
    if Config.Framework == 'ESX' then
        ESX.TriggerServerCallback('esx_rental:checkMoney', function(canRent)
            if canRent then
                SpawnRentalVehicle(vehicleModel, playerCoords, rentalTime)
            else
                ESX.ShowNotification('你没有足够的钱租车！')
            end
        end, data.price * rentalTime)
    else
        QBCore.Functions.TriggerCallback('qb-rental:server:checkMoney', function(canRent)
            if canRent then
                SpawnRentalVehicle(vehicleModel, playerCoords, rentalTime)
            else
                QBCore.Functions.Notify('你没有足够的钱租车！', 'error')
            end
        end, data.price * rentalTime)
    end
    
    cb('ok')
end)

function SpawnRentalVehicle(model, coords, time)
    if Config.Framework == 'ESX' then
        ESX.Game.SpawnVehicle(model, coords, 90.0, function(vehicle)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            rentedVehicle = vehicle
            isRenting = true
            rentalTimer = time * 3600
            
            StartRentalTimer()
        end)
    else
        QBCore.Functions.SpawnVehicle(model, function(vehicle)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            rentedVehicle = vehicle
            isRenting = true
            rentalTimer = time * 3600
            
            StartRentalTimer()
        end, coords, true)
    end
end

function StartRentalTimer()
    CreateThread(function()
        while isRenting and rentalTimer > 0 do
            Wait(1000)
            rentalTimer = rentalTimer - 1
            if rentalTimer <= 0 then
                ReturnVehicle()
            end
        end
    end)
end

function ReturnVehicle()
    if rentedVehicle then
        DeleteVehicle(rentedVehicle)
        rentedVehicle = nil
        isRenting = false
        if Config.Framework == 'ESX' then
            ESX.ShowNotification('租赁时间结束，车辆已被收回')
        else
            QBCore.Functions.Notify('租赁时间结束，车辆已被收回', 'primary')
        end
    end
end

RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)


RegisterNetEvent('esx_rental:openMenu')
AddEventHandler('esx_rental:openMenu', function()
    OpenRentalMenu()
end)


RegisterNetEvent('qb-rental:client:openMenu')
AddEventHandler('qb-rental:client:openMenu', function()
    OpenRentalMenu()
end)