::MAX_WEAPONS <- 8
::MAX_PLAYERS <- MaxClients().tointeger()
::TF_GAMERULES <- Entities.FindByClassname(null, "tf_gamerules")
::MONSTER_RESOURCE <- Entities.FindByClassname(null, "monster_resource")

::GLOBALTHINKENT <- Entities.CreateByClassname("info_target");
AddThinkToEnt(GLOBALTHINKENT, "globalThink");

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

::clearCosmetics <- function()
{
    for (local wearable = self.FirstMoveChild(); wearable != null; wearable = wearable.NextMovePeer())
    {
        if(wearable.IsValid() != true)
            continue

        if(wearable.GetClassname() != "tf_wearable" && wearable.GetClassname() != "tf_wearable_campaign_item" && wearable.GetClassname() != "tf_powerup_bottle" && wearable.GetClassname() != "tf_wearable_demoshield")
        {
            continue
        }

        if(wearable != null)
        {
            EntFireByHandle(wearable, "Kill", "", -1, null, null)
        }
    }
}

::ChangePlayerTeamMvM <- function(player, teamnum)
{
	NetProps.SetPropBool(TF_GAMERULES, "m_bPlayingMannVsMachine", false)
	player.ForceChangeTeam(teamnum, false)
	NetProps.SetPropBool(TF_GAMERULES, "m_bPlayingMannVsMachine", true)
}

::SpawnTank <- function (donorname) {
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

::SpawnHorseman <- function(donorname, teamnum) {
    local hhh = Entities.FindByClassname(null, "headless_hatman")

    if (hhh != null)
    {
        local hhhpos = hhh.GetOrigin()
        hhh.SetHealth(hhh.GetHealth() + 10000)
        SendGlobalGameEvent("show_annotation", {
            worldPosX = hhhpos.x
            worldPosY = hhhpos.y
            worldPosZ = hhhpos.z
            id = 0
            text = "" + donorname + " gave the Horseman +3000 HP!"
            lifetime = 3.0
        })
        return hhh
    }

    local hhh_name = DoUniqueString("yoinkedbees_hhh");
    hhh = SpawnEntityFromTable("headless_hatman", {
        targetname = hhh_name,
        team = teamnum,
        health = 10000
    })

    local glow = SpawnEntityFromTable("tf_glow", {
        target = "bignet", GlowColor = "255 0 255 255"
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