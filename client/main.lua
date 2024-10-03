QBCore = exports['qb-core']:GetCoreObject()

local VALIDKEYS = {
    title = "string",
    description = "string",
    avatar = "string",
    icon = "string",
    timeout = "number",
    color = "string",
    sound = "string",
    actions = "table"
}

local function validKeys(data)
    local unknownKeys = {}
    local invalidTypes = {}

    -- Vérification des types pour les clés valides présentes
    for key, value in pairs(data) do
        local expectedType = VALIDKEYS[key]
        if expectedType then
            if type(value) ~= expectedType then
                table.insert(invalidTypes, key)
            end
        else
            table.insert(unknownKeys, key)
        end
    end

    -- Vérification des clés unknownKeys & invalidTypes
    if #unknownKeys > 0 then
        error(Lang:t('error.unknown_keys', { unknownKeys = table.concat(unknownKeys, ", ") }))
    elseif #invalidTypes > 0 then
        local invalidKeyMessages = {}

        for _, key in ipairs(invalidTypes) do
            table.insert(invalidKeyMessages, key .. ' '.. Lang:t('util.needToBe')..' ' .. VALIDKEYS[key] )
        end

        if #invalidKeyMessages > 0 then
            error(Lang:t('error.invalid_key_type', { invalidTypes = table.concat(invalidKeyMessages, "; ") }))
        end
    end
end

local function getConfigPreset(data)
    if config.presetNotif[data] then
        return config.presetNotif[data]
    else
        error(Lang:t('error.preset_issue'))
    end
end

local function Notify(data, global)

    if global then
        TriggerServerEvent(("%s:server:notify"):format(GetCurrentResourceName()), data)
        return
    end

    local content

    if type(data) == "table" then
        validKeys(data)
        content = data
    elseif type(data) == "string" then
        content = getConfigPreset(data)
        validKeys(content)
    else
        error(Lang:t('error.invalid_parameter'))
    end

    if content.actions then
        SetNuiFocus(true, true)
    end
    SendNUIMessage({
        type = 'notify',
        content = content
    })

end

exports('Notify', Notify)
RegisterNetEvent(("%s:client:notify"):format(GetCurrentResourceName()), Notify)


local function RequestNotify(target, data)
    TriggerServerEvent(("%s:server:requestNotify"):format(GetCurrentResourceName()), target, data)
end

exports('RequestNotify', RequestNotify)
RegisterNetEvent(("%s:client:RequestNotify"):format(GetCurrentResourceName()), RequestNotify)


RegisterCommand('demoCar', function()
    local coords = GetEntityCoords(PlayerPedId())
    local closestPlayer, distance = QBCore.Functions.GetClosestPlayer(coords)

    exports['bz-notify']:RequestNotify(GetPlayerServerId(closestPlayer), {
        title = "Do you want car ?",
        icon = 'truck',
        timeout= 10000,
        color= "info",
        actions = {
            {
                label= "Yes",
                event= "car",
                side= "qbcommand",
                parameters = {'t20'},
            },
            {
                label= "No",
            },
        }
    })
end)

RegisterCommand('demoHeal', function()
    local coords = GetEntityCoords(PlayerPedId())
    local closestPlayer, distance = QBCore.Functions.GetClosestPlayer(coords)

    exports['bz-notify']:RequestNotify(GetPlayerServerId(closestPlayer), {
        title = "Do you need heal ?",
        description = "I think it's a bad idea to refuse",
        avatar = 'pillbox.png',
        timeout= 10000,
        color= "error",
        actions = {
            {
                label= "Why not !",
                event= "hospital:client:Revive",
                side= "client",
                parameters = {},
            },
            {
                label= "Nah...",
                event= "kill",
                side= "qbcommand",
                parameters = {},
            },
        }
    })
end)


RegisterCommand('demo', function()
    exports['bz-notify']:Notify({
        description = 'Hey, I am a notification with just a description!',
        color = 'info',
        timeout= 5000
    })
    Wait(2000)
    exports['bz-notify']:Notify({
        description = 'And me with an icon',
        icon = 'hand-raised',
        color = 'success',
        timeout= 5000
    })
    Wait(2000)
    exports['bz-notify']:Notify({
        description = 'But you can have an image if you want',
        avatar = 'pillbox.png',
        color = 'warning',
        timeout= 5000
    })
    Wait(2000)
    exports['bz-notify']:Notify({
        title = 'And a title!',
        description = 'With me, you have a title and an image',
        avatar = 'pillbox.png',
        color = 'error',
        timeout= 5000
    })
    Wait(2000)
    exports['bz-notify']:Notify({
        title = 'Urgent!',
        description = 'For emergencies, you can use a custom sound',
        avatar = 'pillbox.png',
        color = 'error',
        sound = 'emergency.mp3',
        timeout= 5000
    })
    Wait(2000)
    exports['bz-notify']:Notify({
        title = 'The most important',
        description = 'I can be whatever you want!',
        avatar = 'love.webp',
        color = 'pink',
        sound = 'bye.mp3',
        timeout= 5000
    })
end)

RegisterNUICallback('request_config', function(data, cb)
    cb(config.notification)
end)

RegisterNUICallback('request_notif_result', function(data, cb)
    SetNuiFocus(false, false)  -- Désactive le focus NUI

    -- Vérifie si data.response existe
    if not data.response then
        cb('no response')
        return
    end

    -- Vérifie le type de response
    if data.response.side then
        local response = data.response
        
        -- Traite le côté client
        if response.side == 'client' then
            if type(response.parameters) == 'table' then
                if #response.parameters > 0 then
                    TriggerEvent(response.event, table.unpack(response.parameters))
                else
                    TriggerEvent(response.event, response.parameters)
                end
            else
                print("Type non reconnu.")
            end
            
        -- Traite le côté serveur
        elseif response.side == 'server' then
            if type(response.parameters) == 'table' then
                if #response.parameters > 0 then
                    TriggerServerEvent(response.event, table.unpack(response.parameters))
                else
                    TriggerServerEvent(response.event, response.parameters)
                end
            else
                print("Type non reconnu.")
            end
            
        -- Traite le côté commande
        elseif response.side == 'command' then
            ExecuteCommand(response.event)
            
        -- Traite le côté qbcommand
        elseif response.side == 'qbcommand' then
            TriggerServerEvent('QBCore:CallCommand', response.event, response.parameters)
            
        -- Traite le côté exports
        elseif response.side == 'exports' then
            local export = response.export
            if export and export.scriptName and export.exportName then
                local scriptName = export.scriptName
                local exportName = export.exportName
                if type(response.parameters) == 'table' then
                    if #response.parameters > 0 then
                        exports[scriptName][exportName](0, table.unpack(response.parameters))
                    else
                        exports[scriptName][exportName](0, response.parameters)
                    end
                else
                    print("Type non reconnu.")
                end
            else
                error('Missing data in export table: scriptName and exportName are required')
            end
        else
            error('Invalid response side: ' .. tostring(response.side))
        end
    end
    cb('ok')
end)









