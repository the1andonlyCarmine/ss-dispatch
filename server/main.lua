local QBCore = exports['qb-core']:GetCoreObject()
local calls = {}

function GetDispatchCalls() return calls end
exports('GetDispatchCalls', GetDispatchCalls)
-- Functions
--exports('GetDispatchCalls', function() return calls end)

-- Events
RegisterServerEvent('ps-dispatch:server:notify', function(data)
    data.id = #calls + 1
    data.time = os.time() * 1000
    data.units = {}
    data.responses = {}
    calls[#calls + 1] = data

    TriggerClientEvent('ps-dispatch:client:notify', -1, data)
end)

RegisterServerEvent('ps-dispatch:server:attach', function(id, player)
    for i=1, #calls[id]['units'] do
        if calls[id]['units'][i]['citizenid'] == player.citizenid then return end
    end

    calls[id]['units'][#calls[id]['units'] + 1] = player
end)

RegisterServerEvent('ps-dispatch:server:detach', function(id, player)
    if not calls[id] then return end
    if not #calls[id]['units'] then return end

    for i=1, #calls[id]['units'] do
        if calls[id]['units'][i]['citizenid'] == player.citizenid then
            calls[id]['units'][i] = nil
        end
    end
end)

-- Callbacks
lib.callback.register('ps-dispatch:callback:getLatestDispatch', function(source)
    return calls[#calls]
end)

lib.callback.register('ps-dispatch:callback:getCalls', function(source)
    return calls
end)

-- Commands
lib.addCommand('dispatch', {
    help = locale('open_dispatch')
}, function(source, raw)
    TriggerClientEvent("ps-dispatch:client:openMenu", source, calls)
end)

lib.addCommand('911', {
    help = 'Send a message to 911',
    params = { { name = 'message', type = 'string', help = '911 Message' }},
}, function(source, args, raw)
    local fullMessage = raw:sub(5)
    TriggerClientEvent('ps-dispatch:client:sendEmergencyMsg', source, fullMessage, "911", false)
end)
lib.addCommand('911a', {
    help = 'Send an anonymous message to 911',
    params = { { name = 'message', type = 'string', help = '911 Message' }},
}, function(source, args, raw)
    local fullMessage = raw:sub(5)
    TriggerClientEvent('ps-dispatch:client:sendEmergencyMsg', source, fullMessage, "911", true)
end)

lib.addCommand('311', {
    help = 'Send a message to 311',
    params = { { name = 'message', type = 'string', help = '311 Message' }},
}, function(source, args, raw)
    local fullMessage = raw:sub(5)
    TriggerClientEvent('ps-dispatch:client:sendEmergencyMsg', source, fullMessage, "311", false)
end)

lib.addCommand('311a', {
    help = 'Send an anonymous message to 311',
    params = { { name = 'message', type = 'string', help = '311 Message' }},
}, function(source, args, raw)
    local fullMessage = raw:sub(5)
    TriggerClientEvent('ps-dispatch:client:sendEmergencyMsg', source, fullMessage, "311", true)
end)

