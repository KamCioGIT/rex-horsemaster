local Translations = {

    client = {
        lang_1 = 'Too Far Away!',
        lang_2 = 'Horse is too clean',
        lang_3 = 'Horse Brush Needed',
        lang_4 = 'Too Far Away!',
        lang_5 = 'Horse is Full!',
        lang_6 = 'Master Carrot Needed!',
        lang_7 = 'No Active Horse!',
        lang_8 = 'you do not have an active horse',
        lang_9 = 'Open ',
		lang_10 = 'Master Trainer Closed',
        lang_11 = 'come back after ',
        lang_12 = 'am',
        lang_13 = 'Master Trainer Menu',
        lang_14 = 'Open Master Trainer Shop',
        lang_15 = 'buy items from the shop',
        lang_16 = 'Master Trainer Shop',
    },

    server = {
        lang_1 = 'Horse XP Updated',
        lang_2 = '\'s',
        lang_3 = ' XP is now ',
        lang_4 = 'Horse Fully Trained',
        lang_5 = ' is fully trained',
    },

}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

-- Lang:t('client.lang_1')
-- Lang:t('server.lang_1')
