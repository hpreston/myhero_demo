#! /usr/bin/python
'''
Simple Python Utility to check details from Cisco Tropo for deploying apps.

Supported Tasks:
  ./tropo_utils.py numbercheck <prefix>
    - See if there are available numbers for a given prefix
  ./tropo_utils.py applicationcheck <application name>
    - See if there is already a created application of a given name
  ./tropo_utils.py listprefixes <count>
    - Return a list of supported prefixes
'''


import urllib2, json, sys, os

# Tropo Utilities
def get_applications():
    tropo_u = tropo_host + "/applications"

    output = urllib2.urlopen(tropo_u)
    applications = json.loads(output.read())

    return applications

def test_application(applicationname):
    applications = get_applications()
    for application in applications:
        if application["name"] == applicationname:
            return True
    return False

def get_application_addresses(application):
    tropo_u = tropo_host + "/applications/%s/addresses" % (application["id"])
    output = urllib2.urlopen(tropo_u)
    addresses = json.loads(output.read())
    return addresses

def get_exchanges():
    # Example Exchange
    # {u'amountNumbersToOrder': 25,
    #  u'areaCode': u'443',
    #  u'city': u'Aberdeen',
    #  u'country': u'United States',
    #  u'countryDialingCode': u'1',
    #  u'description': u'',
    #  u'href': u'https://api.tropo.com/rest/v1/exchanges/2142',
    #  u'id': 2142,
    #  u'minNumbersInExchange': 10,
    #  u'prefix': u'1443',
    #  u'requiresVerification': False,
    #  u'state': u'MD',
    #  u'tollFree': False}
    tropo_u = tropo_host + "/exchanges"
    output = urllib2.urlopen(tropo_u)
    exchanges = json.loads(output.read())
    return exchanges

def get_available_numbers(exchange):
    # Example Exchange
    #  {u'city': u'Aberdeen',
    # u'country': u'United States',
    # u'displayNumber': u'+1 443-863-7082',
    # u'href': u'https://api.tropo.com/rest/v1/addresses/number/+14438637082',
    # u'number': u'+14438637082',
    # u'prefix': u'1443',
    # u'smsEnabled': True,
    # u'state': u'MD',
    # u'subscriber': False,
    # u'type': u'number'}
    tropo_u = tropo_host + "/addresses?available=true&type=NUMBER&prefix=%s" % (exchange)

    output = urllib2.urlopen(tropo_u)

    numbers = json.loads(output.read())
    sms_numbers = []
    for number in numbers:
        if number["smsEnabled"]:
            sms_numbers.append(number)
    return sms_numbers

def test_exchange(exchange):
    exchanges = get_available_numbers(exchange)
    if len(exchanges) > 0:
        return True
    else:
        return False

# Utility Functions
def chelp():
    print("Supported Commands are:")
    print("\tnumbercheck <prefix>")
    print("\tapplicationcheck <application name>")
    print("\tlistprefixes <count>")


tropo_host = "https://api.tropo.com/v1"
tropo_server = "api.tropo.com"
tropo_headers = {}
tropo_headers["Content-type"] = "application/json"

try:
    tropo_user = os.environ["TROPO_USER"]
    tropo_pass = os.environ["TROPO_PASS"]
    command = sys.argv[1]
    input = sys.argv[2]
except:
    print("Command takes 2 parameters.  First is the command, second is the input to command.")
    chelp()
    sys.exit(1)

authinfo = urllib2.HTTPPasswordMgrWithDefaultRealm()
authinfo.add_password(None, tropo_server, tropo_user, tropo_pass)
handler = urllib2.HTTPBasicAuthHandler(authinfo)
myopener = urllib2.build_opener(handler)
opened = urllib2.install_opener(myopener)

if command == "numbercheck":
    numbers = get_available_numbers(input)
    if test_exchange(input):
        # print("All Good!")
        sys.exit(0)
    else:
        # print("No available numbers at that prefix.")
        sys.exit(1)
if command == "applicationcheck":
    if test_application(input):
        # print("Application called %s Found." % (input))
        sys.exit(0)
    else:
        # print("No application named %s found." %(input))
        sys.exit(1)
if command == "listprefixes":
    exchanges = get_exchanges()
    prefixes = []
    # print("Available Exchanges to try: ")
    for exchange in exchanges:
        if len(prefixes) < int(input):
            prefixes.append(exchange["prefix"])
            print(exchange["prefix"])
else:
    print("Command Not Understood.")
    chelp()

