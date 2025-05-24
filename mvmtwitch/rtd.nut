::LuckySandvich <- function (player) {
    player.AddCustomAttribute("max health additive bonus", 1000, 20)
    player.SetHealth(player.GetMaxHealth())
}
::Bleed <-function(player){
    player.BleedPlayerEx(20.0, 5, false, 34)
}

::RTD_TABLE <- {
        "Lucky Sandvich" : {
        description = "Yum!",
        conds = false,
        func = LuckySandvich
    },
    "Powerplay" : {
        description = "LETS DO ITTTTTT",
        conds = [57, 56,58,59,60],
        condLength = 20,
        func = false
    },
    "Bad Sauce": {
        description = "Doused in Jarate, Mad Milk and you're also bleeding",
        conds = [27,24,25], // make bleed function
        condLength = 20,
        func = Bleed
        
    },
    "Melee Only":{
        description = "No guns, only fists",
        conds = [41],
        condLength = 30,
        func = false
    },
    "Freeze":{
        description = "Ice Ice Baby",
        conds = [87],
        condLength = 20,
        func = false
    },
    "Hit and a Miss":{
        description = "You have a 75% chance of dodging incoming damage for 20 seconds",
        conds = [79],
        condLength = 20,
        func = false
    },
    "Big Guy!":{
        description ="you are now 6ft",
        conds = [74],
        condLength = 20,
        func = false
    },
    "Small fella!":{
        description ="you are now ant size",
        conds = [75],
        condLength = 20,
        func = false
    },
    "CRITS!":{
        description = "This shit ain't random, Kill them all!",
        conds = [33],
        condLength = 20,
        func = false
    }, 
    "King Engine":{
        description = "power to the king! Health regen, fire rate and reload rate are all buffed!",
        conds = [109,113],
        condLength = 20,
        func = false
    },
    "How are you? I am under the water":{
        description = "Still water?!?! Mango! Mango! Mango! Mango!",
        conds = [86],
        condLength = 20,
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
   local name = NetProps.GetPropString(player, "m_szNetname");
    ClientPrint(null, 3, "\x07ffffff[\x07ff00ffTwitch RTD\x07ffffff]" + name + " got " + key)
    ClientPrint(null,3,RTD_TABLE[key].description)
}

