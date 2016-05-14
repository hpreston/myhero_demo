# MyHero Tropo App Setup

[Back to MyHero Demo Setup](./README.md)

![MyHero Tropo Service](diagrams/troposervice-i1.png)

## Prerequisites

In order to leverage this demonstration, should have already installed the base MyHero Demo app and have the Data and App Services up and Operational.

## Cisco Tropo Account Requirement
In order to use this service, you will need a Cisco Tropo Account deploy the service.

Creating an account is free and only requires a working email account.  Visit [http://www.tropo.com](http://www.tropo.com) to signup for an account.

Developer usage of Tropo is also free and information is available at [http://www.tropo.com](http://www.tropo.com).

In order to build the Tropo Application, this bot needs the Username and Password for your Tropo Account.

## Setup

* Run `source myhero_setup` to enter and record the address, application domain, username, and password for your Mantl instance as non-persistent Environment Variables.  This means you will need to run this command everytime you open an new terminal session.
  * If you've already run this to install the MyHero Demo web, app, and data services, you do NOT need to run again.
* Run `source tropo_setup` to enter your Tropo Username and Password, as well as the phone number prefix you wish to use for your TXT interface.  These details will be saved as non-persistent Environment Variables.  This means you will need to run this command everytime you open a new terminal instance.


## Install

* Run `./tropo-install.sh` to deploy all the "tropo" service into your running "myhero" application in your Mantl cluster.

* After running the install it will take a 2-5 minutes for the service to fully deploy and become "healthy".  You can monitor this in the Marathon Web GUI.

* At first run, the tropo service will create a new Tropo Applciation called "myherodemo".  You can use log into the Tropo interface to verify this application and details.
* The service has API endpoints to return details about the Tropo Application.
  * Execute this curl command to get details on the Tropo Application
  * `curl -H "key: SecureTropo" http://myhero-tropo.$MANTL_DOMAIN/application`
  * Execute this curl command to get the phone number assigned to the Tropo Application
  * `curl -H "key: SecureTropo" http://myhero-tropo.$MANTL_DOMAIN/application/number`

## Interacting with the Tropo Application
The Tropo Application is a very simple interface that is designed to make it intuitive to use.  Once in the room, simply say "hello", "help" (or anything else) to have the bot reply back with some instructions on how to access the features.

Start by sending a TXT (SMS) message to the phone number assigned to the application.
* This number can be found in the Tropo Web Portal or with this command
  * `curl -H "key: SecureTropo" http://myhero-tropo.$MANTL_DOMAIN/application/number`

The Application is designed to look for key words to act on, and provide the basic help message for anything else.  The key words are:

* options
  * return a list of the current available options to vote on
* results
  * list the current status of voting results
* vote **Option**
  * register a vote for the identified option

## Uninstallation

Run `./tropo-uninstall.sh` to remove the Tropo Service from Marathon.  __At this time, no cleanup inside of Tropo (deletion of the applciation) is done automatically__.
