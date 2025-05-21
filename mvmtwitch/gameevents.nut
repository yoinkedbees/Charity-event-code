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

yoinkedbees_mvm.OnGameEvent_player_team <- function (params) {
    local player = GetPlayerFromUserID(params.userid)
    if (!IsPlayerABot(player))
        player.ValidateScriptScope()
}
yoinkedbees_mvm.OnGameEvent_player_death <- function (params) {
    local player = GetPlayerFromUserID(params.userid)
    if (!IsPlayerABot(player))
        RTD_PlayerDeath(player)
}

yoinkedbees_mvm.OnGameEvent_post_inventory_application <- function (params) {
    local player = GetPlayerFromUserID(params.userid)
    if (!IsPlayerABot(player))
        RTD_Reapply(player)
}

yoinkedbees_mvm.ClearGameEventCallbacks <- ::ClearGameEventCallbacks
::ClearGameEventCallbacks <- function ()
{
    yoinkedbees_mvm.ClearGameEventCallbacks()
    ::__CollectGameEventCallbacks(yoinkedbees_mvm)
}
::__CollectGameEventCallbacks(yoinkedbees_mvm);