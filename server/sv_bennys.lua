local QBCore = exports['qb-core']:GetCoreObject()

local chicken = vehicleBaseRepairCost

RegisterServerEvent('qb-customs:attemptPurchase')
AddEventHandler('qb-customs:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    local balance = Player.PlayerData.money["bank"]
    if type == "repair" then
        if balance >= chicken then
            Player.Functions.RemoveMoney('bank',chicken)
            TriggerClientEvent('qb-customs:purchaseSuccessful', source)
        else
            TriggerClientEvent('qb-customs:purchaseFailed', source)
        end
    elseif type == "performance" then
        if balance >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('qb-customs:purchaseSuccessful', source)
            Player.Functions.RemoveMoney('bank', vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('qb-customs:purchaseFailed', source)
        end
    else
        if balance >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('qb-customs:purchaseSuccessful', source)
            Player.Functions.RemoveMoney('bank', vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('qb-customs:purchaseFailed', source)
        end
    end
end)


RegisterNetEvent('qb-customs:updateRepairCost', function(cost)
    chicken = cost
end)

RegisterNetEvent("updateVehicle", function(myCar)
    local src = source
    if IsVehicleOwned(myCar.plate) then
        exports.oxmysql:execute('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {json.encode(myCar), myCar.plate})
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    local result = exports.oxmysql:scalarSync('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        retval = true
    end
    return retval
end