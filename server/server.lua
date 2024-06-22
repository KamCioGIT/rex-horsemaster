local RSGCore = exports['rsg-core']:GetCoreObject()

--------------------------------
-- use masterhorsebrush
--------------------------------
RSGCore.Functions.CreateUseableItem("masterhorsebrush", function(source, item)
    local src = source
    TriggerClientEvent('rex-horsemaster:client:brushHorse', src, item.name)
end)

--------------------------------
-- feed mastercarrot
--------------------------------
RSGCore.Functions.CreateUseableItem("mastercarrot", function(source, item)
    local src = source
    TriggerClientEvent('rex-horsemaster:client:feedHorse', src, item.name)
end)

--------------------------------
-- horse xp token use
--------------------------------
RSGCore.Functions.CreateUseableItem("horsexp5", function(source, item)
    local src = source
    TriggerClientEvent('rex-horsemaster:client:tokenupdatexp', src, item.name)
end)

RSGCore.Functions.CreateUseableItem("horsexp10", function(source, item)
    local src = source
    TriggerClientEvent('rex-horsemaster:client:tokenupdatexp', src, item.name)
end)

RSGCore.Functions.CreateUseableItem("horsexp25", function(source, item)
    local src = source
    TriggerClientEvent('rex-horsemaster:client:tokenupdatexp', src, item.name)
end)

RSGCore.Functions.CreateUseableItem("horsexp50", function(source, item)
    local src = source
    TriggerClientEvent('rex-horsemaster:client:tokenupdatexp', src, item.name)
end)

RSGCore.Functions.CreateUseableItem("horsexp100", function(source, item)
    local src = source
    TriggerClientEvent('rex-horsemaster:client:tokenupdatexp', src, item.name)
end)

RSGCore.Functions.CreateUseableItem("horsexp250", function(source, item)
    local src = source
    TriggerClientEvent('rex-horsemaster:client:tokenupdatexp', src, item.name)
end)

RSGCore.Functions.CreateUseableItem("horsexp500", function(source, item)
    local src = source
    TriggerClientEvent('rex-horsemaster:client:tokenupdatexp', src, item.name)
end)

RSGCore.Functions.CreateUseableItem("horsexp1000", function(source, item)
    local src = source
    TriggerClientEvent('rex-horsemaster:client:tokenupdatexp', src, item.name)
end)

--------------------------------
-- horse xp update
--------------------------------
RegisterNetEvent('rex-horsemaster:server:updatexp',function(action)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid

    local result = MySQL.query.await('SELECT * FROM player_horses WHERE citizenid = @citizenid AND active = @active',
    {
        ['@citizenid'] = cid,
        ['@active'] = 1
    })

    if result[1] then
        horsename = result[1].name
        horseid = result[1].horseid
        horsexp = result[1].horsexp
    end

    if action == 'leading' and horsexp <= Config.FullyTrained then
        newxp = horsexp + Config.LeadingXP

        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})

        if Config.Notification then
            TriggerClientEvent('ox_lib:notify', src, 
                { 
                    title = Lang:t('server.lang_1'),
                    description = horsename..Lang:t('server.lang_2')..Lang:t('server.lang_3')..newxp,
                    type = 'success',
                    icon = 'fa-solid fa-horse-head',
                    iconAnimation = 'shake',
                    duration = 7000
                }
            )
        end

        return
    end

    if action == 'cleaning' and horsexp <= Config.FullyTrained then
        newxp = horsexp + Config.CleaningXP

        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})

        if Config.Notification then
            TriggerClientEvent('ox_lib:notify', src, 
                { 
                    title = Lang:t('server.lang_1'),
                    description = horsename..Lang:t('server.lang_2')..Lang:t('server.lang_3')..newxp,
                    type = 'success',
                    icon = 'fa-solid fa-horse-head',
                    iconAnimation = 'shake',
                    duration = 7000
                }
            )
        end

        return
    end

    if action == 'feeding' and horsexp <= Config.FullyTrained then
        newxp = horsexp + Config.FeedingXP

        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})

        if Config.Notification then
            TriggerClientEvent('ox_lib:notify', src, 
                { 
                    title = Lang:t('server.lang_1'),
                    description = horsename..Lang:t('server.lang_2')..Lang:t('server.lang_3')..newxp,
                    type = 'success',
                    icon = 'fa-solid fa-horse-head',
                    iconAnimation = 'shake',
                    duration = 7000
                }
            )
        end

        return
    end
end)

