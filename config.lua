Config = {}

------------------------------
-- general settings
------------------------------
Config.Notification  = true -- show notification regarding Horse's EXP
Config.FullyTrained  = 5000  -- anything above 100 is overpower stamina and health
Config.LeadingXPTime = 10000 -- in millisectonds (10000 = 10 secs / 60000 = 1 min)
Config.LeadingXP     = 1 -- amount of xp per update
Config.CleaningXP    = 1 -- amount of xp per update
Config.FeedingXP     = 1 -- amount of xp per update
Config.HorseCleanCooldown = 1 -- cooldown before cleaning can take place again (in mins)
Config.HorseFeedCooldown  = 1 -- cooldown before feeding can take place again (in mins)

------------------------------
-- master trainer settings
------------------------------
Config.Debug = false
Config.KeyBind = 'J'
Config.DistanceSpawn = 20.0
Config.FadeIn = true
Config.OpenTime = 6
Config.CloseTime = 18
Config.AlwaysOpen = true

------------------------------
-- blip settings
------------------------------
Config.Blip = {
    blipName = 'Stable Master', -- Config.Blip.blipName
    blipSprite = 'blip_stable', -- Config.Blip.blipSprite
    blipScale = 0.2 -- Config.Blip.blipScale
}

------------------------------
-- prompt locations
------------------------------
Config.MasterTrainerLocations = {
    {   -- macfarlane ranch
        name = 'Macfarlane Master Trainer',
        prompt = 'macfarlane-mastertrainer',
        coords = vector3(-2402.41, -2460.61, 60.17),
        npcmodel = `u_m_m_bwmstablehand_01`,
        npccoords = vector4(-2402.41, -2460.61, 60.17, 64.97),
        showblip = true
    },
}

------------------------------
-- shop items
------------------------------
Config.MasterTrainerShop = {
    [1]  = { name = 'masterhorsebrush', price = 10,   amount = 500, info = {}, type = 'item', slot = 1, },
    [2]  = { name = 'mastercarrot',     price = 1,    amount = 500, info = {}, type = 'item', slot = 2, },
    [3]  = { name = 'horsexp5',         price = 5,    amount = 500, info = {}, type = 'item', slot = 3, },
    [4]  = { name = 'horsexp10',        price = 10,   amount = 500, info = {}, type = 'item', slot = 4, },
    [5]  = { name = 'horsexp25',        price = 25,   amount = 500, info = {}, type = 'item', slot = 5, },
    [6]  = { name = 'horsexp50',        price = 50,   amount = 500, info = {}, type = 'item', slot = 6, },
    [7]  = { name = 'horsexp100',       price = 100,  amount = 500, info = {}, type = 'item', slot = 7, },
    [8]  = { name = 'horsexp250',       price = 250,  amount = 500, info = {}, type = 'item', slot = 8, },
    [9]  = { name = 'horsexp500',       price = 500,  amount = 500, info = {}, type = 'item', slot = 9, },
    [10] = { name = 'horsexp1000',      price = 1000, amount = 500, info = {}, type = 'item', slot = 10, },
}
