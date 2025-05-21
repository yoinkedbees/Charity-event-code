::LuckySandvich <- function (player) {
    player.AddCustomAttribute("max health additive bonus", 1000, 20)
    player.SetHealth(player.GetMaxHealth())
}

::RTD_TABLE <- {
    "Lucky Sandvich" : {
        description = "Description",
        conds = false,
        func = LuckySandvich
    },
    "Powerplay" : {
        description = "Description",
        conds = [57, 56],
        condLength = 30,
        func = false
    }
}
function ApplyRTD(player) {
    local key = RandomKeyFromTable(RTD_TABLE)
    if (RTD_TABLE[key].func)
    {
        RTD_TABLE[key].func(player)
    }
    if (RTD_TABLE[key].conds)
    {
        foreach (cond in RTD_TABLE[key].conds) {
            player.AddCondEx(cond, RTD_TABLE[key].condLength, player)
        }
    }
    ClientPrint(player, 3, "\x07ffffff[\x07ff00ffTwitch RTD\x07ffffff] You got " + key + " " + RTD_TABLE[key].description)
    player.ValidateScriptScope()
    player.GetScriptScope().activeRTD <- key
}

function RTD_PlayerDeath(player) {
    player.GetScriptScope().activeRTD <- false
}

function RTD_Reapply(player) {
    if (player.GetScriptScope().activeRTD)
    {
        ApplyRTD(player)
    }
}