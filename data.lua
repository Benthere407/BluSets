-- Generated from the server blue_traits, blue_spell_list and traits tables. See README.md.

return {
    -- Trait categories. Each tier lists the trait points needed and what the tier grants.
    traits = {
        [1] = { name = 'Beast Killer', group = 'Killer', keywords = '', tiers = {
            { points = 8, trait = 32, name = 'Beast Killer I', effect = 'Beast Killer +8' },
            { points = 16, trait = 32, name = 'Beast Killer II', effect = 'Beast Killer +10' },
            { points = 24, trait = 32, name = 'Beast Killer III', effect = 'Beast Killer +12' },
        } },
        [2] = { name = 'Auto Regen', group = 'Defense', keywords = 'hp', tiers = {
            { points = 8, trait = 9, name = 'Auto Regen', effect = 'Regen +1 HP/tick' },
        } },
        [3] = { name = 'Lizard Killer', group = 'Killer', keywords = '', tiers = {
            { points = 8, trait = 35, name = 'Lizard Killer I', effect = 'Lizard Killer +8' },
            { points = 16, trait = 35, name = 'Lizard Killer II', effect = 'Lizard Killer +10' },
        } },
        [4] = { name = 'Clear Mind', group = 'Magic', keywords = '', tiers = {
            { points = 8, trait = 24, name = 'Clear Mind I', effect = 'MP While Healing +3' },
            { points = 16, trait = 24, name = 'Clear Mind II', effect = 'MP While Healing +6' },
            { points = 24, trait = 24, name = 'Clear Mind III', effect = 'MP While Healing +9, MP While Healing +1' },
        } },
        [5] = { name = 'Resist Sleep', group = 'Resistance', keywords = '', tiers = {
            { points = 8, trait = 48, name = 'Resist Sleep I', effect = 'Resist Sleep +10' },
            { points = 16, trait = 48, name = 'Resist Sleep II', effect = 'Resist Sleep +15' },
        } },
        [6] = { name = 'Magic Attack Bonus', group = 'Magic', keywords = 'magic magical nuke', tiers = {
            { points = 8, trait = 5, name = 'Magic Attack Bonus I', effect = 'Magic Attack +20' },
            { points = 16, trait = 5, name = 'Magic Attack Bonus II', effect = 'Magic Attack +24' },
            { points = 24, trait = 5, name = 'Magic Attack Bonus III', effect = 'Magic Attack +28' },
        } },
        [7] = { name = 'Undead Killer', group = 'Killer', keywords = '', tiers = {
            { points = 8, trait = 39, name = 'Undead Killer', effect = 'Undead Killer +8' },
        } },
        [8] = { name = 'Attack Bonus', group = 'Physical', keywords = 'physical melee ranged', tiers = {
            { points = 8, trait = 3, name = 'Attack Bonus I', effect = 'Attack +10, Ranged Attack +10' },
            { points = 16, trait = 3, name = 'Attack Bonus II', effect = 'Attack +22, Ranged Attack +22' },
            { points = 24, trait = 3, name = 'Attack Bonus III', effect = 'Attack +35, Ranged Attack +35' },
        } },
        [9] = { name = 'Rapid Shot', group = 'Physical', keywords = 'ranged', tiers = {
            { points = 8, trait = 11, name = 'Rapid Shot', effect = 'Rapid Shot +25%' },
        } },
        [10] = { name = 'Max MP Boost', group = 'Magic', keywords = 'mp', tiers = {
            { points = 8, trait = 8, name = 'Max MP Boost I', effect = 'Max MP +10' },
            { points = 16, trait = 8, name = 'Max MP Boost II', effect = 'Max MP +20' },
        } },
        [11] = { name = 'Defense Bonus', group = 'Defense', keywords = 'physical melee tank', tiers = {
            { points = 8, trait = 4, name = 'Defense Bonus I', effect = 'Defense +10' },
            { points = 16, trait = 4, name = 'Defense Bonus II', effect = 'Defense +22' },
            { points = 24, trait = 4, name = 'Defense Bonus III', effect = 'Defense +35' },
        } },
        [12] = { name = 'Plantoid Killer', group = 'Killer', keywords = '', tiers = {
            { points = 8, trait = 33, name = 'Plantoid Killer I', effect = 'Plantoid Killer +8' },
            { points = 16, trait = 33, name = 'Plantoid Killer II', effect = 'Plantoid Killer +10' },
        } },
        [13] = { name = 'Magic Defense Bonus', group = 'Defense', keywords = 'magic magical', tiers = {
            { points = 8, trait = 6, name = 'Magic Defense Bonus I', effect = 'Magic Defense +10' },
            { points = 16, trait = 6, name = 'Magic Defense Bonus II', effect = 'Magic Defense +12' },
            { points = 24, trait = 6, name = 'Magic Defense Bonus III', effect = 'Magic Defense +14' },
        } },
        [14] = { name = 'Auto Refresh', group = 'Magic', keywords = 'mp', tiers = {
            { points = 8, trait = 10, name = 'Auto Refresh', effect = 'Refresh +1 MP/tick' },
        } },
        [15] = { name = 'Max HP Boost', group = 'Defense', keywords = 'tank', tiers = {
            { points = 8, trait = 7, name = 'Max HP Boost I', effect = 'Max HP +30' },
            { points = 16, trait = 7, name = 'Max HP Boost II', effect = 'Max HP +60' },
            { points = 24, trait = 7, name = 'Max HP Boost III', effect = 'Max HP +120' },
        } },
        [16] = { name = 'Accuracy Bonus', group = 'Physical', keywords = 'physical melee', tiers = {
            { points = 8, trait = 1, name = 'Accuracy Bonus I', effect = 'Accuracy +10, Ranged Accuracy +10' },
            { points = 16, trait = 1, name = 'Accuracy Bonus II', effect = 'Accuracy +22, Ranged Accuracy +22' },
            { points = 24, trait = 1, name = 'Accuracy Bonus III', effect = 'Accuracy +35, Ranged Accuracy +35' },
        } },
        [17] = { name = 'Conserve MP', group = 'Magic', keywords = 'mp', tiers = {
            { points = 8, trait = 13, name = 'Conserve MP I', effect = 'Conserve MP +25' },
            { points = 16, trait = 13, name = 'Conserve MP II', effect = 'Conserve MP +28' },
            { points = 24, trait = 13, name = 'Conserve MP III', effect = 'Conserve MP +31' },
        } },
        [18] = { name = 'Evasion Bonus', group = 'Defense', keywords = 'physical melee dodge', tiers = {
            { points = 8, trait = 2, name = 'Evasion Bonus I', effect = 'Evasion +10' },
            { points = 16, trait = 2, name = 'Evasion Bonus II', effect = 'Evasion +22' },
            { points = 24, trait = 2, name = 'Evasion Bonus III', effect = 'Evasion +35' },
        } },
        [19] = { name = 'Resist Gravity', group = 'Resistance', keywords = '', tiers = {
            { points = 8, trait = 58, name = 'Resist Gravity', effect = 'Resist Gravity +10' },
        } },
        [20] = { name = 'Store TP', group = 'Physical', keywords = 'tp melee', tiers = {
            { points = 8, trait = 14, name = 'Store TP I', effect = 'Store TP +10' },
            { points = 16, trait = 14, name = 'Store TP II', effect = 'Store TP +15' },
            { points = 24, trait = 14, name = 'Store TP III', effect = 'Store TP +20' },
        } },
        [21] = { name = 'Counter', group = 'Defense', keywords = 'melee', tiers = {
            { points = 8, trait = 17, name = 'Counter I', effect = 'Counter +10%' },
            { points = 16, trait = 17, name = 'Counter II', effect = 'Counter +12%' },
        } },
        [22] = { name = 'Fast Cast', group = 'Magic', keywords = 'magic cast', tiers = {
            { points = 8, trait = 12, name = 'Fast Cast I', effect = 'Fast Cast +5%' },
            { points = 16, trait = 12, name = 'Fast Cast II', effect = 'Fast Cast +10%' },
            { points = 24, trait = 12, name = 'Fast Cast III', effect = 'Fast Cast +15%' },
        } },
        [23] = { name = 'Skillchain Bonus', group = 'Physical', keywords = 'skillchain', tiers = {
            { points = 8, trait = 106, name = 'Skillchain Bonus I', effect = 'Skillchain Damage +8%' },
            { points = 12, trait = 106, name = 'Skillchain Bonus II', effect = 'Skillchain Damage +12%' },
            { points = 16, trait = 106, name = 'Skillchain Bonus III', effect = 'Skillchain Damage +16%' },
        } },
        [24] = { name = 'Double Attack / Triple Attack', group = 'Physical', keywords = 'multi hit melee multi hit melee', tiers = {
            { points = 8, trait = 15, name = 'Double Attack', effect = 'Double Attack +7%' },
            { points = 16, trait = 16, name = 'Triple Attack', effect = 'Triple Attack +5%' },
        } },
        [25] = { name = 'Dual Wield', group = 'Physical', keywords = 'melee', tiers = {
            { points = 8, trait = 18, name = 'Dual Wield I', effect = 'Dual Wield +10%' },
            { points = 16, trait = 18, name = 'Dual Wield II', effect = 'Dual Wield +15%' },
            { points = 24, trait = 18, name = 'Dual Wield III', effect = 'Dual Wield +25%' },
        } },
        [26] = { name = 'Zanshin', group = 'Physical', keywords = 'melee', tiers = {
            { points = 8, trait = 70, name = 'Zanshin', effect = 'Zanshin +15%' },
        } },
        [27] = { name = 'Magic Burst Bonus', group = 'Magic', keywords = 'magic nuke', tiers = {
            { points = 8, trait = 110, name = 'Magic Burst Bonus I', effect = 'Magic Burst Damage +5%' },
            { points = 12, trait = 110, name = 'Magic Burst Bonus II', effect = 'Magic Burst Damage +7%' },
            { points = 16, trait = 110, name = 'Magic Burst Bonus III', effect = 'Magic Burst Damage +9%' },
        } },
        [28] = { name = 'Gilfinder / Treasure Hunter', group = 'Utility', keywords = 'gil loot th', tiers = {
            { points = 8, trait = 20, name = 'Gilfinder', effect = 'Gilfinder +1' },
            { points = 12, trait = 19, name = 'Treasure Hunter', effect = 'Treasure Hunter +1' },
        } },
        [101] = { name = 'Resist Slow', group = 'Resistance', keywords = 'magic magical', tiers = { } },
        [102] = { name = 'Resist Silence', group = 'Resistance', keywords = 'magic magical', tiers = { } },
        [103] = { name = 'Crit. Atk. Bonus', group = 'Physical', keywords = 'magic magical', tiers = { } },
        [104] = { name = 'Inquartata', group = 'Defense', keywords = 'magic magical', tiers = { } },
        [105] = { name = 'Tenacity', group = 'Defense', keywords = 'magic magical', tiers = { } },
        [106] = { name = 'Magic Evasion Bonus', group = 'Defense', keywords = 'magic magical', tiers = { } },
        [107] = { name = 'Magic Accuracy Bonus', group = 'Magic', keywords = 'magic magical', tiers = { } },
    },

    -- Spells by id (offset by 512). cat is 0 for spells without a trait; weight and stats come from the help text of the game.
    spells = {
        [1] = { points = 3, cat = 4, weight = 4, stats = 'MND+2' },
        [3] = { points = 5, cat = 4, weight = 4, stats = 'MND+2' },
        [5] = { points = 1, cat = 10, weight = 4 },
        [7] = { points = 3, cat = 18, weight = 4, stats = 'VIT+1 CHR+1 HP+10' },
        [9] = { points = 4, cat = 0, weight = 0, stats = 'MP+5' },
        [10] = { points = 2, cat = 0, weight = 0, stats = 'HP-5 MP+5' },
        [12] = { points = 2, cat = 0, weight = 0, stats = 'VIT+1' },
        [15] = { points = 3, cat = 7, weight = 4, stats = 'AGI+3' },
        [17] = { points = 2, cat = 7, weight = 4, stats = 'STR+1' },
        [18] = { points = 4, cat = 101, weight = 4, stats = 'AGI+2' },
        [19] = { points = 3, cat = 13, weight = 4, stats = 'INT+1' },
        [20] = { points = 4, cat = 0, weight = 0, stats = 'DEX+3' },
        [21] = { points = 3, cat = 14, weight = 2, stats = 'STR+2' },
        [22] = { points = 4, cat = 10, weight = 4, stats = 'AGI+3' },
        [23] = { points = 1, cat = 14, weight = 1, stats = 'INT-1' },
        [24] = { points = 1, cat = 4, weight = 4, stats = 'MND+1' },
        [25] = { points = 2, cat = 14, weight = 1, stats = 'AGI+1' },
        [26] = { points = 4, cat = 6, weight = 4, stats = 'INT+1' },
        [27] = { points = 3, cat = 11, weight = 4, stats = 'HP-5 MP+10' },
        [28] = { points = 4, cat = 8, weight = 4, stats = 'VIT+2 INT+1 MND+1' },
        [29] = { points = 2, cat = 0, weight = 0, stats = 'HP-5 MP+5' },
        [30] = { points = 2, cat = 0, weight = 0, stats = 'HP-5 MP+5' },
        [31] = { points = 2, cat = 12, weight = 4, stats = 'INT+1' },
        [32] = { points = 2, cat = 6, weight = 4, stats = 'MND+1' },
        [33] = { points = 4, cat = 20, weight = 4, stats = 'HP-5 MP+15' },
        [35] = { points = 1, cat = 0, weight = 0, stats = 'VIT+3' },
        [36] = { points = 3, cat = 4, weight = 4, stats = 'VIT+1' },
        [37] = { points = 1, cat = 5, weight = 4, stats = 'CHR+1 HP+5' },
        [39] = { points = 1, cat = 12, weight = 4, stats = 'MND+1' },
        [42] = { points = 5, cat = 8, weight = 4, stats = 'MND+2 CHR+2 HP+5' },
        [43] = { points = 3, cat = 13, weight = 4, stats = 'VIT+2' },
        [45] = { points = 4, cat = 6, weight = 4, stats = 'HP-5 MP+15' },
        [48] = { points = 3, cat = 16, weight = 4, stats = 'INT+1' },
        [49] = { points = 3, cat = 14, weight = 2, stats = 'AGI+2' },
        [51] = { points = 3, cat = 10, weight = 4, stats = 'AGI+1' },
        [52] = { points = 4, cat = 15, weight = 4, stats = 'VIT+1 MP+5' },
        [53] = { points = 4, cat = 0, weight = 0, stats = 'CHR+1 HP+5' },
        [55] = { points = 2, cat = 0, weight = 0, stats = 'CHR+1 HP+5' },
        [57] = { points = 4, cat = 9, weight = 4, stats = 'DEX+2' },
        [58] = { points = 2, cat = 0, weight = 0, stats = 'HP-5 MP+5' },
        [60] = { points = 1, cat = 6, weight = 4 },
        [61] = { points = 3, cat = 4, weight = 4, stats = 'AGI+1' },
        [62] = { points = 2, cat = 19, weight = 4 },
        [63] = { points = 4, cat = 0, weight = 0, stats = 'MP+15' },
        [64] = { points = 3, cat = 5, weight = 4, stats = 'CHR+1 HP+5' },
        [65] = { points = 2, cat = 3, weight = 4, stats = 'AGI+1' },
        [66] = { points = 3, cat = 5, weight = 4, stats = 'HP+5' },
        [67] = { points = 4, cat = 14, weight = 3, stats = 'AGI+2' },
        [69] = { points = 4, cat = 2, weight = 4, stats = 'CHR+2 HP+10' },
        [70] = { points = 2, cat = 17, weight = 4, stats = 'AGI+1' },
        [72] = { points = 2, cat = 2, weight = 4, stats = 'CHR+1 HP+5' },
        [73] = { points = 4, cat = 3, weight = 4, stats = 'HP+5' },
        [75] = { points = 2, cat = 3, weight = 4, stats = 'VIT+1' },
        [76] = { points = 2, cat = 4, weight = 4, stats = 'HP-5' },
        [77] = { points = 5, cat = 16, weight = 4, stats = 'DEX+1 CHR+1 HP+5' },
        [79] = { points = 4, cat = 6, weight = 4, stats = 'STR+3' },
        [80] = { points = 2, cat = 0, weight = 0 },
        [81] = { points = 3, cat = 5, weight = 4, stats = 'CHR+1 HP+5' },
        [82] = { points = 3, cat = 8, weight = 4, stats = 'STR+2 DEX+1' },
        [83] = { points = 5, cat = 1, weight = 4, stats = 'VIT+3 AGI+3' },
        [84] = { points = 2, cat = 0, weight = 0, stats = 'STR+1' },
        [85] = { points = 2, cat = 1, weight = 4, stats = 'MND+1' },
        [86] = { points = 4, cat = 4, weight = 4, stats = 'HP-5 MP+5' },
        [87] = { points = 2, cat = 0, weight = 0, stats = 'HP-5 MP+5' },
        [89] = { points = 0, cat = 0, weight = 0, stats = 'HP+5 MP+5' },
        [91] = { points = 3, cat = 1, weight = 4, stats = 'CHR+1 HP+10' },
        [92] = { points = 5, cat = 22, weight = 4, stats = 'INT+2 MND+2' },
        [93] = { points = 3, cat = 0, weight = 0, stats = 'HP-5 MP+10' },
        [94] = { points = 2, cat = 4, weight = 4, stats = 'MND+1' },
        [96] = { points = 3, cat = 17, weight = 4, stats = 'INT-2' },
        [98] = { points = 4, cat = 0, weight = 0, stats = 'INT+1' },
        [99] = { points = 5, cat = 16, weight = 4, stats = 'INT+1 MND-1' },
        [100] = { points = 4, cat = 14, weight = 4, stats = 'HP+20 CHR+2' },
        [101] = { points = 5, cat = 6, weight = 4, stats = 'INT+3 MND+3' },
        [102] = { points = 3, cat = 11, weight = 4, stats = 'MP+10 VIT+2 AGI+2' },
        [103] = { points = 5, cat = 14, weight = 4, stats = 'STR+3 DEX+3' },
        [104] = { points = 5, cat = 8, weight = 4, stats = 'HP+10 MP+15' },
        [105] = { points = 3, cat = 11, weight = 4, stats = 'VIT+1 HP-5 MP+5' },
        [106] = { points = 2, cat = 0, weight = 0, stats = 'STR+1' },
        [108] = { points = 3, cat = 8, weight = 4, stats = 'DEX+2' },
        [109] = { points = 2, cat = 4, weight = 4, stats = 'VIT+1' },
        [110] = { points = 2, cat = 11, weight = 4, stats = 'INT+1' },
        [111] = { points = 3, cat = 0, weight = 0, stats = 'DEX+2' },
        [114] = { points = 3, cat = 0, weight = 0, stats = 'STR+2' },
        [116] = { points = 3, cat = 15, weight = 4, stats = 'DEX+2' },
        [117] = { points = 3, cat = 15, weight = 4, stats = 'AGI+1' },
        [119] = { points = 3, cat = 9, weight = 4, stats = 'MND+2' },
        [120] = { points = 3, cat = 0, weight = 0, stats = 'VIT+1' },
        [121] = { points = 5, cat = 21, weight = 4, stats = 'HP-5 MP+5' },
        [122] = { points = 5, cat = 14, weight = 2, stats = 'CHR+1 HP+15' },
        [124] = { points = 4, cat = 4, weight = 4, stats = 'VIT+1' },
        [125] = { points = 5, cat = 17, weight = 4, stats = 'STR+3' },
        [126] = { points = 3, cat = 9, weight = 4, stats = 'CHR+2 HP+5' },
        [128] = { points = 4, cat = 20, weight = 4, stats = 'MND+2' },
        [129] = { points = 5, cat = 18, weight = 4, stats = 'DEX+2 AGI+1' },
        [130] = { points = 3, cat = 0, weight = 0, stats = 'HP-5 MP+5' },
        [131] = { points = 3, cat = 0, weight = 0, stats = 'STR+1 DEX+1' },
        [132] = { points = 4, cat = 4, weight = 4, stats = 'MP+5 MND+1' },
        [133] = { points = 4, cat = 5, weight = 4, stats = 'HP+5 MP+5 CHR+1' },
        [134] = { points = 4, cat = 6, weight = 4, stats = 'MP-5 MND+2' },
        [135] = { points = 2, cat = 17, weight = 4, stats = 'AGI+2' },
        [136] = { points = 1, cat = 19, weight = 4, stats = 'MP+3 INT+1 MND+1' },
        [138] = { points = 2, cat = 1, weight = 4, stats = 'VIT+1' },
        [139] = { points = 4, cat = 4, weight = 4, stats = 'HP-10 MP+10' },
        [140] = { points = 3, cat = 12, weight = 4, stats = 'HP+5 STR+1' },
        [141] = { points = 2, cat = 21, weight = 4, stats = 'AGI+3' },
        [142] = { points = 4, cat = 22, weight = 4, stats = 'HP+10 VIT+3' },
        [143] = { points = 3, cat = 0, weight = 0, stats = 'STR+3' },
        [144] = { points = 3, cat = 24, weight = 4, stats = 'DEX+2 MND+2' },
        [145] = { points = 3, cat = 25, weight = 4, stats = 'VIT+2 AGI+1' },
        [146] = { points = 4, cat = 0, weight = 0, stats = 'MP+5 STR+2' },
        [147] = { points = 4, cat = 24, weight = 4, stats = 'STR-2 VIT+3' },
        [148] = { points = 3, cat = 27, weight = 6, stats = 'DEX+1 AGI+2' },
        [149] = { points = 5, cat = 25, weight = 4, stats = 'HP+20' },
        [150] = { points = 3, cat = 0, weight = 0, stats = 'MP+10 MND+1' },
        [151] = { points = 4, cat = 27, weight = 6, stats = 'MP+3 MND+1 CHR+1' },
        [152] = { points = 2, cat = 0, weight = 0, stats = 'MND+2' },
        [153] = { points = 1, cat = 26, weight = 4, stats = 'HP-20 AGI+5' },
        [154] = { points = 3, cat = 23, weight = 6, stats = 'HP+10 DEX+2 MND-3' },
        [155] = { points = 2, cat = 16, weight = 4, stats = 'AGI+3 CHR-2' },
        [156] = { points = 3, cat = 10, weight = 4, stats = 'MP+7 INT+2' },
        [157] = { points = 2, cat = 26, weight = 4, stats = 'STR+2 DEX+2' },
        [158] = { points = 4, cat = 23, weight = 6, stats = 'STR+2 VIT+2 DEX-1 AGI-1' },
        [159] = { points = 4, cat = 22, weight = 4, stats = 'INT+3 CHR-2' },
        [160] = { points = 5, cat = 13, weight = 4, stats = 'MND+3 CHR-2' },
        [161] = { points = 4, cat = 25, weight = 4, stats = 'DEX+3 CHR-2' },
        [162] = { points = 1, cat = 20, weight = 4, stats = 'HP-10 DEX+2 AGI+2' },
        [163] = { points = 3, cat = 8, weight = 4, stats = 'VIT+2' },
        [165] = { points = 3, cat = 24, weight = 4, stats = 'STR+3 CHR-2' },
        [166] = { points = 3, cat = 6, weight = 4, stats = 'HP+5 MP+5 CHR+2' },
        [167] = { points = 3, cat = 18, weight = 4, stats = 'VIT+3 CHR-2' },
        [168] = { points = 4, cat = 28, weight = 6, stats = 'HP-10 DEX+2 INT+2' },
        [169] = { points = 5, cat = 14, weight = 4, stats = 'MND+3 CHR-2' },
        [170] = { points = 2, cat = 25, weight = 4, stats = 'HP+15 MP-5 INT-1' },
        [171] = { points = 4, cat = 28, weight = 6, stats = 'INT+2 MND+2 STR-1 VIT-1' },
        [172] = { points = 4, cat = 27, weight = 6, stats = 'STR+2 AGI+2' },
        [173] = { points = 3, cat = 15, weight = 4, stats = 'HP+15 MP-15 VIT+3' },
        [174] = { points = 4, cat = 25, weight = 4, stats = 'STR+2 MND+2' },
        [175] = { points = 2, cat = 17, weight = 4, stats = 'MP+20 INT+4 MND+2 STR-3 VIT-3' },
        [176] = { points = 2, cat = 24, weight = 4, stats = 'STR+2' },
        [177] = { points = 3, cat = 21, weight = 4, stats = 'AGI+2 MND+2' },
        [178] = { points = 5, cat = 2, weight = 4, stats = 'HP+5 AGI+1' },
        [180] = { points = 4, cat = 20, weight = 4, stats = 'HP-5 MP-5 DEX+1 AGI+1' },
        [181] = { points = 5, cat = 23, weight = 6, stats = 'STR+3 CHR+3' },
        [182] = { points = 3, cat = 10, weight = 4, stats = 'HP+15 VIT+4' },
        [183] = { points = 4, cat = 15, weight = 4, stats = 'STR+2 DEX+2' },
        [184] = { points = 5, cat = 21, weight = 4, stats = 'HP+10 STR+3 VIT+3 DEX-2 AGI-2' },
        [185] = { points = 4, cat = 28, weight = 6, stats = 'INT+5 MND+2' },
        [186] = { points = 2, cat = 22, weight = 4, stats = 'STR+2 AGI+2' },
        [187] = { points = 2, cat = 25, weight = 4, stats = 'STR-3 DEX+4' },
        [188] = { points = 6, cat = 16, weight = 8, stats = 'DEX+6' },
        [189] = { points = 6, cat = 18, weight = 8, stats = 'AGI+6' },
        [190] = { points = 6, cat = 13, weight = 8, stats = 'VIT+6' },
        [191] = { points = 6, cat = 8, weight = 8, stats = 'STR+6' },
        [192] = { points = 6, cat = 23, weight = 8, stats = 'HP-10 STR+4 DEX+4' },
        [193] = { points = 4, cat = 102, weight = 8, stats = 'HP+10 VIT+4' },
        [194] = { points = 2, cat = 15, weight = 4, stats = 'HP+15 STR+3 DEX+3 INT-3' },
        [195] = { points = 5, cat = 17, weight = 8, stats = 'MP+15 INT+3' },
        [196] = { points = 6, cat = 6, weight = 8, stats = 'MP+25 VIT+6 INT+6' },
        [197] = { points = 7, cat = 24, weight = 8, stats = 'HP+20 DEX+8' },
        [198] = { points = 4, cat = 22, weight = 8, stats = 'HP+15 MP+15 AGI+5 CHR+5' },
        [199] = { points = 0, cat = 15, weight = 8, stats = 'HP+15 MP+15' },
        [200] = { points = 0, cat = 27, weight = 8, stats = 'INT+6 MND+6' },
        [201] = { points = 0, cat = 20, weight = 8, stats = 'STR+5 VIT+7' },
        [202] = { points = 0, cat = 103, weight = 8, stats = 'STR+4 DEX+4 VIT+4' },
        [203] = { points = 0, cat = 25, weight = 8, stats = 'AGI+8' },
        [204] = { points = 0, cat = 1, weight = 8 },
        [205] = { points = 0, cat = 3, weight = 8, stats = 'HP+25 VIT+5' },
        [206] = { points = 0, cat = 11, weight = 8, stats = 'VIT+8' },
        [207] = { points = 8, cat = 8, weight = 8, stats = 'MP+30 STR+8' },
        [208] = { points = 8, cat = 6, weight = 8, stats = 'MP+30 INT+8' },
        [209] = { points = 8, cat = 16, weight = 8, stats = 'MP+30 DEX+8' },
        [210] = { points = 8, cat = 11, weight = 8, stats = 'MP+30 VIT+8' },
        [211] = { points = 0, cat = 104, weight = 8, stats = 'HP+50 VIT+6 INT-3' },
        [212] = { points = 0, cat = 105, weight = 8, stats = 'DEX+6 AGI+6' },
        [213] = { points = 8, cat = 106, weight = 8, stats = 'HP+40 STR+4 AGI+4' },
        [214] = { points = 8, cat = 13, weight = 8, stats = 'MP+30 MND+8' },
        [215] = { points = 8, cat = 18, weight = 8, stats = 'MP+30 AGI+8' },
        [216] = { points = 8, cat = 107, weight = 8, stats = 'MP+30 VIT+4 INT+4 MND+4' },
        [224] = { points = 0, cat = 0, weight = 0 },
        [225] = { points = 0, cat = 0, weight = 0 },
        [226] = { points = 0, cat = 0, weight = 0 },
        [227] = { points = 0, cat = 0, weight = 0 },
        [228] = { points = 0, cat = 0, weight = 0 },
        [229] = { points = 0, cat = 0, weight = 0 },
        [230] = { points = 0, cat = 0, weight = 0 },
        [231] = { points = 0, cat = 0, weight = 0 },
        [232] = { points = 0, cat = 0, weight = 0 },
        [233] = { points = 0, cat = 0, weight = 0 },
        [234] = { points = 0, cat = 0, weight = 0 },
    },

    -- Job traits by trait id: the name, then per job a list of { level, rank, effect }.
    job_traits = {
        [1] = { name = 'Accuracy Bonus', jobs = {
            [11] = { { 10, 1, 'Accuracy +10, Ranged Accuracy +10' }, { 30, 2, 'Accuracy +22, Ranged Accuracy +22' }, { 50, 3, 'Accuracy +35, Ranged Accuracy +35' }, { 70, 4, 'Accuracy +48, Ranged Accuracy +48' } },
            [14] = { { 30, 1, 'Accuracy +10, Ranged Accuracy +10' }, { 60, 2, 'Accuracy +22, Ranged Accuracy +22' } },
            [19] = { { 30, 1, 'Accuracy +10, Ranged Accuracy +10' }, { 60, 2, 'Accuracy +22, Ranged Accuracy +22' } },
            [22] = { { 50, 1, 'Accuracy +10, Ranged Accuracy +10' }, { 70, 2, 'Accuracy +22, Ranged Accuracy +22' } },
        } },
        [2] = { name = 'Evasion Bonus', jobs = {
            [6] = { { 10, 1, 'Evasion +10' }, { 30, 2, 'Evasion +22' }, { 50, 3, 'Evasion +35' }, { 70, 4, 'Evasion +48' } },
            [18] = { { 20, 1, 'Evasion +10' }, { 40, 2, 'Evasion +22' }, { 60, 3, 'Evasion +35' } },
            [19] = { { 15, 1, 'Evasion +10' }, { 45, 2, 'Evasion +22' }, { 75, 3, 'Evasion +35' } },
        } },
        [3] = { name = 'Attack Bonus', jobs = {
            [1] = { { 30, 1, 'Attack +10, Ranged Attack +10' }, { 65, 2, 'Attack +22, Ranged Attack +22' } },
            [8] = { { 10, 1, 'Attack +10, Ranged Attack +10' }, { 30, 2, 'Attack +22, Ranged Attack +22' }, { 50, 3, 'Attack +35, Ranged Attack +35' }, { 70, 4, 'Attack +48, Ranged Attack +48' } },
            [14] = { { 10, 1, 'Attack +10, Ranged Attack +10' } },
        } },
        [4] = { name = 'Defense Bonus', jobs = {
            [1] = { { 10, 1, 'Defense +10' }, { 45, 2, 'Defense +22' } },
            [7] = { { 10, 1, 'Defense +10' }, { 30, 2, 'Defense +22' }, { 50, 3, 'Defense +35' }, { 70, 4, 'Defense +48' } },
        } },
        [5] = { name = 'Magic Attack Bonus', jobs = {
            [4] = { { 10, 1, 'Magic Attack +20' }, { 30, 2, 'Magic Attack +24' }, { 50, 3, 'Magic Attack +28' }, { 70, 4, 'Magic Attack +32' } },
            [5] = { { 20, 1, 'Magic Attack +20' }, { 40, 2, 'Magic Attack +24' } },
        } },
        [6] = { name = 'Magic Defense Bonus', jobs = {
            [3] = { { 10, 1, 'Magic Defense +10' }, { 30, 2, 'Magic Defense +12' }, { 50, 3, 'Magic Defense +14' }, { 70, 4, 'Magic Defense +16' } },
            [5] = { { 25, 1, 'Magic Defense +10' }, { 45, 2, 'Magic Defense +12' } },
            [22] = { { 10, 1, 'Magic Defense +10' }, { 30, 2, 'Magic Defense +12' }, { 50, 3, 'Magic Defense +14' }, { 70, 4, 'Magic Defense +16' } },
        } },
        [7] = { name = 'Max HP Boost', jobs = {
            [1] = { { 30, 1, 'Max HP +30' }, { 50, 2, 'Max HP +60' }, { 70, 3, 'Max HP +120' } },
            [2] = { { 15, 1, 'Max HP +30' }, { 25, 2, 'Max HP +60' }, { 35, 3, 'Max HP +120' }, { 45, 4, 'Max HP +180' }, { 55, 5, 'Max HP +240' }, { 65, 6, 'Max HP +280' } },
            [7] = { { 45, 1, 'Max HP +30' } },
            [13] = { { 20, 1, 'Max HP +30' }, { 40, 2, 'Max HP +60' }, { 60, 3, 'Max HP +120' } },
            [22] = { { 20, 1, 'Max HP +30' }, { 40, 2, 'Max HP +60' }, { 60, 3, 'Max HP +120' } },
        } },
        [8] = { name = 'Max MP Boost', jobs = {
            [15] = { { 10, 1, 'Max MP +10' }, { 30, 2, 'Max MP +20' }, { 50, 3, 'Max MP +40' }, { 70, 4, 'Max MP +60' } },
            [20] = { { 30, 1, 'Max MP +10' } },
            [21] = { { 30, 1, 'Max MP +10' }, { 60, 2, 'Max MP +20' } },
        } },
        [9] = { name = 'Auto Regen', jobs = {
            [3] = { { 25, 1, 'Regen +1 HP/tick' } },
            [22] = { { 35, 1, 'Regen +1 HP/tick' }, { 65, 2, 'Regen +2 HP/tick' } },
        } },
        [10] = { name = 'Auto Refresh', jobs = {
            [7] = { { 35, 1, 'Refresh +1 MP/tick' } },
            [15] = { { 25, 1, 'Refresh +1 MP/tick' } },
        } },
        [11] = { name = 'Rapid Shot', jobs = {
            [11] = { { 15, 1, 'Rapid Shot +25%' }, { 71, 2, 'Rapid Shot +30%' } },
            [17] = { { 15, 1, 'Rapid Shot +25%' } },
        } },
        [12] = { name = 'Fast Cast', jobs = {
            [5] = { { 15, 1, 'Fast Cast +10%' }, { 35, 2, 'Fast Cast +15%' }, { 55, 3, 'Fast Cast +20%' } },
        } },
        [13] = { name = 'Conserve MP', jobs = {
            [4] = { { 20, 1, 'Conserve MP +25' } },
            [20] = { { 25, 1, 'Conserve MP +25' } },
            [21] = { { 10, 1, 'Conserve MP +25' }, { 25, 2, 'Conserve MP +28' }, { 40, 3, 'Conserve MP +31' }, { 55, 4, 'Conserve MP +34' }, { 70, 5, 'Conserve MP +37' } },
        } },
        [14] = { name = 'Store TP', jobs = {
            [12] = { { 10, 1, 'Store TP +10' }, { 30, 2, 'Store TP +15' }, { 50, 3, 'Store TP +20' }, { 70, 4, 'Store TP +25' } },
        } },
        [15] = { name = 'Double Attack', jobs = {
            [1] = { { 25, 1, 'Double Attack +10%' }, { 50, 2, 'Double Attack +12%' }, { 75, 3, 'Double Attack +14%' } },
        } },
        [16] = { name = 'Triple Attack', jobs = {
            [6] = { { 55, 1, 'Triple Attack +5%' } },
        } },
        [17] = { name = 'Counter', jobs = {
            [2] = { { 10, 1, 'Counter +10%' } },
        } },
        [18] = { name = 'Dual Wield', jobs = {
            [13] = { { 10, 1, 'Dual Wield +10%' }, { 25, 2, 'Dual Wield +15%' }, { 45, 3, 'Dual Wield +25%' }, { 65, 4, 'Dual Wield +30%' } },
            [19] = { { 20, 1, 'Dual Wield +10%' }, { 40, 2, 'Dual Wield +15%' }, { 60, 3, 'Dual Wield +25%' } },
        } },
        [19] = { name = 'Treasure Hunter', jobs = {
            [6] = { { 15, 1, 'Treasure Hunter +1' } },
        } },
        [20] = { name = 'Gilfinder', jobs = {
            [6] = { { 5, 1, 'Gilfinder +1' } },
        } },
        [21] = { name = 'Alertness', jobs = {
            [11] = { { 5, 1, '' } },
        } },
        [22] = { name = 'Stealth', jobs = {
            [13] = { { 5, 1, '' } },
        } },
        [23] = { name = 'Martial Arts', jobs = {
            [2] = { { 1, 1, '' }, { 16, 2, '' }, { 31, 3, '' }, { 46, 4, '' }, { 61, 5, '' }, { 75, 6, '' } },
            [18] = { { 25, 1, '' }, { 50, 2, '' }, { 75, 3, '' } },
        } },
        [24] = { name = 'Clear Mind', jobs = {
            [3] = { { 20, 1, 'MP While Healing +3' }, { 35, 2, 'MP While Healing +6' }, { 50, 3, 'MP While Healing +9, MP While Healing +1' }, { 65, 4, 'MP While Healing +12' } },
            [4] = { { 15, 1, 'MP While Healing +3' }, { 30, 2, 'MP While Healing +6' }, { 45, 3, 'MP While Healing +9, MP While Healing +1' }, { 60, 4, 'MP While Healing +12' }, { 75, 5, 'MP While Healing +15, MP While Healing +2' } },
            [5] = { { 31, 1, 'MP While Healing +3' }, { 53, 2, 'MP While Healing +6' }, { 75, 3, 'MP While Healing +9, MP While Healing +1' } },
            [15] = { { 15, 1, 'MP While Healing +3' }, { 30, 2, 'MP While Healing +6' }, { 45, 3, 'MP While Healing +9, MP While Healing +1' }, { 60, 4, 'MP While Healing +12' }, { 70, 5, 'MP While Healing +15, MP While Healing +2' } },
            [20] = { { 20, 1, 'MP While Healing +3' }, { 35, 2, 'MP While Healing +6' }, { 50, 3, 'MP While Healing +9, MP While Healing +1' }, { 65, 4, 'MP While Healing +12' } },
            [21] = { { 20, 1, 'MP While Healing +3' }, { 40, 2, 'MP While Healing +6' }, { 60, 3, 'MP While Healing +9, MP While Healing +1' } },
        } },
        [25] = { name = 'Shield Mastery', jobs = {
            [7] = { { 25, 1, '' }, { 50, 2, '' }, { 75, 3, '' } },
        } },
        [32] = { name = 'Beast Killer', jobs = {
            [9] = { { 70, 1, 'Beast Killer +8' } },
        } },
        [33] = { name = 'Plantoid Killer', jobs = {
            [9] = { { 60, 1, 'Plantoid Killer +8' } },
        } },
        [34] = { name = 'Vermin Killer', jobs = {
            [9] = { { 10, 1, '' } },
        } },
        [35] = { name = 'Lizard Killer', jobs = {
            [9] = { { 40, 1, 'Lizard Killer +8' } },
        } },
        [36] = { name = 'Bird Killer', jobs = {
            [9] = { { 20, 1, '' } },
        } },
        [37] = { name = 'Amorph Killer', jobs = {
            [9] = { { 30, 1, '' } },
        } },
        [38] = { name = 'Aquan Killer', jobs = {
            [9] = { { 50, 1, '' } },
        } },
        [39] = { name = 'Undead Killer', jobs = {
            [7] = { { 5, 1, 'Undead Killer +8' } },
        } },
        [41] = { name = 'Arcana Killer', jobs = {
            [8] = { { 25, 1, '' } },
        } },
        [42] = { name = 'Demon Killer', jobs = {
            [12] = { { 40, 1, '' } },
        } },
        [43] = { name = 'Dragon Killer', jobs = {
            [14] = { { 25, 1, '' } },
        } },
        [48] = { name = 'Resist Sleep', jobs = {
            [7] = { { 20, 1, 'Resist Sleep +10' }, { 40, 2, 'Resist Sleep +15' }, { 60, 3, 'Resist Sleep +20' }, { 75, 4, 'Resist Sleep +25' } },
        } },
        [49] = { name = 'Resist Poison', jobs = {
            [11] = { { 20, 1, '' }, { 40, 2, '' }, { 60, 3, '' } },
        } },
        [50] = { name = 'Resist Paralyze', jobs = {
            [8] = { { 20, 1, '' }, { 40, 2, '' }, { 60, 3, '' }, { 75, 4, '' } },
            [17] = { { 5, 1, '' }, { 25, 2, '' }, { 45, 3, '' }, { 65, 4, '' } },
        } },
        [51] = { name = 'Resist Blind', jobs = {
            [12] = { { 5, 1, '' }, { 25, 2, '' }, { 45, 3, '' }, { 65, 4, '' } },
        } },
        [52] = { name = 'Resist Silence', jobs = {
            [10] = { { 5, 1, '' }, { 25, 2, '' }, { 45, 3, '' }, { 65, 4, '' } },
            [20] = { { 10, 1, '' }, { 40, 2, '' }, { 70, 3, '' } },
        } },
        [53] = { name = 'Resist Petrify', jobs = {
            [5] = { { 10, 1, '' }, { 30, 2, '' }, { 50, 3, '' }, { 70, 4, '' } },
        } },
        [54] = { name = 'Resist Virus', jobs = {
            [1] = { { 5, 1, 'Resist Virus +10' }, { 35, 2, 'Resist Virus +15' }, { 55, 3, 'Resist Virus +20' }, { 70, 4, 'Resist Virus +25' } },
        } },
        [57] = { name = 'Resist Bind', jobs = {
            [13] = { { 10, 1, '' }, { 30, 2, '' }, { 50, 3, '' }, { 70, 4, '' } },
        } },
        [58] = { name = 'Resist Gravity', jobs = {
            [6] = { { 20, 1, 'Resist Gravity +10' }, { 40, 2, 'Resist Gravity +15' }, { 66, 3, 'Resist Gravity +20' }, { 75, 4, 'Resist Gravity +25' } },
        } },
        [59] = { name = 'Resist Slow', jobs = {
            [9] = { { 15, 1, '' }, { 35, 2, '' }, { 55, 3, '' }, { 75, 4, '' } },
            [15] = { { 20, 1, '' }, { 40, 2, '' }, { 60, 3, '' } },
            [18] = { { 10, 1, '' }, { 50, 2, '' }, { 70, 3, '' } },
            [19] = { { 20, 1, '' }, { 55, 2, '' } },
        } },
        [63] = { name = 'Resist Amnesia', jobs = {
            [9] = { { 15, 1, '' }, { 35, 2, '' }, { 55, 3, '' }, { 75, 4, '' } },
            [17] = { { 30, 1, '' }, { 50, 2, '' }, { 70, 3, '' } },
            [18] = { { 15, 1, '' }, { 35, 2, '' }, { 55, 3, '' }, { 75, 4, '' } },
        } },
        [64] = { name = 'Treasure Hunter II', jobs = {
            [6] = { { 45, 2, 'Treasure Hunter +1' } },
        } },
        [66] = { name = 'Kick Attacks', jobs = {
            [2] = { { 51, 1, '' }, { 71, 2, '' } },
        } },
        [67] = { name = 'Subtle Blow', jobs = {
            [2] = { { 5, 1, '' }, { 25, 2, '' }, { 40, 3, '' }, { 65, 4, '' } },
            [13] = { { 15, 1, '' }, { 30, 2, '' }, { 45, 3, '' }, { 60, 4, '' }, { 75, 5, '' } },
            [19] = { { 25, 1, '' }, { 45, 2, '' }, { 65, 3, '' } },
        } },
        [68] = { name = 'Assassin', jobs = {
            [6] = { { 60, 1, '' } },
        } },
        [69] = { name = 'Divine Veil', jobs = {
            [3] = { { 50, 1, '' } },
        } },
        [70] = { name = 'Zanshin', jobs = {
            [12] = { { 20, 1, 'Zanshin +15%' }, { 35, 2, 'Zanshin +25%' }, { 50, 3, 'Zanshin +35%' }, { 75, 4, 'Zanshin +45%' } },
        } },
        [71] = { name = 'Savagery', jobs = {
            [1] = { { 75, 1, '' } },
        } },
        [72] = { name = 'Aggressive Aim', jobs = {
            [1] = { { 75, 1, '' } },
        } },
        [73] = { name = 'Invigorate', jobs = {
            [2] = { { 75, 1, '' } },
        } },
        [74] = { name = 'Penance', jobs = {
            [2] = { { 75, 1, '' } },
        } },
        [75] = { name = 'Aura Steal', jobs = {
            [6] = { { 75, 1, '' } },
        } },
        [76] = { name = 'Ambush', jobs = {
            [6] = { { 75, 1, '' } },
        } },
        [77] = { name = 'Iron Will', jobs = {
            [7] = { { 75, 1, '' } },
        } },
        [78] = { name = 'Guardian', jobs = {
            [7] = { { 75, 1, '' } },
        } },
        [79] = { name = 'Muted Soul', jobs = {
            [8] = { { 75, 1, '' } },
        } },
        [80] = { name = 'Desperate Blows', jobs = {
            [8] = { { 15, 1, '' }, { 30, 2, '' }, { 45, 3, '' } },
        } },
        [81] = { name = 'Beast Affinity', jobs = {
            [9] = { { 75, 1, '' } },
        } },
        [82] = { name = 'Beast Healer', jobs = {
            [9] = { { 75, 1, '' } },
        } },
        [83] = { name = 'Snapshot', jobs = {
            [11] = { { 75, 1, '' } },
        } },
        [84] = { name = 'Recycle', jobs = {
            [11] = { { 20, 1, '' }, { 35, 2, '' }, { 50, 3, '' } },
            [17] = { { 35, 1, '' }, { 65, 2, '' } },
        } },
        [85] = { name = 'Ikishoten', jobs = {
            [12] = { { 75, 1, '' } },
        } },
        [86] = { name = 'Overwhelm', jobs = {
            [12] = { { 75, 1, '' } },
        } },
        [87] = { name = 'Ninja Tool Expert.', jobs = {
            [13] = { { 75, 1, '' } },
        } },
        [88] = { name = 'Empathy', jobs = {
            [14] = { { 75, 1, '' } },
        } },
        [89] = { name = 'Strafe', jobs = {
            [14] = { { 20, 1, '' }, { 40, 2, '' }, { 60, 3, '' } },
        } },
        [90] = { name = 'Enchainment', jobs = {
            [16] = { { 75, 1, '' } },
        } },
        [91] = { name = 'Assimilation', jobs = {
            [16] = { { 75, 1, '' } },
        } },
        [92] = { name = 'Winning Streak', jobs = {
            [17] = { { 75, 1, '' } },
        } },
        [93] = { name = 'Loaded Deck', jobs = {
            [17] = { { 75, 1, '' } },
        } },
        [94] = { name = 'Fine-Tuning', jobs = {
            [18] = { { 75, 1, '' } },
        } },
        [95] = { name = 'Optimization', jobs = {
            [18] = { { 75, 1, '' } },
        } },
        [96] = { name = 'Closed Position', jobs = {
            [19] = { { 75, 1, '' } },
        } },
        [97] = { name = 'Stormsurge', jobs = {
            [20] = { { 75, 1, '' } },
        } },
        [100] = { name = 'Tactical Parry', jobs = {
            [22] = { { 40, 1, '' }, { 60, 2, '' } },
        } },
        [105] = { name = 'Blood Boon', jobs = {
            [15] = { { 60, 1, '' }, { 70, 2, '' } },
        } },
        [106] = { name = 'Skillchain Bonus', jobs = {
            [19] = { { 45, 1, 'Skillchain Damage +8%' }, { 58, 2, 'Skillchain Damage +12%' }, { 71, 3, 'Skillchain Damage +16%' } },
        } },
        [107] = { name = 'Fencer', jobs = {
            [1] = { { 45, 1, '' }, { 58, 2, '' }, { 71, 3, '' } },
        } },
        [108] = { name = 'Conserve Tp', jobs = {
            [14] = { { 45, 1, '' }, { 58, 2, '' }, { 71, 3, '' } },
        } },
        [109] = { name = 'Occult Acumen', jobs = {
            [8] = { { 45, 1, '' }, { 58, 2, '' }, { 71, 3, '' } },
        } },
        [110] = { name = 'Magic Burst Bonus', jobs = {
            [4] = { { 45, 1, 'Magic Burst Damage +5%' }, { 58, 2, 'Magic Burst Damage +7%' }, { 71, 3, 'Magic Burst Damage +9%' } },
        } },
        [111] = { name = 'Divine Benison', jobs = {
            [3] = { { 50, 1, '' }, { 60, 2, '' }, { 70, 3, '' } },
        } },
        [112] = { name = 'Elemental Celerity', jobs = {
            [4] = { { 50, 1, '' }, { 60, 2, '' }, { 70, 3, '' } },
            [21] = { { 55, 1, '' }, { 75, 2, '' } },
        } },
        [113] = { name = 'Dead Aim', jobs = {
            [11] = { { 50, 1, '' }, { 60, 2, '' }, { 70, 3, '' } },
        } },
        [114] = { name = 'Tranquil Heart', jobs = {
            [3] = { { 21, 1, '' } },
            [5] = { { 26, 1, '' } },
            [20] = { { 30, 1, '' } },
        } },
        [115] = { name = 'Stalwart Soul', jobs = {
            [8] = { { 45, 1, '' }, { 60, 2, '' }, { 75, 3, '' } },
        } },
        [116] = { name = 'Cardinal Chant', jobs = {
            [21] = { { 25, 1, '' }, { 45, 2, '' }, { 65, 3, '' } },
        } },
        [117] = { name = 'Tenacity', jobs = {
            [22] = { { 5, 1, 'Resist Sleep +5, Resist Virus +5' }, { 25, 2, 'Resist Sleep +7, Resist Virus +7' }, { 45, 3, 'Resist Sleep +9, Resist Virus +9' }, { 75, 4, 'Resist Sleep +11, Resist Virus +11' } },
        } },
        [118] = { name = 'Inquartata', jobs = {
            [22] = { { 15, 1, '' }, { 45, 2, '' }, { 75, 3, '' } },
        } },
        [119] = { name = 'Curative Recantation', jobs = {
            [21] = { { 75, 1, '' } },
        } },
        [120] = { name = 'Primeval Zeal', jobs = {
            [21] = { { 75, 1, '' } },
        } },
        [123] = { name = 'Daken', jobs = {
            [13] = { { 25, 1, '' }, { 40, 2, '' }, { 55, 3, '' }, { 70, 4, '' } },
        } },
        [127] = { name = 'Smite', jobs = {
            [1] = { { 35, 1, 'Smite +25' }, { 65, 2, 'Smite +38' } },
            [2] = { { 40, 1, 'Smite +25' } },
            [8] = { { 15, 1, 'Smite +25' }, { 35, 2, 'Smite +38' }, { 55, 3, 'Smite +51' }, { 75, 4, 'Smite +64' } },
            [14] = { { 40, 1, 'Smite +25' } },
            [18] = { { 60, 1, 'Smite +25' } },
        } },
        [129] = { name = 'Damage Limit+', jobs = {
            [1] = { { 40, 1, 'Damage Limit +10%' } },
            [2] = { { 30, 1, 'Damage Limit +10%' }, { 60, 2, 'Damage Limit +20%' } },
            [5] = { { 60, 1, 'Damage Limit +10%' } },
            [6] = { { 50, 1, 'Damage Limit +10%' } },
            [8] = { { 20, 1, 'Damage Limit +10%' }, { 40, 2, 'Damage Limit +20%' }, { 55, 3, 'Damage Limit +30%' }, { 70, 4, 'Damage Limit +40%' } },
            [9] = { { 45, 1, 'Damage Limit +10%' } },
            [11] = { { 30, 1, 'Damage Limit +10%' }, { 60, 2, 'Damage Limit +20%' } },
            [12] = { { 40, 1, 'Damage Limit +10%' } },
            [13] = { { 50, 1, 'Damage Limit +10%' } },
            [14] = { { 30, 1, 'Damage Limit +10%' }, { 60, 2, 'Damage Limit +20%' } },
            [18] = { { 45, 1, 'Damage Limit +10%' } },
            [19] = { { 45, 1, 'Damage Limit +10%' } },
        } },
        [134] = { name = 'Ws Damage Boost', jobs = {
            [14] = { { 45, 1, '' }, { 55, 2, '' }, { 65, 3, '' }, { 75, 4, '' } },
        } },
        [135] = { name = 'Max Hp Boost II', jobs = {
            [2] = { { 75, 1, 'Max HP +150' } },
        } },
        [136] = { name = 'Shield Barrier', jobs = {
            [7] = { { 70, 1, '' } },
        } },
        [137] = { name = 'Tandem Strike', jobs = {
            [9] = { { 30, 1, '' }, { 45, 2, '' }, { 60, 3, '' }, { 75, 4, '' } },
        } },
        [138] = { name = 'Tandem Blow', jobs = {
            [9] = { { 40, 1, '' }, { 60, 2, '' } },
        } },
    },
};
