QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent(("%s:server:notify"):format(GetCurrentResourceName()), function (data)
  TriggerClientEvent(("%s:client:notify"):format(GetCurrentResourceName()), -1, data)
end)

RegisterNetEvent(("%s:server:requestNotify"):format(GetCurrentResourceName()), function (target, data)
  TriggerClientEvent(("%s:client:notify"):format(GetCurrentResourceName()), target, data)
end)
