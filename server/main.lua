local ESX = nil
local QBCore = nil

if Config.Framework == 'ESX' then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
else
    QBCore = exports['qb-core']:GetCoreObject()
end

if Config.Framework == 'ESX' then
    ESX.RegisterServerCallback('esx_rental:checkMoney', function(source, cb, price)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            cb(true)
        else
            cb(false)
        end
    end)
else
    QBCore.Functions.CreateCallback('qb-rental:server:checkMoney', function(source, cb, price)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.PlayerData.money.cash >= price then
            Player.Functions.RemoveMoney('cash', price)
            cb(true)
        else
            cb(false)
        end
    end)
end