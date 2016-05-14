# MyHero Demo Spark Bot Setup

[Back to MyHero Demo Setup](./README.md)

![MyHero SparkBot](diagrams/sparkbot-i1.png)


## Prerequisites

In order to leverage this demonstration, should have already installed the base MyHero Demo app and have the Data and App Services up and Operational.

## Spark Developer Account Requirement
In order to use this service, you will need a Cisco Spark Account to use for the bot.  You can leverage your personal Spark Account or create a new one to be used by the service.  I recommend creating a new one to make testing easier (i.e. if you use your own it will be hard to chat with yourself).

Creating an account is free and only requires a working email account (each Spark Account needs a unique email address).  Visit [http://www.ciscospark.com](http://www.ciscospark.com) to signup for an account.

Developer access to Spark is also free and information is available at [http://developer.ciscospark.com](http://developer.ciscospark.com).

In order to access the APIs of Spark, this bot needs the Developer Token for your account.  To find it:

* Go to [http://developer.ciscospark.com](http://developer.ciscospark.com) and login with the credentials for your account.
* In the upper right corner click on your picture and click `Copy` to copy your Access Token to your clipboard
* Make a note of this someplace for when you need it later in the setup
  * **If you save this in a file, such as in the `Vagrantfile` you create later, be sure not to commit this file.  Otherwise your credentials will be availabe to anyone who might look at your code later on GitHub.**


## Setup

* Run `source myhero_setup` to enter and record the address, application domain, username, and password for your Mantl instance as non-persistent Environment Variables.  This means you will need to run this command everytime you open an new terminal session.
  * If you've already run this to install the MyHero Demo web, app, and data services, you do NOT need to run again.
* Run `source spark_setup` to enter your Spark Email Account and Token that will be saved as non-persistent Environment Variables.  This means you will need to run this command everytime you open a new terminal instance.


## Install

* Run `./spark-install.sh` to deploy all the "spark" service into your running "myhero" application in your Mantl cluster.

* After running the install it will take a 2-5 minutes for the service to fully deploy and become "healthy".  You can monitor this in the Marathon Web GUI.

* At first run, the spark bot will create a new room called "MyHero Demo".  If you are using your own account, you will see this in your Spark Client.  If you built a new Spark Account for the bot, you'll want to add yourself to the room so you can interact with the bot.
  * Execute this curl command to add your own email to the room.  (replace **EMAIL_ADDRESS** with your email.  )
  * `curl -X PUT -H "key: SecureBot" http://myhero-spark.$MANTL_DOMAIN/demoroom/members -d '{"email":"EMAIL_ADDRESS"}'`
* You can view list of users in the room
  * `curl -X GET -H "key: SecureBot" http://myhero-spark.$MANTL_DOMAIN/demoroom/members`


## Interacting with the Spark Bot
The Spark Bot is a very simple interface that is designed to make it intuitive to use.  Once in the room, simply say "hello", "help" (or anything else) to have the bot reply back with some instructions on how to access the features.

The bot is deisgned to look for key words to act on, and provide the basic help message for anything else.  The key words are:

* options
  * return a list of the current available options to vote on
* results
  * list the current status of voting results
* vote
  * send a private message to the sender to start a voting session
  * in the private room typing the name of one of the options will register a vote and end the session

An additional keyword of "add email" is also looked for.  This will have the bot add new users to the room.  Examples are:
* `add email joe@domain.intra`
  * add single user to the room
* `add emails joe@domain.intra, jane@domain.intra, bob@domain.intra`
  * add each of the three listed emails to the room

## Uninstallation

Run `./spark-uninstall.sh` to remove the Spark Bot from Marathon.  __At this time, no cleanup on rooms, webhooks, or messages in Spark is done__.
