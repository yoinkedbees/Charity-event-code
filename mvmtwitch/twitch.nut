IncludeScript("mvmtwitch/defines.nut")
IncludeScript("mvmtwitch/gameevents.nut")
IncludeScript("mvmtwitch/rtd.nut")
// IncludeScript("mvmtwitch/buster.nut")


// this is called by the mix it up bot 


    
function twitchHandler(username, amount, message) {
    ClientPrint(null, 3, "\x07ffffff[\x07ff00ffTwitch Integration\x07ffffff] \x07FF3F3F" + username + " \x01donated: \x03$" + amount/100 + " \x01with message: " + message)
    switch (amount) {
        case 500:// $5.00 RTD plugin. Handled by rtd.nut 
            ClientPrint(null, 3, "\x07FF3F3F" + username + "\x01 donated \x03$" + amount/100 + "\x01, triggering rtd on a random player!!")
            ApplyRTD(getRandomPlayer())
            break;
        case 1500: // $12.00 Spawns the horseman (make sure the map you are on has nav mesh and can handle this guy) 
            ClientPrint(null, 3, "\x07FF3F3F" + username + "\x01 donated \x03$" + amount/100 + "\x01, spawning the horseman!")
            SpawnHorseman(username, Constants.ETFTeam.TF_TEAM_PVE_INVADERS)
            break;
        case 2000://$20.00 Turns a random player onto the enemy team (in this code that is the robots) 
            local player = getRandomPlayer()
            ChangePlayerTeamMvM(player, Constants.ETFTeam.TF_TEAM_PVE_INVADERS) //Constants.ETFTeam.TF_TEAM_BLUE is also perfectly valid
            DoEntFire("!self", "RunScriptCode", "self.ForceRespawn()", 0, null, player);
            ClientPrint(null, 3, "\x07FF3F3F" + username + "\x01 donated \x03$" + amount/100 + "\x01, switching to robot!")
            printl("case for 20 dollars")
            break;
        case 2500: //$25.00 Randomises gravity (no time duration on this)
            Convars.SetValue("sv_gravity", RandomInt(0, 500))
            ClientPrint(null, 3, "\x07FF3F3F" + username + "\x01 donated \x03$" + amount/100 + "\x01, randomising gravity!")
            printl("case for 25 dollars")
            break;
        case 3000: //$30.00 spawwns a tank that gets faster and smaller the more you damage it (rome mode wwill sorta break this) 
            SpawnTank(username)
            ClientPrint(null, 3, "\x07FF3F3F" + username + "\x01 donated \x03$" + amount/100 + "\x01, spawning a tank!!")
            printl("case for 30 dollars")
            break;
        case 5000://$50.00 restarts the game 
            ClientPrint(null, 3, "\x07FF3F3F" + username + "\x01 donated \x03$" + amount/100 + "\x01, Restarted the round!!")
            Convars.SetValue("mp_restartgame", 5)
            break;
    }
}
