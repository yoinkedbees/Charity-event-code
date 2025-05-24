::MAX_WEAPONS <- 8
::MAX_PLAYERS <- MaxClients().tointeger()
::TF_GAMERULES <- Entities.FindByClassname(null, "tf_gamerules")
::MONSTER_RESOURCE <- Entities.FindByClassname(null, "monster_resource")
::WORLDSPAWN <- Entities.FindByClassname(null, "worldspawn")

::GLOBALTHINKENT <- Entities.CreateByClassname("info_target");
AddThinkToEnt(GLOBALTHINKENT, "globalThink");

function getRandomPlayer() {
    local players = []
    for (local i = 1; i <= MAX_PLAYERS ; i++)
    {
        local player = PlayerInstanceFromIndex(i)
        if (player == null || player.IsFakeClient() || player.IsBotOfType( 1337 /* Constants.EBotType.TF_BOT_TYPE */)) continue
        players.append(player)
    }
    local randomIndex = RandomInt(0, players.len() - 1)
    return players[randomIndex];
}
function globalThink()
{
    local hhh = Entities.FindByClassname(null, "headless_hatman")
    if (!hhh)
    {
        if (MONSTER_RESOURCE) // Check if the health bar entity exists, just in case to prevent errors
        {
            NetProps.SetPropInt(MONSTER_RESOURCE, "m_iBossHealthPercentageByte", 0)
        }
    }
    return 0.2
}

PrecacheModel("models/weapons/c_models/c_bigaxe/c_bigaxe.mdl")
PrecacheModel("models/weapons/c_models/c_big_mallet/c_big_mallet.mdl")

::clamp <- function(value, min, max)
{
    if (value < min)
        return min;
    if (value > max)
        return max;
    return value;
}

function RandomKeyFromTable(table) {
    // Collect keys into an array
    local keys = [];
    foreach(key, value in table) {
        keys.append(key);
    }

    return keys[RandomInt(0, keys.len()-1)]
}

::clearCosmetics <- function()
{
    for (local wearable = self.FirstMoveChild(); wearable != null; wearable = wearable.NextMovePeer())
    {
        if(wearable.IsValid() != true)
            continue

        local weaponIndex = -1
        weaponIndex = NetProps.GetPropInt(wearable, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")

        if(wearable.GetClassname() != "tf_wearable" && wearable.GetClassname() != "tf_wearable_campaign_item" && wearable.GetClassname() != "tf_powerup_bottle")  // && wearable.GetClassname() != "tf_wearable_demoshield
        {
            continue
        }

        if(wearable != null)
        {
            EntFireByHandle(wearable, "Kill", "", -1, null, null)
        }
    }
}

function ChangePlayerTeamMvM(player, teamnum)
{
	NetProps.SetPropBool(TF_GAMERULES, "m_bPlayingMannVsMachine", false)
	player.ForceChangeTeam(teamnum, false)
	NetProps.SetPropBool(TF_GAMERULES, "m_bPlayingMannVsMachine", true)
}

function SpawnTank(donorname) {
    local tank_name = DoUniqueString("yoinkedbees_tank");
    local tank = SpawnEntityFromTable("tank_boss", {
        targetname = tank_name,
        health = 20000
    })
    EntityOutputs.AddOutput(tank, "OnKilled", "boss_dead_relay", "Trigger", "", 0, -1)
    EntityOutputs.AddOutput(tank, "OnUser1", "!self", "FireUser2", "", 8.0, -1)
    EntityOutputs.AddOutput(tank, "OnUser2", "boss_deploy_relay", "Trigger", "", 0.0, -1)

    Entities.FindByName(null, "boss_path_34").AcceptInput("AddOutput", "OnPass " + tank_name + ",FireUser1,,0,-1", null, null)

    EntFireByHandle(tank, "TeleportToPathTrack", "boss_path_1", 0, null, null)
    AddThinkToEnt(tank, "thinkTank")

    local startpos = tank.GetOrigin()

    SendGlobalGameEvent("show_annotation", {
        worldPosX = startpos.x
        worldPosY = startpos.y
        worldPosZ = startpos.z
        id = 0
        text = "Spawned by " + donorname +": Tank shrinks and speeds up with health lost!"
        lifetime = 3.0
    })

    return tank
}

function thinkTank ()
{
    local health_left = self.GetHealth().tofloat() / self.GetMaxHealth().tofloat()
    self.SetModelScale(clamp(health_left, 0.25, 1), 0.0)
    self.AcceptInput("SetSpeed", "" + 80.0 * (3 - health_left * 2), self, self)
    return 0.1
}

// ::testClampTank <- function () {
//     local tank = Entities.FindByClassname(null, "tank_boss")
//     printl(tank.GetMaxHealth())
//     printl(tank.GetHealth())
//     local health_left =
//     printl(health_left)
//     printl(clamp(health_left, 0.25, 1))
// }

function SpawnHorseman(donorname, teamnum) {
    local hhh = Entities.FindByClassname(null, "headless_hatman")

    if (hhh != null)
    {
        local hhhpos = hhh.GetOrigin()
        hhh.SetHealth(hhh.GetHealth() + 5000)
        hhh.SetMaxHealth(hhh.GetHealth())
        SendGlobalGameEvent("show_annotation", {
            worldPosX = hhhpos.x
            worldPosY = hhhpos.y
            worldPosZ = hhhpos.z
            id = 0
            text = "" + donorname + " gave the Horseman +5000 HP!"
            lifetime = 3.0
        })
        return hhh
    }

    local hhh_name = DoUniqueString("yoinkedbees_hhh");
    hhh = SpawnEntityFromTable("headless_hatman", {
        targetname = hhh_name,
        team = teamnum,
    })

    EntFireByHandle(hhh, "RunsScriptCode", "self.SetMaxHealth(5000)", 0, hhh, hhh)
    EntFireByHandle(hhh, "RunsScriptCode", "self.SetHealth(5000)", 0, hhh, hhh)

    local glow = SpawnEntityFromTable("tf_glow", {
        target = "bignet",
        GlowColor = "255 0 255 255",
        mode = 0
    })
    NetProps.SetPropEntity(glow, "m_hTarget", hhh)

    for (local entity; entity = Entities.FindByClassname(entity, "prop_dynamic");)
    {
        if (entity.GetModelName() == "models/weapons/c_models/c_bigaxe/c_bigaxe.mdl")
            entity.SetModel("models/weapons/c_models/c_big_mallet/c_big_mallet.mdl")
    }
    local pathpos = Entities.FindByName(null, "boss_path_1b").GetOrigin()
    local startpos = Vector(pathpos.x, pathpos.y - 1700, pathpos.z + 50)
    hhh.SetAbsOrigin(startpos)
    SendGlobalGameEvent("show_annotation", {
        worldPosX = startpos.x
        worldPosY = startpos.y
        worldPosZ = startpos.z
        id = 0
        text = "" + donorname + " has summoned the Horseless Headless Horseman!"
        lifetime = 3.0
    })
    AddThinkToEnt(hhh, "hhhHealthBarThink")
    return hhh
}

function hhhHealthBarThink() {
    if (MONSTER_RESOURCE) // Check if the health bar entity exists, just in case to prevent errors
    {
        local healthratio = self.GetHealth().tofloat() / self.GetMaxHealth().tofloat()
        NetProps.SetPropInt(MONSTER_RESOURCE, "m_iBossHealthPercentageByte", healthratio * 255)
    }
}
