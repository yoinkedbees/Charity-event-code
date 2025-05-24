local root = getroottable();
local prefix = DoUniqueString("yoinkedbees_mvm");
local yoinkedbees_mvm = root[prefix] <- {};

yoinkedbees_mvm.OnScriptHook_OnTakeDamage <- function (params) {
    local attacker = params.attacker
    if (attacker.GetClassname() == "headless_hatman")
    {
        for (local player = null; player = Entities.FindByClassnameWithin(player, "player", attacker.GetOrigin(), 200);)
        {
            if (player == null || !player.IsAlive() || player == params.const_entity){
                printl("skipping damage")
                continue
            }
            // player.TakeDamage(100, 128, null)
            player.TakeDamageEx(WORLDSPAWN, WORLDSPAWN, null, Vector(0, 0, 0), attacker.GetOrigin() , 150 , 128)
            printl(player + "took damage")
        }
    }
}

// yoinkedbees_mvm.OnGameEvent_player_team <- function (params) {
//     local player = GetPlayerFromUserID(params.userid)
//     if (!IsPlayerABot(player))
//         player.ValidateScriptScope()
// }
// yoinkedbees_mvm.OnGameEvent_player_death <- function (params) {
//     local player = GetPlayerFromUserID(params.userid)
//     if (!IsPlayerABot(player))
//         RTD_PlayerDeath(player)
// }

yoinkedbees_mvm.OnGameEvent_post_inventory_application <- function (params) {
	local player = GetPlayerFromUserID(params.userid)

    local BOT_MODELS = [
        "models/error.mdl",
        "models/bots/scout/bot_scout.mdl",
        "models/bots/sniper/bot_sniper.mdl",
        "models/bots/soldier/bot_soldier.mdl",
        "models/bots/demo/bot_demo.mdl",
        "models/bots/medic/bot_medic.mdl",
        "models/bots/heavy/bot_heavy.mdl",
        "models/bots/pyro/bot_pyro.mdl",
        "models/bots/spy/bot_spy.mdl",
        "models/bots/engineer/bot_engineer.mdl",
    ];

	if (IsPlayerABot(player)) return;
    // paint all hats pink
    for (local wearable = player.FirstMoveChild(); wearable != null; wearable = wearable.NextMovePeer())
    {
        if (wearable.GetClassname() != "tf_wearable")
            continue
        wearable.AddAttribute("set item tint RGB", 16738740, -1)
    }
    // paint weapons pink (for energy weapons)
    for (local i = 0; i < MAX_WEAPONS; i++)
    {
        local weapon = NetProps.GetPropEntityArray(player, "m_hMyWeapons", i)
        if (weapon == null)
            continue
        weapon.AddAttribute("set item tint RGB", 16738740, -1)
    }
    if (player.GetTeam() == Constants.ETFTeam.TF_TEAM_PVE_INVADERS)
    {
        player.SetCustomModelWithClassAnimations(BOT_MODELS[player.GetPlayerClass()])
        EntFireByHandle(player, "CallScriptFunction", "clearCosmetics", 0, player, player)
    }
    else
    {
        player.SetCustomModel("")
    }
}

yoinkedbees_mvm.ClearGameEventCallbacks <- ::ClearGameEventCallbacks
::ClearGameEventCallbacks <- function ()
{
    yoinkedbees_mvm.ClearGameEventCallbacks()
    ::__CollectGameEventCallbacks(yoinkedbees_mvm)
}
::__CollectGameEventCallbacks(yoinkedbees_mvm);
