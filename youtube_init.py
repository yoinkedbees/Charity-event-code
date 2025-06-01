#paste this into a script action for "Youtube Super Chat"
from rcon.source import Client

def run():
    with Client('127.0.0.1', 27015, passwd="yourpasswordhere") as client:
        response = client.run('script', 'twitchHandler("$username", $amountnumberdigits, "$message")')
    return(response)

print(run())
