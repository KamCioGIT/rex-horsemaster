local RSGCore = exports['rsg-core']:GetCoreObject()
local horsePed = 0
local horseEXP = 0
local maxedEXP = false
local walking = false
local leading = false
local cleancooldownSecondsRemaining = 0
local feedcooldownSecondsRemaining = 0
local SpawnedMasterTrainerBilps = {}

-----------------------------------------------------------------
-- master trainer prompts and blips
-----------------------------------------------------------------
Citizen.CreateThread(function()
    for _,v in pairs(Config.MasterTrainerLocations) do
        if v.showblip == true then
            local MasterTrainerBlip = BlipAddForCoords(1664425300, v.coords)
            SetBlipSprite(MasterTrainerBlip, joaat(Config.Blip.blipSprite), true)
            SetBlipScale(MasterTrainerBlip, Config.Blip.blipScale)
            SetBlipName(MasterTrainerBlip, v.name)
            table.insert(SpawnedMasterTrainerBilps, MasterTrainerBlip)
        end
    end
end)

--------------------------------------
-- master trainer hours system
--------------------------------------
local OpenMasterTrainer = function()
    if not Config.AlwaysOpen then
        local hour = GetClockHours()
        if (hour < Config.OpenTime) or (hour >= Config.CloseTime) and not Config.AlwaysOpen then
            lib.notify({
                title = Lang:t('client.lang_10'),
                description = Lang:t('client.lang_11')..Config.OpenTime..Lang:t('client.lang_12'),
                type = 'error',
                icon = 'fa-solid fa-shop',
                iconAnimation = 'shake',
                duration = 7000
            })
            return
        end
    end
    TriggerEvent('rex-horsemaster:client:mainmenu')
end

--------------------------------------
-- get master trainer hours function
--------------------------------------
local GetMasterTrainerHours = function()
    local hour = GetClockHours()
    if not Config.AlwaysOpen then
        if (hour < Config.OpenTime) or (hour >= Config.CloseTime) then
            for k, v in pairs(SpawnedMasterTrainerBilps) do
                BlipAddModifier(v, joaat('BLIP_MODIFIER_MP_COLOR_2'))
            end
        else
            for k, v in pairs(SpawnedMasterTrainerBilps) do
                BlipAddModifier(v, joaat('BLIP_MODIFIER_MP_COLOR_8'))
            end
        end
    else
        for k, v in pairs(SpawnedMasterTrainerBilps) do
            BlipAddModifier(v, joaat('BLIP_MODIFIER_MP_COLOR_8'))
        end
    end
end

--------------------------------------
-- get master trainer hours on player loading
--------------------------------------
RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
    GetMasterTrainerHours()
end)

---------------------------------
-- update master trainer hours every min
---------------------------------
CreateThread(function()
    while true do
        GetMasterTrainerHours()
        Wait(60000) -- every min
    end       
end)

---------------------------------
-- open master trainer
---------------------------------
AddEventHandler('rex-horsemaster:client:openmastertrainer', function()
    OpenMasterTrainer()
end)

-----------------------------------------------------------------
-- master trainer menu
-----------------------------------------------------------------
RegisterNetEvent('rex-horsemaster:client:mainmenu', function()
    lib.registerContext(
        {
            id = 'mastertrainer_menu',
            title = Lang:t('client.lang_13'),
            position = 'top-right',
            options = {
                {
                    title = Lang:t('client.lang_14'),
                    description = Lang:t('client.lang_15'),
                    icon = 'fas fa-shopping-basket',
                    event = 'rex-horsemaster:client:openshop',
                },
            }
        }
    )
    lib.showContext('mastertrainer_menu')
end)

-----------------------------------------------------------------
-- master trainer shop
-----------------------------------------------------------------
RegisterNetEvent('rex-horsemaster:client:openshop')
AddEventHandler('rex-horsemaster:client:openshop', function()
    local ShopItems = {}
    ShopItems.label = Lang:t('client.lang_16')
    ShopItems.items = Config.MasterTrainerShop
    ShopItems.slots = #Config.MasterTrainerShop
    TriggerServerEvent('inventory:server:OpenInventory', 'shop', 'MasterTrainer_'..math.random(1, 99), ShopItems)
end)

--------------------------------
-- check horse xp
--------------------------------
local function CheckEXP()
    RSGCore.Functions.TriggerCallback('rsg-horses:server:GetActiveHorse', function(data)
        horseEXP = data.horsexp
    end)
    maxedEXP = false
end

--------------------------------
-- cleaning cooldown timer
--------------------------------
local function CleaningCooldown()
    cleancooldownSecondsRemaining = (Config.HorseCleanCooldown * 60)

    Citizen.CreateThread(function()
        while cleancooldownSecondsRemaining > 0 do
            Wait(1000)
            cleancooldownSecondsRemaining = cleancooldownSecondsRemaining - 1
        end
    end)
end

--------------------------------
-- feeding cooldown timer
--------------------------------
local function FeedingCooldown()
    feedcooldownSecondsRemaining = (Config.HorseFeedCooldown * 60)

    Citizen.CreateThread(function()
        while feedcooldownSecondsRemaining > 0 do
            Wait(1000)
            feedcooldownSecondsRemaining = feedcooldownSecondsRemaining - 1
        end
    end)
end

--------------------------------
-- leading horse xp
--------------------------------
CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        local lastmount = Citizen.InvokeNative(0x4C8B59171957BCF7, ped) -- GetLastMount

        horsePed = exports['rsg-horses']:CheckActiveHorse()

        if lastmount ~= horsePed then goto continue end

        if Citizen.InvokeNative(0xDE4C184B2B9B071A, PlayerPedId()) then -- walking
            walking = true
        else
            walking = false
        end

        if Citizen.InvokeNative(0xEFC4303DDC6E60D3, PlayerPedId()) then -- leading
            leading = true
        else
            leading = false
        end

        CheckEXP()

        if horseEXP >= 5000 then
            maxedEXP = true
        end

        if maxedEXP then goto continue end

        if walking and leading then
            Wait(Config.LeadingXPTime)
            TriggerServerEvent('rex-horsemaster:server:updatexp', 'leading')
        end

        ::continue::
    end
