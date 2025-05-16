# paste this into a script action for "Twitch Channel Charity Donation"

from rcon.source import Client

def run():
    with Client('127.0.0.1', 27015, passwd="value of rcon_password") as client:
        response = client.run('script', 'twitchHandler("$username", $donationamountnumberdigits, "$donationmessage")')
    return(response)

print(run())
