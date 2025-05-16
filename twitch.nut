function twitchHandler(username, amount, message) {
    ClientPrint(null, 3, "\x07ffffff[\x07ff00fftwitch intergration\x07ffffff] \x07FF3F3F" + username + " \x01donated: \x03$" + amount/100 + " \x01with message: " + message)
    switch (amount) {
        case 1250: // $12.50
            ClientPrint(null, 3, "\x07FF3F3F" + username + "\x01 donated \x03$" + amount/100 + "\x01, spawning merasmus")
            local ass = SpawnEntityFromTable("merasmus", {})
            ass.SetOrigin(Vector(0, 0, 1000))
            break;
        case 2000: // $20.00
            printl("case for 20 dollars")
            break;
    }
}
