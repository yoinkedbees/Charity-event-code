#paste this into events/ youtube super chat on mixitup
from rcon.source import Client

def run():
    # Your code goes here
    with Client('127.0.0.1', 27015, passwd="yourpasswordhere") as client:
        response = client.run('script', 'twitchHandler("$username", $donationamountnumberdigits, "$donationmessage")')
    return(response)

print(run())