--------------------------------
-- horse token xp update
--------------------------------
RegisterNetEvent('rex-horsemaster:server:tokenupdatexp',function(amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid

    local result = MySQL.query.await('SELECT * FROM player_horses WHERE citizenid = @citizenid AND active = @active',
    {
        ['@citizenid'] = cid,
        ['@active'] = 1
    })

    if result[1] then
        horsename = result[1].name
        horseid = result[1].horseid
        horsexp = result[1].horsexp
    end

    if horsexp >= Config.FullyTrained then
        TriggerClientEvent('ox_lib:notify', src, 
            {
                title = Lang:t('server.lang_4'),
                description = horsename..Lang:t('server.lang_5'),
                type = 'inform',
                icon = 'fa-solid fa-horse-head',
                iconAnimation = 'shake',
                duration = 7000
            }
        )
        return
    end

    if amount == 5 and horsexp <= Config.FullyTrained then
        newxp = horsexp + 5
        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
        Player.Functions.RemoveItem('horsexp5', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['horsexp5'], "remove")
        TriggerClientEvent('ox_lib:notify', src, 
            { 
                title = Lang:t('server.lang_1'),
                description = horsename..Lang:t('server.lang_2')..Lang:t('server.lang_3')..newxp,
                type = 'success',
                icon = 'fa-solid fa-horse-head',
                iconAnimation = 'shake',
                duration = 7000
            }
        )
        return
    end

    if amount == 10 and horsexp <= Config.FullyTrained then
        newxp = horsexp + 10
        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
        Player.Functions.RemoveItem('horsexp10', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['horsexp10'], "remove")
        TriggerClientEvent('ox_lib:notify', src, 
            { 
                title = Lang:t('server.lang_1'),
                description = horsename..Lang:t('server.lang_2')..Lang:t('server.lang_3')..newxp,
                type = 'success',
                icon = 'fa-solid fa-horse-head',
                iconAnimation = 'shake',
                duration = 7000
            }
        )
        return
    end

    if amount == 25 and horsexp <= Config.FullyTrained then
        newxp = horsexp + 25
        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
        Player.Functions.RemoveItem('horsexp25', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['horsexp25'], "remove")
        TriggerClientEvent('ox_lib:notify', src, 
            { 
                title = Lang:t('server.lang_1'),
                description = horsename..Lang:t('server.lang_2')..Lang:t('server.lang_3')..newxp,
                type = 'success',
                icon = 'fa-solid fa-horse-head',
                iconAnimation = 'shake',
                duration = 7000
            }
        )
        return
    end

    if amount == 50 and horsexp <= Config.FullyTrained then
        newxp = horsexp + 50
        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
        Player.Functions.RemoveItem('horsexp50', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['horsexp50'], "remove")
        TriggerClientEvent('ox_lib:notify', src, 
            { 
                title = Lang:t('server.lang_1'),
                description = horsename..Lang:t('server.lang_2')..Lang:t('server.lang_3')..newxp,
                type = 'success',
                icon = 'fa-solid fa-horse-head',
                iconAnimation = 'shake',
                duration = 7000
            }
        )
        return
    end

    if amount == 100 and horsexp <= Config.FullyTrained then
        newxp = horsexp + 100
        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
        Player.Functions.RemoveItem('horsexp100', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['horsexp100'], "remove")
        TriggerClientEvent('ox_lib:notify', src, 
            { 
                title = Lang:t('server.lang_1'),
                description = horsename..Lang:t('server.lang_2')..Lang:t('server.lang_3')..newxp,
                type = 'success',
                icon = 'fa-solid fa-horse-head',
                iconAnimation = 'shake',
                duration = 7000
            }
        )
        return
    end

    if amount == 250 and horsexp <= Config.FullyTrained then
        newxp = horsexp + 250
        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
        Player.Functions.RemoveItem('horsexp250', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['horsexp250'], "remove")
        TriggerClientEvent('ox_lib:notify', src, 
            { 
                title = Lang:t('server.lang_1'),
                description = horsename..Lang:t('server.lang_2')..Lang:t('server.lang_3')..newxp,
                type = 'success',
                icon = 'fa-solid fa-horse-head',
                iconAnimation = 'shake',
                duration = 7000
            }
        )
        return
    end

    if amount == 500 and horsexp <= Config.FullyTrained then
        newxp = horsexp + 500
        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
        Player.Functions.RemoveItem('horsexp500', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['horsexp500'], "remove")
        TriggerClientEvent('ox_lib:notify', src, 
            { 
                title = Lang:t('server.lang_1'),
                description = horsename..Lang:t('server.lang_2')..Lang:t('server.lang_3')..newxp,
                type = 'success',
                icon = 'fa-solid fa-horse-head',
                iconAnimation = 'shake',
                duration = 7000
            }
        )
        return
    end

    if amount == 1000 and horsexp <= Config.FullyTrained then
        newxp = horsexp + 1000
        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
        Player.Functions.RemoveItem('horsexp1000', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['horsexp1000'], "remove")
        TriggerClientEvent('ox_lib:notify', src, 
            { 
                title = Lang:t('server.lang_1'),
                description = horsename..Lang:t('server.lang_2')..Lang:t('server.lang_3')..newxp,
                type = 'success',
                icon = 'fa-solid fa-horse-head',
                iconAnimation = 'shake',
                duration = 7000
            }
        )
        return
    end

end)

--------------------------------
-- remove item
--------------------------------
RegisterNetEvent('rex-horsemaster:server:deleteItem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item], "remove")
end)