end)

--------------------------------
-- brush horse for xp
--------------------------------
RegisterNetEvent('rex-horsemaster:client:brushHorse', function(item)

    if item ~= 'masterhorsebrush' then
        item = 'masterhorsebrush'
    end

    horsePed = exports['rsg-horses']:CheckActiveHorse()
    local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)
    local hCoords = GetEntityCoords(horsePed)
    local distance = #(pCoords - hCoords)
    local hasItem = RSGCore.Functions.HasItem(item, 1)

    if distance > 1.7 then
        lib.notify({
            title = Lang:t('client.lang_1'),
            type = 'error',
            icon = 'fa-solid fa-horse-head',
            iconAnimation = 'shake',
            duration = 7000
        })
        return
    end

    if cleancooldownSecondsRemaining ~= 0 then
        lib.notify({
            title = Lang:t('client.lang_2'),
            type = 'error',
            icon = 'fa-solid fa-horse-head',
            iconAnimation = 'shake',
            duration = 7000
        })
        return
    end

    if not hasItem then
        lib.notify({
            title = Lang:t('client.lang_3'),
            type = 'error',
            icon = 'fa-solid fa-horse-head',
            iconAnimation = 'shake',
            duration = 7000
        })
        return
    end

    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), horsePed, `INTERACTION_BRUSH`, 0, 0)

    Wait(8000)

    Citizen.InvokeNative(0xE3144B932DFDFF65, horsePed, 0.0, -1, 1, 1)
    ClearPedEnvDirt(horsePed)
    ClearPedDamageDecalByZone(horsePed, 10, "ALL")
    ClearPedBloodDamage(horsePed)

    CleaningCooldown()

    CheckEXP()

    if horseEXP >= 5000 then
        maxedEXP = true
    end

    if maxedEXP then return end

    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
    TriggerServerEvent('rex-horsemaster:server:updatexp', 'cleaning')
end)

--------------------------------
-- feed horse for xp
--------------------------------
RegisterNetEvent('rex-horsemaster:client:feedHorse',function(item)

    if item ~= 'mastercarrot' then
        item = 'mastercarrot'
    end

    horsePed = exports['rsg-horses']:CheckActiveHorse()
    local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)
    local hCoords = GetEntityCoords(horsePed)
    local distance = #(pCoords - hCoords)
    local hasItem = RSGCore.Functions.HasItem(item, 1)

    if distance > 1.7 then
        lib.notify({
            title = Lang:t('client.lang_4'),
            type = 'error',
            icon = 'fa-solid fa-horse-head',
            iconAnimation = 'shake',
            duration = 7000
        })
        return
    end

    if feedcooldownSecondsRemaining ~= 0 then
        lib.notify({
            title = Lang:t('client.lang_5'),
            type = 'error',
            icon = 'fa-solid fa-horse-head',
            iconAnimation = 'shake',
            duration = 7000
        })
        return
    end

    if not hasItem then
        lib.notify({
            title = Lang:t('client.lang_6'),
            type = 'error',
            icon = 'fa-solid fa-horse-head',
            iconAnimation = 'shake',
            duration = 7000
        })
        return
    end

    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), horsePed, -224471938, 0, 0)

    FeedingCooldown()

    CheckEXP()

    if horseEXP >= 5000 then
        maxedEXP = true
    end

    TriggerServerEvent('rex-horsemaster:server:deleteItem', item, 1)

    if maxedEXP then return end

    Wait(5000)

    TriggerServerEvent('rex-horsemaster:server:updatexp', 'feeding')
    Citizen.InvokeNative(0xC6258F41D86676E0, horsePed, 0, 600)  -- SetAttributeCoreValue (Health)
    Citizen.InvokeNative(0xC6258F41D86676E0, horsePed, 1, 600) -- SetAttributeCoreValue (Stamina)
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
end)

--------------------------------
-- use xp token
--------------------------------
RegisterNetEvent('rex-horsemaster:client:tokenupdatexp', function(item)

    local horsePed = exports['rsg-horses']:CheckActiveHorse()
    
    if horsePed ~= 0 then
    
        if item == 'horsexp5' then
            TriggerServerEvent('rex-horsemaster:server:tokenupdatexp', 5)
        end
        
        if item == 'horsexp10' then
            TriggerServerEvent('rex-horsemaster:server:tokenupdatexp', 10)
        end
        
        if item == 'horsexp25' then
            TriggerServerEvent('rex-horsemaster:server:tokenupdatexp', 25)
        end
        
        if item == 'horsexp50' then
            TriggerServerEvent('rex-horsemaster:server:tokenupdatexp', 50)
        end
        
        if item == 'horsexp100' then
            TriggerServerEvent('rex-horsemaster:server:tokenupdatexp', 100)
        end
        
        if item == 'horsexp250' then
            TriggerServerEvent('rex-horsemaster:server:tokenupdatexp', 250)
        end
        
        if item == 'horsexp500' then
            TriggerServerEvent('rex-horsemaster:server:tokenupdatexp', 500)
        end
        
        if item == 'horsexp1000' then
            TriggerServerEvent('rex-horsemaster:server:tokenupdatexp', 1000)
        end
        
    else
        lib.notify({ title = Lang:t('client.lang_7'), description = Lang:t('client.lang_8'), type = 'error' })
    end
    
end)
